import { Controller, Post, Get, Put, Delete, Body, Param, UseGuards, Headers, Req } from '@nestjs/common';
import { MeetingService } from './meeting.service';
import { WorkspaceAuthGuard } from '../../common/guards/workspace-auth.guard';
import { MeetingType } from '@prisma/client';

@Controller('meetings')
@UseGuards(WorkspaceAuthGuard)
export class MeetingController {
  constructor(private meetingService: MeetingService) {}

  @Post()
  async createMeeting(
    @Headers('x-workspace-id') workspaceId: string,
    @Req() req: any,
    @Body() body: {
      projectId?: string;
      taskId?: string;
      title: string;
      description?: string;
      meetingType: MeetingType;
      schedule?: { startTime: string; endTime: string; timezone?: string; recurrenceRule?: string };
    },
  ) {
    const userId = req.user.id;
    return this.meetingService.createMeeting(userId, {
      workspaceId,
      projectId: body.projectId,
      taskId: body.taskId,
      title: body.title,
      description: body.description,
      meetingType: body.meetingType,
      schedule: body.schedule
        ? {
            startTime: new Date(body.schedule.startTime),
            endTime: new Date(body.schedule.endTime),
            timezone: body.schedule.timezone,
            recurrenceRule: body.schedule.recurrenceRule,
          }
        : undefined,
    });
  }

  @Get()
  async getMeetings(
    @Headers('x-workspace-id') workspaceId: string,
    @Req() req: any,
  ) {
    const userId = req.user.id;
    return this.meetingService.getMeetings(workspaceId, userId);
  }

  @Get(':id')
  async getMeeting(@Param('id') id: string) {
    return this.meetingService.getMeeting(id);
  }

  @Post(':id/start')
  async startMeeting(@Param('id') id: string, @Req() req: any) {
    const userId = req.user.id;
    return this.meetingService.startMeeting(id, userId);
  }

  @Post(':id/end')
  async endMeeting(@Param('id') id: string, @Req() req: any) {
    const userId = req.user.id;
    return this.meetingService.endMeeting(id, userId);
  }

  @Post(':id/join')
  async joinMeeting(@Param('id') id: string, @Req() req: any) {
    const userId = req.user.id;
    const userName = req.user.fullName || 'User';
    return this.meetingService.joinMeeting(id, userId, userName);
  }

  @Post(':id/leave')
  async leaveMeeting(@Param('id') id: string, @Req() req: any) {
    const userId = req.user.id;
    return this.meetingService.leaveMeeting(id, userId);
  }

  // --- ACTION ITEMS & DECISIONS ---

  @Post(':id/action-items')
  async createActionItem(
    @Param('id') meetingId: string,
    @Body() body: { title: string; description?: string; assigneeId?: string; dueDate?: string; taskId?: string },
  ) {
    return this.meetingService.createActionItem(meetingId, {
      title: body.title,
      description: body.description,
      assigneeId: body.assigneeId,
      dueDate: body.dueDate ? new Date(body.dueDate) : undefined,
      taskId: body.taskId,
    });
  }

  @Post(':id/decisions')
  async logDecision(
    @Param('id') meetingId: string,
    @Req() req: any,
    @Body() body: { decision: string },
  ) {
    const userId = req.user.id;
    return this.meetingService.logDecision(meetingId, userId, body.decision);
  }

  // --- TRANSCRIPTS ---

  @Post(':id/transcripts')
  async logTranscript(
    @Param('id') meetingId: string,
    @Body() body: { content: string; language?: string },
  ) {
    return this.meetingService.logTranscript(meetingId, body.content, body.language || 'en');
  }

  // --- WAITING ROOM ---

  @Post(':id/waiting-room/approve')
  async approveWaitingRoom(
    @Param('id') meetingId: string,
    @Body() body: { userId: string },
    @Req() req: any,
  ) {
    const actorId = req.user.id;
    return this.meetingService.approveWaitingRoom(meetingId, body.userId, actorId);
  }

  @Post(':id/waiting-room/reject')
  async rejectWaitingRoom(
    @Param('id') meetingId: string,
    @Body() body: { userId: string },
    @Req() req: any,
  ) {
    const actorId = req.user.id;
    return this.meetingService.rejectWaitingRoom(meetingId, body.userId, actorId);
  }

  // --- BREAKOUT ROOMS ---

  @Post(':id/breakout-rooms')
  async createBreakoutRooms(
    @Param('id') meetingId: string,
    @Body() body: { count: number },
  ) {
    return this.meetingService.createBreakoutRooms(meetingId, body.count);
  }

  @Post('breakout-rooms/:id/join')
  async assignBreakoutParticipant(
    @Param('id') breakoutRoomId: string,
    @Req() req: any,
  ) {
    const userId = req.user.id;
    return this.meetingService.assignBreakoutParticipant(breakoutRoomId, userId);
  }

  // --- RECORDINGS ---

  @Post(':id/recording/start')
  async startRecording() {
    // Pipeline initialization triggers
    return { status: 'RECORDING_STARTED' };
  }

  @Post(':id/recording/stop')
  async stopRecording(
    @Param('id') meetingId: string,
    @Body() body: { durationSeconds: number; base64Data: string },
  ) {
    const buffer = Buffer.from(body.base64Data, 'base64');
    return this.meetingService.registerRecording(meetingId, body.durationSeconds, buffer);
  }

  // --- MEETING ANALYTICS ---

  @Get(':id/analytics')
  async getMeetingAnalytics(@Param('id') id: string) {
    return this.meetingService.getMeetingAnalytics(id);
  }
}
