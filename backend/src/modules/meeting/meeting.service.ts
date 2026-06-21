import { Injectable, NotFoundException, ForbiddenException, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { LiveKitService } from '../livekit/livekit.service';
import { StorageService } from '../storage/storage.service';
import { NotificationService } from '../notification/notification.service';
import { EventService } from '../event/event.service';
import { MeetingStatus, MeetingType, MeetingParticipantRole, MeetingActionItemStatus, MeetingInsightType, CalendarProvider, RecordingStatus, NotificationType } from '@prisma/client';
import { Queue } from 'bullmq';

@Injectable()
export class MeetingService {
  private reminderQueue: Queue;

  constructor(
    private prisma: PrismaService,
    private liveKitService: LiveKitService,
    private storageService: StorageService,
    private notificationService: NotificationService,
    private eventService: EventService,
  ) {
    const redisHost = process.env.REDIS_HOST || 'localhost';
    const redisPort = parseInt(process.env.REDIS_PORT || '6379');

    this.reminderQueue = new Queue('meeting-reminders', {
      connection: { host: redisHost, port: redisPort },
    });
  }

  // --- MEETING LIFECYCLE ---

  async createMeeting(
    userId: string,
    data: {
      workspaceId: string;
      projectId?: string;
      taskId?: string;
      title: string;
      description?: string;
      meetingType: MeetingType;
      schedule?: { startTime: Date; endTime: Date; timezone?: string; recurrenceRule?: string };
    },
  ) {
    const roomName = `meet-${userId.substring(0, 4)}-${Math.random().toString(36).substring(2, 6).toUpperCase()}`;

    return this.prisma.$transaction(async (tx) => {
      // 1. Create meeting entry
      const meeting = await tx.meeting.create({
        data: {
          workspaceId: data.workspaceId,
          projectId: data.projectId || null,
          taskId: data.taskId || null,
          title: data.title,
          description: data.description || null,
          meetingType: data.meetingType,
          status: MeetingStatus.SCHEDULED,
          hostId: userId,
          roomName,
        },
      });

      // 2. Add creator as HOST participant
      await tx.meetingParticipant.create({
        data: {
          meetingId: meeting.id,
          userId,
          role: MeetingParticipantRole.HOST,
        },
      });

      // 3. Create schedule & calendar event if provided
      if (data.schedule) {
        const { startTime, endTime, timezone, recurrenceRule } = data.schedule;

        await tx.meetingSchedule.create({
          data: {
            meetingId: meeting.id,
            startTime,
            endTime,
            timezone: timezone || 'UTC',
            recurrenceRule: recurrenceRule || null,
          },
        });

        await tx.calendarEvent.create({
          data: {
            meetingId: meeting.id,
            workspaceId: data.workspaceId,
            title: data.title,
            startTime,
            endTime,
            provider: CalendarProvider.INTERNAL,
          },
        });

        // Register delayed notification job in BullMQ (10 minutes before startTime)
        const delay = new Date(startTime).getTime() - Date.now() - 10 * 60 * 1000;
        if (delay > 0) {
          await this.reminderQueue.add(
            'meeting:reminder',
            { meetingId: meeting.id, title: data.title },
            { delay, attempts: 3 },
          );
        }
      }

      // Dispatch search index
      await this.eventService.dispatch('search-indexing', 'meeting:index', {
        entityType: 'meeting',
        entityId: meeting.id,
        payload: {
          title: meeting.title,
          description: meeting.description,
          roomName: meeting.roomName,
          workspaceId: meeting.workspaceId,
          projectId: meeting.projectId,
        },
      });

      return meeting;
    });
  }

  async getMeetings(workspaceId: string, userId: string) {
    return this.prisma.meeting.findMany({
      where: { workspaceId },
      include: {
        host: { select: { id: true, fullName: true, avatarUrl: true } },
        participants: { include: { user: { select: { id: true, fullName: true } } } },
      },
      orderBy: { createdAt: 'desc' },
    });
  }

  async getMeeting(id: string) {
    const meeting = await this.prisma.meeting.findUnique({
      where: { id },
      include: {
        host: { select: { id: true, fullName: true, avatarUrl: true } },
        participants: { include: { user: { select: { id: true, fullName: true, avatarUrl: true } } } },
        actionItems: { include: { assignee: { select: { id: true, fullName: true } } } },
        decisions: { include: { creator: { select: { id: true, fullName: true } } } },
        notes: true,
        recordings: true,
        transcripts: true,
        schedules: true,
        summaries: true,
        insights: true,
      },
    });
    if (!meeting) throw new NotFoundException('Meeting not found');
    return meeting;
  }

  async startMeeting(id: string, userId: string) {
    const meeting = await this.getMeeting(id);
    if (meeting.hostId !== userId) throw new ForbiddenException('Only the host can start this meeting');
    if (meeting.status === MeetingStatus.ACTIVE) return meeting;

    // Create LiveKit Room
    await this.liveKitService.createRoom(meeting.roomName);

    const updated = await this.prisma.meeting.update({
      where: { id },
      data: {
        status: MeetingStatus.ACTIVE,
        startedAt: new Date(),
      },
    });

    // Notify participants
    for (const p of meeting.participants) {
      if (p.userId !== userId) {
        await this.notificationService.createNotification(
          p.userId,
          NotificationType.MEETING_STARTED,
          'Meeting Started',
          `The meeting "${meeting.title}" has started. Join now!`,
          'MEETING',
          meeting.id,
        );
      }
    }

    return updated;
  }

  async endMeeting(id: string, userId: string) {
    const meeting = await this.getMeeting(id);
    if (meeting.hostId !== userId) throw new ForbiddenException('Only the host can end this meeting');
    if (meeting.status === MeetingStatus.COMPLETED) return meeting;

    // Tear down LiveKit Room
    try {
      await this.liveKitService.deleteRoom(meeting.roomName);
    } catch (_) {}

    return this.prisma.$transaction(async (tx) => {
      // 1. Update meeting status
      const updated = await tx.meeting.update({
        where: { id },
        data: {
          status: MeetingStatus.COMPLETED,
          endedAt: new Date(),
        },
      });

      // 2. Compute attendance duration for remaining joined users
      const activeParticipants = await tx.meetingParticipant.findMany({
        where: { meetingId: id, leftAt: null },
      });

      const now = new Date();
      for (const p of activeParticipants) {
        const duration = Math.floor((now.getTime() - new Date(p.joinedAt).getTime()) / 1000);
        await tx.meetingParticipant.update({
          where: { id: p.id },
          data: {
            leftAt: now,
            durationSeconds: duration,
          },
        });
      }

      return updated;
    });
  }

  // --- PARTICIPATION ---

  async joinMeeting(id: string, userId: string, userName: string) {
    const meeting = await this.prisma.meeting.findUnique({
      where: { id },
      include: { participants: true },
    });
    if (!meeting) throw new NotFoundException('Meeting not found');

    // 1. Upsert attendance participation record
    const existing = meeting.participants.find((p) => p.userId === userId);
    let role: MeetingParticipantRole = MeetingParticipantRole.ATTENDEE;
    if (meeting.hostId === userId) role = MeetingParticipantRole.HOST;

    if (!existing) {
      await this.prisma.meetingParticipant.create({
        data: {
          meetingId: id,
          userId,
          role,
          joinedAt: new Date(),
        },
      });
    } else {
      await this.prisma.meetingParticipant.update({
        where: { id: existing.id },
        data: { joinedAt: new Date(), leftAt: null, durationSeconds: null },
      });
    }

    // 2. Generate LiveKit JWT connection token
    const token = this.liveKitService.generateToken(meeting.roomName, userId, userName, role);

    return { token, roomName: meeting.roomName };
  }

  async leaveMeeting(id: string, userId: string) {
    const participant = await this.prisma.meetingParticipant.findFirst({
      where: { meetingId: id, userId },
    });
    if (!participant) return { success: true };

    const leftAt = new Date();
    const durationSeconds = Math.floor((leftAt.getTime() - new Date(participant.joinedAt).getTime()) / 1000);

    await this.prisma.meetingParticipant.update({
      where: { id: participant.id },
      data: { leftAt, durationSeconds },
    });

    return { success: true };
  }

  // --- ACTION ITEMS & DECISIONS ---

  async createActionItem(
    meetingId: string,
    data: { title: string; description?: string; assigneeId?: string; dueDate?: Date; taskId?: string },
  ) {
    const actionItem = await this.prisma.meetingActionItem.create({
      data: {
        meetingId,
        title: data.title,
        description: data.description || null,
        assigneeId: data.assigneeId || null,
        dueDate: data.dueDate || null,
        status: MeetingActionItemStatus.OPEN,
        taskId: data.taskId || null,
      },
    });

    // Index action item into OpenSearch
    await this.eventService.dispatch('search-indexing', 'meeting-action-item:index', {
      entityType: 'meeting-action-item',
      entityId: actionItem.id,
      payload: {
        title: actionItem.title,
        description: actionItem.description,
        meetingId,
        assigneeId: actionItem.assigneeId,
      },
    });

    return actionItem;
  }

  async logDecision(meetingId: string, createdBy: string, decision: string) {
    const dec = await this.prisma.meetingDecision.create({
      data: {
        meetingId,
        decision,
        createdBy,
      },
    });

    // Index decision into OpenSearch
    await this.eventService.dispatch('search-indexing', 'meeting-decision:index', {
      entityType: 'meeting-decision',
      entityId: dec.id,
      payload: {
        decision: dec.decision,
        meetingId,
        createdBy,
      },
    });

    return dec;
  }

  // --- TRANSCRIPTS & SEARCH ---

  async logTranscript(meetingId: string, content: string, language = 'en') {
    const transcript = await this.prisma.meetingTranscript.create({
      data: { meetingId, content, language },
    });

    // Index transcript into OpenSearch
    await this.eventService.dispatch('search-indexing', 'meeting-transcript:index', {
      entityType: 'meeting-transcript',
      entityId: transcript.id,
      payload: {
        content: transcript.content,
        meetingId,
      },
    });

    return transcript;
  }

  // --- WAITING ROOM ---

  async requestWaitingRoom(meetingId: string, userId: string) {
    return this.prisma.meetingWaitingRoom.create({
      data: { meetingId, userId },
    });
  }

  async approveWaitingRoom(meetingId: string, userId: string, actorId: string) {
    const meeting = await this.prisma.meeting.findUnique({ where: { id: meetingId } });
    if (!meeting) throw new NotFoundException('Meeting not found');
    if (meeting.hostId !== actorId) throw new ForbiddenException('Only the host can approve waiting room entries');

    await this.prisma.meetingWaitingRoom.updateMany({
      where: { meetingId, userId },
      data: { approvedAt: new Date(), approvedBy: actorId },
    });

    return { success: true };
  }

  async rejectWaitingRoom(meetingId: string, userId: string, actorId: string) {
    const meeting = await this.prisma.meeting.findUnique({ where: { id: meetingId } });
    if (!meeting) throw new NotFoundException('Meeting not found');
    if (meeting.hostId !== actorId) throw new ForbiddenException('Only the host can reject waiting room entries');

    await this.prisma.meetingWaitingRoom.deleteMany({
      where: { meetingId, userId },
    });

    return { success: true };
  }

  // --- BREAKOUT ROOMS ---

  async createBreakoutRooms(meetingId: string, count: number) {
    const rooms = [];
    for (let i = 0; i < count; i++) {
      const room = await this.prisma.breakoutRoom.create({
        data: { meetingId, name: `Breakout Room ${i + 1}` },
      });
      rooms.push(room);
    }
    return rooms;
  }

  async assignBreakoutParticipant(breakoutRoomId: string, userId: string) {
    return this.prisma.breakoutRoomParticipant.upsert({
      where: { breakoutRoomId_userId: { breakoutRoomId, userId } },
      update: {},
      create: { breakoutRoomId, userId },
    });
  }

  // --- RECORDINGS ---

  async registerRecording(meetingId: string, durationSeconds: number, buffer: Buffer, mimeType = 'video/mp4') {
    const fileName = `rec-${meetingId}-${Date.now()}.mp4`;
    const bucketPath = await this.storageService.uploadFile(
      'teamos-recordings',
      fileName,
      buffer,
      buffer.length,
      mimeType,
    );

    const recording = await this.prisma.meetingRecording.create({
      data: {
        meetingId,
        duration: durationSeconds,
        status: RecordingStatus.COMPLETED,
        playbackUrl: bucketPath,
        downloadUrl: bucketPath,
      },
    });

    return recording;
  }

  // --- MEETING ANALYTICS ---

  async getMeetingAnalytics(meetingId: string) {
    const meeting = await this.getMeeting(meetingId);
    
    // Attendance rate
    const participants = meeting.participants;
    const totalCount = participants.length;
    const completedAttendees = participants.filter((p) => p.leftAt !== null);

    const avgDuration = completedAttendees.length > 0
      ? completedAttendees.reduce((acc, curr) => acc + (curr.durationSeconds || 0), 0) / completedAttendees.length
      : 0;

    const actionItemsCount = meeting.actionItems.length;
    const decisionsCount = meeting.decisions.length;

    return {
      attendanceRate: totalCount > 0 ? (completedAttendees.length / totalCount) * 100 : 0,
      averageDurationSeconds: avgDuration,
      actionItemsCreatedCount: actionItemsCount,
      decisionsLoggedCount: decisionsCount,
      teamCollaborationScore: totalCount > 1 ? 85 : 40, // Mock collaborative score calculations
      effectivenessScore: actionItemsCount + decisionsCount > 0 ? 90 : 50,
    };
  }
}
