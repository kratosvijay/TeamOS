import { Test, TestingModule } from '@nestjs/testing';
import { ChatService } from './chat.service';
import { PrismaService } from '../prisma/prisma.service';
import { EventService } from '../event/event.service';
import { ChannelType, ChannelRole } from '@prisma/client';
import { ForbiddenException, BadRequestException, NotFoundException } from '@nestjs/common';

describe('ChatService', () => {
  let service: ChatService;
  let prisma: PrismaService;
  let eventService: EventService;

  const mockPrismaService = {
    $transaction: jest.fn((cb) => cb(mockPrismaService)),
    channel: {
      create: jest.fn(),
      findUnique: jest.fn(),
      findMany: jest.fn(),
    },
    channelMember: {
      create: jest.fn(),
      deleteMany: jest.fn(),
    },
    message: {
      create: jest.fn(),
      findUnique: jest.fn(),
      findMany: jest.fn(),
      update: jest.fn(),
      delete: jest.fn(),
    },
    messageReaction: {
      findUnique: jest.fn(),
      create: jest.fn(),
      delete: jest.fn(),
    },
    pinnedMessage: {
      create: jest.fn(),
      deleteMany: jest.fn(),
      findMany: jest.fn(),
    },
    messageRead: {
      create: jest.fn(),
      upsert: jest.fn(),
    },
  };

  const mockEventService = {
    dispatch: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ChatService,
        { provide: PrismaService, useValue: mockPrismaService },
        { provide: EventService, useValue: mockEventService },
      ],
    }).compile();

    service = module.get<ChatService>(ChatService);
    prisma = module.get<PrismaService>(PrismaService);
    eventService = module.get<EventService>(EventService);

    jest.clearAllMocks();
  });

  describe('createChannel', () => {
    it('should create channel and make creator the OWNER', async () => {
      const mockChannel = {
        id: 'chan-123',
        name: 'general',
        description: 'General discussion',
        type: ChannelType.PROJECT_TEXT,
        workspaceId: 'ws-123',
      };

      mockPrismaService.channel.create.mockResolvedValue(mockChannel);
      mockPrismaService.channelMember.create.mockResolvedValue({
        id: 'member-123',
        channelId: 'chan-123',
        userId: 'user-123',
        role: ChannelRole.OWNER,
      });

      const result = await service.createChannel('ws-123', 'user-123', {
        name: 'general',
        description: 'General discussion',
        type: ChannelType.PROJECT_TEXT,
      });

      expect(result).toEqual(mockChannel);
      expect(mockPrismaService.channel.create).toHaveBeenCalledWith({
        data: {
          workspaceId: 'ws-123',
          projectId: null,
          name: 'general',
          description: 'General discussion',
          type: ChannelType.PROJECT_TEXT,
        },
      });
      expect(mockPrismaService.channelMember.create).toHaveBeenCalledWith({
        data: {
          channelId: 'chan-123',
          userId: 'user-123',
          role: ChannelRole.OWNER,
        },
      });
      expect(mockEventService.dispatch).toHaveBeenCalledWith('search-indexing', 'channel:index', expect.any(Object));
    });
  });

  describe('addChannelMember', () => {
    it('should throw NotFoundException if channel does not exist', async () => {
      mockPrismaService.channel.findUnique.mockResolvedValue(null);

      await expect(
        service.addChannelMember('chan-fake', 'user-2', ChannelRole.MEMBER, 'user-1'),
      ).rejects.toThrow(NotFoundException);
    });

    it('should throw ForbiddenException if actor is not channel OWNER or MODERATOR', async () => {
      const mockChannel = {
        id: 'chan-123',
        members: [
          { userId: 'user-1', role: ChannelRole.MEMBER },
        ],
      };
      mockPrismaService.channel.findUnique.mockResolvedValue(mockChannel);

      await expect(
        service.addChannelMember('chan-123', 'user-2', ChannelRole.MEMBER, 'user-1'),
      ).rejects.toThrow(ForbiddenException);
    });

    it('should add member successfully if actor is OWNER', async () => {
      const mockChannel = {
        id: 'chan-123',
        members: [
          { userId: 'user-1', role: ChannelRole.OWNER },
        ],
      };
      mockPrismaService.channel.findUnique.mockResolvedValue(mockChannel);
      mockPrismaService.channelMember.create.mockResolvedValue({
        id: 'member-new',
        channelId: 'chan-123',
        userId: 'user-2',
        role: ChannelRole.MEMBER,
      });

      const result = await service.addChannelMember('chan-123', 'user-2', ChannelRole.MEMBER, 'user-1');
      expect(result).toBeDefined();
      expect(mockPrismaService.channelMember.create).toHaveBeenCalledWith({
        data: {
          channelId: 'chan-123',
          userId: 'user-2',
          role: ChannelRole.MEMBER,
        },
      });
    });
  });

  describe('toggleReaction', () => {
    it('should add reaction if not already exists', async () => {
      mockPrismaService.messageReaction.findUnique.mockResolvedValue(null);
      mockPrismaService.messageReaction.create.mockResolvedValue({
        id: 'rx-1',
        messageId: 'msg-1',
        userId: 'user-1',
        emoji: '👍',
      });

      const result = await service.toggleReaction('msg-1', 'user-1', '👍');
      expect(result.action).toBe('added');
      expect(mockPrismaService.messageReaction.create).toHaveBeenCalled();
    });

    it('should remove reaction if it already exists', async () => {
      mockPrismaService.messageReaction.findUnique.mockResolvedValue({
        id: 'rx-1',
        messageId: 'msg-1',
        userId: 'user-1',
        emoji: '👍',
      });

      const result = await service.toggleReaction('msg-1', 'user-1', '👍');
      expect(result.action).toBe('removed');
      expect(mockPrismaService.messageReaction.delete).toHaveBeenCalled();
    });
  });

  describe('pinMessage', () => {
    it('should pin message successfully', async () => {
      mockPrismaService.pinnedMessage.create.mockResolvedValue({
        id: 'pin-1',
        messageId: 'msg-1',
        channelId: 'chan-1',
        pinnedById: 'user-1',
      });

      const result = await service.pinMessage('msg-1', 'chan-1', 'user-1');
      expect(result).toBeDefined();
      expect(mockPrismaService.pinnedMessage.create).toHaveBeenCalled();
    });

    it('should throw BadRequestException if message already pinned', async () => {
      const error = new Error('Unique constraint failed');
      (error as any).code = 'P2002';
      mockPrismaService.pinnedMessage.create.mockRejectedValue(error);

      await expect(
        service.pinMessage('msg-1', 'chan-1', 'user-1'),
      ).rejects.toThrow(BadRequestException);
    });
  });
});
