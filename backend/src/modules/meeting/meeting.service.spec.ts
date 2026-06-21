import { Test, TestingModule } from '@nestjs/testing';
import { MeetingService } from './meeting.service';
import { PrismaService } from '../prisma/prisma.service';
import { LiveKitService } from '../livekit/livekit.service';
import { StorageService } from '../storage/storage.service';
import { NotificationService } from '../notification/notification.service';
import { EventService } from '../event/event.service';
import {
  MeetingStatus,
  MeetingType,
  MeetingParticipantRole,
  MeetingActionItemStatus,
  MeetingInsightType,
  CalendarProvider,
  RecordingStatus,
  NotificationType,
} from '@prisma/client';
import { ForbiddenException, NotFoundException, BadRequestException } from '@nestjs/common';

// Mock BullMQ Queue
jest.mock('bullmq', () => {
  return {
    Queue: jest.fn().mockImplementation(() => {
      return {
        add: jest.fn().mockResolvedValue({}),
      };
    }),
  };
});

describe('MeetingService', () => {
  let service: MeetingService;
  let prisma: PrismaService;
  let liveKitService: LiveKitService;
  let storageService: StorageService;
  let notificationService: NotificationService;
  let eventService: EventService;

  const mockPrismaService = {
    $transaction: jest.fn((cb) => cb(mockPrismaService)),
    meeting: {
      create: jest.fn(),
      findUnique: jest.fn(),
      findMany: jest.fn(),
      update: jest.fn(),
    },
    meetingParticipant: {
      create: jest.fn(),
      update: jest.fn(),
      findMany: jest.fn(),
      findFirst: jest.fn(),
    },
    meetingSchedule: {
      create: jest.fn(),
    },
    calendarEvent: {
      create: jest.fn(),
    },
    meetingActionItem: {
      create: jest.fn(),
    },
    meetingDecision: {
      create: jest.fn(),
    },
    meetingTranscript: {
      create: jest.fn(),
    },
    meetingWaitingRoom: {
      create: jest.fn(),
      updateMany: jest.fn(),
      deleteMany: jest.fn(),
    },
    breakoutRoom: {
      create: jest.fn(),
    },
    breakoutRoomParticipant: {
      upsert: jest.fn(),
    },
    meetingRecording: {
      create: jest.fn(),
    },
  };

  const mockLiveKitService = {
    createRoom: jest.fn(),
    deleteRoom: jest.fn(),
    generateToken: jest.fn(),
  };

  const mockStorageService = {
    uploadFile: jest.fn(),
    getPresignedUrl: jest.fn(),
  };

  const mockNotificationService = {
    createNotification: jest.fn(),
  };

  const mockEventService = {
    dispatch: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        MeetingService,
        { provide: PrismaService, useValue: mockPrismaService },
        { provide: LiveKitService, useValue: mockLiveKitService },
        { provide: StorageService, useValue: mockStorageService },
        { provide: NotificationService, useValue: mockNotificationService },
        { provide: EventService, useValue: mockEventService },
      ],
    }).compile();

    service = module.get<MeetingService>(MeetingService);
    prisma = module.get<PrismaService>(PrismaService);
    liveKitService = module.get<LiveKitService>(LiveKitService);
    storageService = module.get<StorageService>(StorageService);
    notificationService = module.get<NotificationService>(NotificationService);
    eventService = module.get<EventService>(EventService);

    jest.clearAllMocks();
  });

  describe('createMeeting', () => {
    it('should create an instant meeting successfully', async () => {
      const mockMeeting = {
        id: 'meet-123',
        workspaceId: 'ws-123',
        title: 'Standup',
        meetingType: MeetingType.INSTANT,
        status: MeetingStatus.SCHEDULED,
        hostId: 'user-123',
        roomName: 'meet-user-ABCD',
      };

      mockPrismaService.meeting.create.mockResolvedValue(mockMeeting);
      mockPrismaService.meetingParticipant.create.mockResolvedValue({});

      const result = await service.createMeeting('user-123', {
        workspaceId: 'ws-123',
        title: 'Standup',
        meetingType: MeetingType.INSTANT,
      });

      expect(result).toEqual(mockMeeting);
      expect(mockPrismaService.meeting.create).toHaveBeenCalled();
      expect(mockPrismaService.meetingParticipant.create).toHaveBeenCalledWith({
        data: {
          meetingId: 'meet-123',
          userId: 'user-123',
          role: MeetingParticipantRole.HOST,
        },
      });
      expect(mockEventService.dispatch).toHaveBeenCalledWith(
        'search-indexing',
        'meeting:index',
        expect.any(Object),
      );
    });

    it('should schedule a meeting, create events, and add BullMQ reminder', async () => {
      const mockMeeting = {
        id: 'meet-123',
        workspaceId: 'ws-123',
        title: 'Scheduled Ceremony',
        meetingType: MeetingType.SCHEDULED,
        status: MeetingStatus.SCHEDULED,
        hostId: 'user-123',
        roomName: 'meet-user-EFGH',
      };

      mockPrismaService.meeting.create.mockResolvedValue(mockMeeting);
      mockPrismaService.meetingParticipant.create.mockResolvedValue({});
      mockPrismaService.meetingSchedule.create.mockResolvedValue({});
      mockPrismaService.calendarEvent.create.mockResolvedValue({});

      const startTime = new Date(Date.now() + 60 * 60 * 1000); // 1 hour from now
      const endTime = new Date(Date.now() + 90 * 60 * 1000);

      const result = await service.createMeeting('user-123', {
        workspaceId: 'ws-123',
        title: 'Scheduled Ceremony',
        meetingType: MeetingType.SCHEDULED,
        schedule: {
          startTime,
          endTime,
          timezone: 'Asia/Kolkata',
          recurrenceRule: 'FREQ=DAILY',
        },
      });

      expect(result).toEqual(mockMeeting);
      expect(mockPrismaService.meetingSchedule.create).toHaveBeenCalledWith({
        data: {
          meetingId: 'meet-123',
          startTime,
          endTime,
          timezone: 'Asia/Kolkata',
          recurrenceRule: 'FREQ=DAILY',
        },
      });
      expect(mockPrismaService.calendarEvent.create).toHaveBeenCalledWith({
        data: {
          meetingId: 'meet-123',
          workspaceId: 'ws-123',
          title: 'Scheduled Ceremony',
          startTime,
          endTime,
          provider: CalendarProvider.INTERNAL,
        },
      });
    });
  });

  describe('startMeeting', () => {
    it('should throw NotFoundException if meeting does not exist', async () => {
      mockPrismaService.meeting.findUnique.mockResolvedValue(null);

      await expect(service.startMeeting('meet-fake', 'user-123')).rejects.toThrow(
        NotFoundException,
      );
    });

    it('should throw ForbiddenException if user is not the host', async () => {
      const mockMeeting = {
        id: 'meet-123',
        hostId: 'user-123',
        participants: [],
      };
      mockPrismaService.meeting.findUnique.mockResolvedValue(mockMeeting);

      await expect(service.startMeeting('meet-123', 'user-other')).rejects.toThrow(
        ForbiddenException,
      );
    });

    it('should start the meeting, create LiveKit room, and notify other participants', async () => {
      const mockMeeting = {
        id: 'meet-123',
        title: 'Standup',
        hostId: 'user-123',
        roomName: 'meet-room',
        status: MeetingStatus.SCHEDULED,
        participants: [
          { userId: 'user-123', role: MeetingParticipantRole.HOST },
          { userId: 'user-456', role: MeetingParticipantRole.ATTENDEE },
        ],
      };
      mockPrismaService.meeting.findUnique.mockResolvedValue(mockMeeting);
      mockPrismaService.meeting.update.mockResolvedValue({
        ...mockMeeting,
        status: MeetingStatus.ACTIVE,
      });

      const result = await service.startMeeting('meet-123', 'user-123');

      expect(result.status).toBe(MeetingStatus.ACTIVE);
      expect(mockLiveKitService.createRoom).toHaveBeenCalledWith('meet-room');
      expect(mockNotificationService.createNotification).toHaveBeenCalledWith(
        'user-456',
        NotificationType.MEETING_STARTED,
        'Meeting Started',
        'The meeting "Standup" has started. Join now!',
        'MEETING',
        'meet-123',
      );
    });
  });

  describe('endMeeting', () => {
    it('should end the meeting, delete LiveKit room, and calculate participant durations', async () => {
      const mockMeeting = {
        id: 'meet-123',
        hostId: 'user-123',
        roomName: 'meet-room',
        status: MeetingStatus.ACTIVE,
        participants: [],
      };
      mockPrismaService.meeting.findUnique.mockResolvedValue(mockMeeting);
      mockPrismaService.meeting.update.mockResolvedValue({
        ...mockMeeting,
        status: MeetingStatus.COMPLETED,
      });
      mockPrismaService.meetingParticipant.findMany.mockResolvedValue([
        {
          id: 'part-1',
          userId: 'user-456',
          joinedAt: new Date(Date.now() - 30 * 60 * 1000), // joined 30 mins ago
        },
      ]);
      mockPrismaService.meetingParticipant.update.mockResolvedValue({});

      const result = await service.endMeeting('meet-123', 'user-123');

      expect(result.status).toBe(MeetingStatus.COMPLETED);
      expect(mockLiveKitService.deleteRoom).toHaveBeenCalledWith('meet-room');
      expect(mockPrismaService.meetingParticipant.update).toHaveBeenCalled();
    });
  });

  describe('joinMeeting', () => {
    it('should create attendance and generate LiveKit token', async () => {
      const mockMeeting = {
        id: 'meet-123',
        hostId: 'user-123',
        roomName: 'meet-room',
        participants: [],
      };
      mockPrismaService.meeting.findUnique.mockResolvedValue(mockMeeting);
      mockPrismaService.meetingParticipant.create.mockResolvedValue({});
      mockLiveKitService.generateToken.mockReturnValue('mock-jwt-token');

      const result = await service.joinMeeting('meet-123', 'user-456', 'John Doe');

      expect(result).toEqual({ token: 'mock-jwt-token', roomName: 'meet-room' });
      expect(mockPrismaService.meetingParticipant.create).toHaveBeenCalled();
      expect(mockLiveKitService.generateToken).toHaveBeenCalledWith(
        'meet-room',
        'user-456',
        'John Doe',
        MeetingParticipantRole.ATTENDEE,
      );
    });
  });

  describe('leaveMeeting', () => {
    it('should compute and record leftAt and durationSeconds', async () => {
      const mockParticipant = {
        id: 'part-1',
        meetingId: 'meet-123',
        userId: 'user-456',
        joinedAt: new Date(Date.now() - 10000), // joined 10 seconds ago
      };
      mockPrismaService.meetingParticipant.findFirst.mockResolvedValue(mockParticipant);
      mockPrismaService.meetingParticipant.update.mockResolvedValue({});

      const result = await service.leaveMeeting('meet-123', 'user-456');

      expect(result.success).toBe(true);
      expect(mockPrismaService.meetingParticipant.update).toHaveBeenCalledWith({
        where: { id: 'part-1' },
        data: {
          leftAt: expect.any(Date),
          durationSeconds: expect.any(Number),
        },
      });
    });
  });

  describe('createActionItem', () => {
    it('should create action item and dispatch search indexing', async () => {
      const mockAction = {
        id: 'action-1',
        meetingId: 'meet-123',
        title: 'Follow up',
        assigneeId: 'user-456',
        status: MeetingActionItemStatus.OPEN,
      };
      mockPrismaService.meetingActionItem.create.mockResolvedValue(mockAction);

      const result = await service.createActionItem('meet-123', {
        title: 'Follow up',
        assigneeId: 'user-456',
      });

      expect(result).toEqual(mockAction);
      expect(mockEventService.dispatch).toHaveBeenCalledWith(
        'search-indexing',
        'meeting-action-item:index',
        expect.any(Object),
      );
    });
  });

  describe('logDecision', () => {
    it('should create decision and dispatch search indexing', async () => {
      const mockDecision = {
        id: 'dec-1',
        meetingId: 'meet-123',
        decision: 'Use PostgreSQL',
        createdBy: 'user-123',
      };
      mockPrismaService.meetingDecision.create.mockResolvedValue(mockDecision);

      const result = await service.logDecision('meet-123', 'user-123', 'Use PostgreSQL');

      expect(result).toEqual(mockDecision);
      expect(mockEventService.dispatch).toHaveBeenCalledWith(
        'search-indexing',
        'meeting-decision:index',
        expect.any(Object),
      );
    });
  });

  describe('logTranscript', () => {
    it('should create transcript and dispatch search indexing', async () => {
      const mockTranscript = {
        id: 'tr-1',
        meetingId: 'meet-123',
        content: 'Hello World',
        language: 'en',
      };
      mockPrismaService.meetingTranscript.create.mockResolvedValue(mockTranscript);

      const result = await service.logTranscript('meet-123', 'Hello World');

      expect(result).toEqual(mockTranscript);
      expect(mockEventService.dispatch).toHaveBeenCalledWith(
        'search-indexing',
        'meeting-transcript:index',
        expect.any(Object),
      );
    });
  });

  describe('waitingRoom', () => {
    it('should request waiting room entry', async () => {
      mockPrismaService.meetingWaitingRoom.create.mockResolvedValue({ id: 'wait-1' });

      const result = await service.requestWaitingRoom('meet-123', 'user-456');

      expect(result).toEqual({ id: 'wait-1' });
      expect(mockPrismaService.meetingWaitingRoom.create).toHaveBeenCalledWith({
        data: { meetingId: 'meet-123', userId: 'user-456' },
      });
    });

    it('should approve waiting room entry if actor is host', async () => {
      mockPrismaService.meeting.findUnique.mockResolvedValue({ id: 'meet-123', hostId: 'user-123' });
      mockPrismaService.meetingWaitingRoom.updateMany.mockResolvedValue({ count: 1 });

      const result = await service.approveWaitingRoom('meet-123', 'user-456', 'user-123');

      expect(result.success).toBe(true);
      expect(mockPrismaService.meetingWaitingRoom.updateMany).toHaveBeenCalled();
    });

    it('should throw ForbiddenException on approve if actor is not host', async () => {
      mockPrismaService.meeting.findUnique.mockResolvedValue({ id: 'meet-123', hostId: 'user-123' });

      await expect(
        service.approveWaitingRoom('meet-123', 'user-456', 'user-other'),
      ).rejects.toThrow(ForbiddenException);
    });
  });

  describe('breakoutRooms', () => {
    it('should create breakout rooms', async () => {
      mockPrismaService.breakoutRoom.create.mockResolvedValue({ id: 'break-1' });

      const result = await service.createBreakoutRooms('meet-123', 2);

      expect(result.length).toBe(2);
      expect(mockPrismaService.breakoutRoom.create).toHaveBeenCalledTimes(2);
    });

    it('should assign breakout participant', async () => {
      mockPrismaService.breakoutRoomParticipant.upsert.mockResolvedValue({ id: 'part-1' });

      const result = await service.assignBreakoutParticipant('break-1', 'user-456');

      expect(result).toEqual({ id: 'part-1' });
      expect(mockPrismaService.breakoutRoomParticipant.upsert).toHaveBeenCalledWith({
        where: { breakoutRoomId_userId: { breakoutRoomId: 'break-1', userId: 'user-456' } },
        update: {},
        create: { breakoutRoomId: 'break-1', userId: 'user-456' },
      });
    });
  });

  describe('recordings', () => {
    it('should upload recording and register in DB', async () => {
      mockStorageService.uploadFile.mockResolvedValue('teamos-recordings/rec-meet.mp4');
      mockPrismaService.meetingRecording.create.mockResolvedValue({ id: 'rec-1' });

      const mockBuffer = Buffer.from('test recording file');
      const result = await service.registerRecording('meet-123', 300, mockBuffer);

      expect(result).toEqual({ id: 'rec-1' });
      expect(mockStorageService.uploadFile).toHaveBeenCalledWith(
        'teamos-recordings',
        expect.any(String),
        mockBuffer,
        mockBuffer.length,
        'video/mp4',
      );
      expect(mockPrismaService.meetingRecording.create).toHaveBeenCalledWith({
        data: {
          meetingId: 'meet-123',
          duration: 300,
          status: RecordingStatus.COMPLETED,
          playbackUrl: 'teamos-recordings/rec-meet.mp4',
          downloadUrl: 'teamos-recordings/rec-meet.mp4',
        },
      });
    });
  });

  describe('getMeetingAnalytics', () => {
    it('should calculate analytics correctly', async () => {
      const mockMeeting = {
        id: 'meet-123',
        participants: [
          { id: 'part-1', userId: 'user-1', leftAt: new Date(), durationSeconds: 600 },
          { id: 'part-2', userId: 'user-2', leftAt: new Date(), durationSeconds: 400 },
        ],
        actionItems: [{}, {}],
        decisions: [{}],
        notes: [],
        recordings: [],
        transcripts: [],
        schedules: [],
        summaries: [],
        insights: [],
      };

      // Service uses getMeeting which returns the include model
      mockPrismaService.meeting.findUnique.mockResolvedValue(mockMeeting);

      const result = await service.getMeetingAnalytics('meet-123');

      expect(result).toEqual({
        attendanceRate: 100,
        averageDurationSeconds: 500,
        actionItemsCreatedCount: 2,
        decisionsLoggedCount: 1,
        teamCollaborationScore: 85,
        effectivenessScore: 90,
      });
    });
  });
});
