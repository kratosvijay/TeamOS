import { Injectable, NotFoundException, ForbiddenException, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { ChannelType, ChannelRole, PresenceStatus } from '@prisma/client';
import { EventService } from '../event/event.service';

@Injectable()
export class ChatService {
  constructor(
    private prisma: PrismaService,
    private eventService: EventService,
  ) {}

  // --- CHANNEL MANAGEMENT ---

  async createChannel(
    workspaceId: string,
    creatorId: string,
    data: {
      projectId?: string;
      name: string;
      description?: string;
      type: ChannelType;
    },
  ) {
    return this.prisma.$transaction(async (tx) => {
      // Create channel
      const channel = await tx.channel.create({
        data: {
          workspaceId,
          projectId: data.projectId || null,
          name: data.name,
          description: data.description || null,
          type: data.type,
        },
      });

      // Add creator as OWNER of the channel
      await tx.channelMember.create({
        data: {
          channelId: channel.id,
          userId: creatorId,
          role: ChannelRole.OWNER,
        },
      });

      // Dispatch search index
      await this.eventService.dispatch('search-indexing', 'channel:index', {
        entityType: 'channel',
        entityId: channel.id,
        payload: {
          name: channel.name,
          description: channel.description,
          type: channel.type,
          workspaceId,
        },
      });

      return channel;
    });
  }

  async getChannels(workspaceId: string, userId: string) {
    // Return channels in workspace:
    // 1. All non-private channels
    // 2. Private channels where the user is a member
    return this.prisma.channel.findMany({
      where: {
        workspaceId,
        OR: [
          { type: { notIn: [ChannelType.PRIVATE_TEXT] } },
          {
            members: {
              some: { userId },
            },
          },
        ],
      },
      include: {
        members: {
          include: {
            user: {
              select: { id: true, fullName: true, avatarUrl: true },
            },
          },
        },
      },
      orderBy: { name: 'asc' },
    });
  }

  async addChannelMember(channelId: string, userId: string, role: ChannelRole = ChannelRole.MEMBER, actorId: string) {
    const channel = await this.prisma.channel.findUnique({
      where: { id: channelId },
      include: { members: true },
    });
    if (!channel) throw new NotFoundException('Channel not found');

    // Verify actor is moderator or owner
    const actorMembership = channel.members.find((m) => m.userId === actorId);
    if (!actorMembership || (actorMembership.role !== ChannelRole.OWNER && actorMembership.role !== ChannelRole.MODERATOR)) {
      throw new ForbiddenException('Only channel owners or moderators can add members');
    }

    try {
      return await this.prisma.channelMember.create({
        data: { channelId, userId, role },
      });
    } catch (e) {
      if (e.code === 'P2002') {
        throw new BadRequestException('User is already a member of this channel');
      }
      throw e;
    }
  }

  async removeChannelMember(channelId: string, userId: string, actorId: string) {
    const channel = await this.prisma.channel.findUnique({
      where: { id: channelId },
      include: { members: true },
    });
    if (!channel) throw new NotFoundException('Channel not found');

    const actorMembership = channel.members.find((m) => m.userId === actorId);
    if (!actorMembership) throw new ForbiddenException('You are not a member of this channel');

    // Owners and moderators can remove anyone (except owners removing owners), or user can leave themselves
    if (userId !== actorId) {
      if (actorMembership.role !== ChannelRole.OWNER && actorMembership.role !== ChannelRole.MODERATOR) {
        throw new ForbiddenException('Insufficient permissions to remove member');
      }
    }

    await this.prisma.channelMember.deleteMany({
      where: { channelId, userId },
    });

    return { success: true };
  }

  // --- MESSAGING ---

  async createMessage(
    senderId: string,
    data: {
      channelId?: string;
      dmRoomId?: string;
      parentId?: string;
      content: string;
      attachments?: { name: string; url: string; size: number; mimeType: string }[];
    },
  ) {
    const message = await this.prisma.$transaction(async (tx) => {
      const msg = await tx.message.create({
        data: {
          senderId,
          channelId: data.channelId || null,
          dmRoomId: data.dmRoomId || null,
          parentId: data.parentId || null,
          content: data.content,
          attachments: data.attachments
            ? {
                create: data.attachments.map((a) => ({
                  name: a.name,
                  url: a.url,
                  size: a.size,
                  mimeType: a.mimeType,
                })),
              }
            : undefined,
        },
        include: {
          sender: { select: { id: true, fullName: true, avatarUrl: true } },
          attachments: true,
        },
      });

      // Automatically mark as read for sender
      await tx.messageRead.create({
        data: {
          messageId: msg.id,
          userId: senderId,
        },
      });

      return msg;
    });

    // Dispatch search indexing
    await this.eventService.dispatch('search-indexing', 'message:index', {
      entityType: 'message',
      entityId: message.id,
      payload: {
        content: message.content,
        senderId: message.senderId,
        channelId: message.channelId,
        dmRoomId: message.dmRoomId,
        parentId: message.parentId,
      },
    });

    return message;
  }

  async editMessage(messageId: string, userId: string, content: string) {
    const message = await this.prisma.message.findUnique({ where: { id: messageId } });
    if (!message) throw new NotFoundException('Message not found');
    if (message.senderId !== userId) throw new ForbiddenException('Cannot edit messages sent by others');

    const updated = await this.prisma.message.update({
      where: { id: messageId },
      data: { content },
      include: {
        sender: { select: { id: true, fullName: true, avatarUrl: true } },
        attachments: true,
      },
    });

    // Reindex message
    await this.eventService.dispatch('search-indexing', 'message:index', {
      entityType: 'message',
      entityId: updated.id,
      payload: {
        content: updated.content,
        senderId: updated.senderId,
        channelId: updated.channelId,
        dmRoomId: updated.dmRoomId,
        parentId: updated.parentId,
      },
    });

    return updated;
  }

  async deleteMessage(messageId: string, userId: string) {
    const message = await this.prisma.message.findUnique({ where: { id: messageId } });
    if (!message) throw new NotFoundException('Message not found');
    if (message.senderId !== userId) throw new ForbiddenException('Cannot delete messages sent by others');

    await this.prisma.message.delete({ where: { id: messageId } });

    // De-index message
    await this.eventService.dispatch('search-indexing', 'search:delete', {
      entityType: 'message',
      entityId: messageId,
    });

    return { success: true };
  }

  async getChannelMessages(channelId: string, limit = 50, offset = 0) {
    return this.prisma.message.findMany({
      where: { channelId, parentId: null },
      include: {
        sender: { select: { id: true, fullName: true, avatarUrl: true } },
        attachments: true,
        reactions: {
          include: {
            user: { select: { id: true, fullName: true } },
          },
        },
        reads: true,
        pinnedMessage: true,
      },
      orderBy: { createdAt: 'desc' },
      take: limit,
      skip: offset,
    });
  }

  async getThreadReplies(parentId: string, limit = 50, offset = 0) {
    return this.prisma.message.findMany({
      where: { parentId },
      include: {
        sender: { select: { id: true, fullName: true, avatarUrl: true } },
        attachments: true,
        reactions: true,
        reads: true,
      },
      orderBy: { createdAt: 'asc' },
      take: limit,
      skip: offset,
    });
  }

  // --- DIRECT MESSAGING ---

  async createDirectMessageRoom(userIds: string[]) {
    // Unique check or create
    return this.prisma.$transaction(async (tx) => {
      // Find room with exact participants if exists
      const existingRooms = await tx.directMessageRoom.findMany({
        include: { participants: true },
      });

      for (const room of existingRooms) {
        const roomUserIds = room.participants.map((p) => p.userId);
        if (roomUserIds.length === userIds.length && userIds.every((id) => roomUserIds.includes(id))) {
          return room;
        }
      }

      const room = await tx.directMessageRoom.create({});
      for (const id of userIds) {
        await tx.directMessageRoomParticipant.create({
          data: { roomId: room.id, userId: id },
        });
      }

      return tx.directMessageRoom.findUnique({
        where: { id: room.id },
        include: {
          participants: {
            include: {
              user: { select: { id: true, fullName: true, avatarUrl: true } },
            },
          },
        },
      });
    });
  }

  async getDirectMessageRooms(userId: string) {
    return this.prisma.directMessageRoom.findMany({
      where: {
        participants: {
          some: { userId },
        },
      },
      include: {
        participants: {
          include: {
            user: { select: { id: true, fullName: true, avatarUrl: true } },
          },
        },
        messages: {
          orderBy: { createdAt: 'desc' },
          take: 1,
          include: {
            sender: { select: { id: true, fullName: true } },
          },
        },
      },
    });
  }

  // --- REACTIONS ---

  async toggleReaction(messageId: string, userId: string, emoji: string) {
    const existing = await this.prisma.messageReaction.findUnique({
      where: {
        messageId_userId_emoji: { messageId, userId, emoji },
      },
    });

    if (existing) {
      await this.prisma.messageReaction.delete({
        where: { id: existing.id },
      });
      return { action: 'removed', emoji };
    } else {
      const reaction = await this.prisma.messageReaction.create({
        data: { messageId, userId, emoji },
        include: {
          user: { select: { id: true, fullName: true } },
        },
      });
      return { action: 'added', reaction };
    }
  }

  // --- PINNED MESSAGES ---

  async pinMessage(messageId: string, channelId: string, userId: string) {
    try {
      return await this.prisma.pinnedMessage.create({
        data: { messageId, channelId, pinnedById: userId },
      });
    } catch (e) {
      if (e.code === 'P2002') {
        throw new BadRequestException('Message is already pinned');
      }
      throw e;
    }
  }

  async unpinMessage(messageId: string) {
    await this.prisma.pinnedMessage.deleteMany({
      where: { messageId },
    });
    return { success: true };
  }

  async getPinnedMessages(channelId: string) {
    return this.prisma.pinnedMessage.findMany({
      where: { channelId },
      include: {
        message: {
          include: {
            sender: { select: { id: true, fullName: true, avatarUrl: true } },
          },
        },
        pinnedBy: { select: { id: true, fullName: true } },
      },
    });
  }

  // --- READ RECEIPTS ---

  async markMessageAsRead(messageId: string, userId: string) {
    return this.prisma.messageRead.upsert({
      where: {
        messageId_userId: { messageId, userId },
      },
      update: {},
      create: {
        messageId,
        userId,
      },
    });
  }
}
