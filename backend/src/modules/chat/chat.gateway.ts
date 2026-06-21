import {
  WebSocketGateway,
  WebSocketServer,
  SubscribeMessage,
  OnGatewayConnection,
  OnGatewayDisconnect,
  MessageBody,
  ConnectedSocket,
} from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import { PrismaService } from '../prisma/prisma.service';
import { JwtStrategy } from '../auth/jwt.strategy';
import { Injectable, UnauthorizedException } from '@nestjs/common';
import { PresenceStatus, ChannelRole } from '@prisma/client';
import { ChatService } from './chat.service';

@WebSocketGateway({
  cors: { origin: '*' },
})
@Injectable()
export class ChatGateway implements OnGatewayConnection, OnGatewayDisconnect {
  @WebSocketServer()
  server: Server;

  constructor(
    private prisma: PrismaService,
    private jwtStrategy: JwtStrategy,
    private chatService: ChatService,
  ) {}

  async handleConnection(client: Socket) {
    try {
      const token = client.handshake.query.token as string || client.handshake.auth.token as string;
      if (!token) {
        throw new UnauthorizedException('Authentication token missing');
      }

      const authHeader = `Bearer ${token}`;
      const user = await this.jwtStrategy.validateToken(authHeader);
      client.data.user = user;

      client.join(`user:${user.id}`);
      console.log(`[Socket] Authorized: Client ${client.id} linked to User ${user.id}`);
    } catch (e) {
      console.error(`[Socket] Authorization failed: ${client.id} | error: ${e.message}`);
      client.disconnect(true);
    }
  }

  async handleDisconnect(client: Socket) {
    const user = client.data.user;
    if (user) {
      console.log(`[Socket] Disconnected: Client ${client.id} associated with User ${user.id}`);
      
      await this.prisma.userPresence.updateMany({
        where: { userId: user.id },
        data: { status: PresenceStatus.OFFLINE },
      });
      
      this.server.emit('presence:change', { userId: user.id, status: PresenceStatus.OFFLINE });
    }
  }

  @SubscribeMessage('heartbeat')
  async handleHeartbeat(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { workspaceId: string; status?: PresenceStatus },
  ) {
    const user = client.data.user;
    if (!user) return;

    const status = data.status || PresenceStatus.ONLINE;

    const member = await this.prisma.workspaceMember.findUnique({
      where: {
        workspaceId_userId: { workspaceId: data.workspaceId, userId: user.id },
      },
    });

    if (!member || member.status !== 'ACTIVE') {
      client.emit('error', { message: 'Unauthorized workspace access' });
      return;
    }

    await this.prisma.userPresence.upsert({
      where: { userId_workspaceId: { userId: user.id, workspaceId: data.workspaceId } },
      update: { status },
      create: { userId: user.id, workspaceId: data.workspaceId, status },
    });

    this.server.to(`workspace:${data.workspaceId}`).emit('presence:change', {
      userId: user.id,
      status,
    });
  }

  @SubscribeMessage('room:join')
  async handleRoomJoin(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { roomType: 'workspace' | 'project' | 'ticket' | 'dm' | 'channel'; targetId: string },
  ) {
    const user = client.data.user;
    if (!user) {
      client.emit('error', { message: 'Unauthenticated client' });
      return;
    }

    const { roomType, targetId } = data;
    const roomName = `${roomType}:${targetId}`;

    try {
      if (roomType === 'workspace') {
        const member = await this.prisma.workspaceMember.findUnique({
          where: { workspaceId_userId: { workspaceId: targetId, userId: user.id } },
        });
        if (!member || member.status !== 'ACTIVE') throw new Error('Forbidden workspace room access');
      } 
      
      else if (roomType === 'project') {
        const member = await this.prisma.projectMember.findUnique({
          where: { projectId_userId: { projectId: targetId, userId: user.id } },
        });
        if (!member) throw new Error('Forbidden project room access');
      } 
      
      else if (roomType === 'channel') {
        const channel = await this.prisma.channel.findUnique({
          where: { id: targetId },
        });
        if (!channel) throw new Error('Channel not found');
        
        // If private channel, check membership
        if (channel.type === 'PRIVATE_TEXT') {
          const member = await this.prisma.channelMember.findUnique({
            where: { channelId_userId: { channelId: targetId, userId: user.id } },
          });
          if (!member) throw new Error('Forbidden private channel room access');
        }
      }

      else if (roomType === 'ticket') {
        const task = await this.prisma.task.findUnique({ where: { id: targetId } });
        if (!task) throw new Error('Ticket not found');
        const projectMember = await this.prisma.projectMember.findUnique({
          where: { projectId_userId: { projectId: task.projectId, userId: user.id } },
        });
        if (!projectMember) throw new Error('Forbidden ticket room access');
      } 
      
      else if (roomType === 'dm') {
        const participant = await this.prisma.directMessageRoomParticipant.findUnique({
          where: { roomId_userId: { roomId: targetId, userId: user.id } },
        });
        if (!participant) throw new Error('Forbidden DM room access');
      }

      client.join(roomName);
      console.log(`[Socket] Client ${client.id} joined room: ${roomName}`);
      return { status: 'joined', room: roomName };
    } catch (e) {
      console.error(`[Socket] Room join denied for ${client.id} on room ${roomName}:`, e.message);
      client.emit('error', { message: e.message });
    }
  }

  @SubscribeMessage('room:leave')
  async handleRoomLeave(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { roomType: string; targetId: string },
  ) {
    const roomName = `${data.roomType}:${data.targetId}`;
    client.leave(roomName);
    console.log(`[Socket] Client ${client.id} left room: ${roomName}`);
    return { status: 'left', room: roomName };
  }

  // --- MESSAGING EVENTS ---

  @SubscribeMessage('message:send')
  async handleMessageSend(
    @ConnectedSocket() client: Socket,
    @MessageBody()
    data: {
      channelId?: string;
      dmRoomId?: string;
      parentId?: string;
      content: string;
      attachments?: { name: string; url: string; size: number; mimeType: string }[];
    },
  ) {
    const user = client.data.user;
    if (!user) return;

    const message = await this.chatService.createMessage(user.id, data);
    const room = data.channelId ? `channel:${data.channelId}` : `dm:${data.dmRoomId}`;

    // Broadcast to room
    this.server.to(room).emit('message:receive', message);
  }

  @SubscribeMessage('message:update')
  async handleMessageUpdate(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { messageId: string; content: string },
  ) {
    const user = client.data.user;
    if (!user) return;

    const message = await this.chatService.editMessage(data.messageId, user.id, data.content);
    const room = message.channelId ? `channel:${message.channelId}` : `dm:${message.dmRoomId}`;

    this.server.to(room).emit('message:updated', message);
  }

  @SubscribeMessage('message:delete')
  async handleMessageDelete(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { messageId: string },
  ) {
    const user = client.data.user;
    if (!user) return;

    // Fetch message first to know which room it belongs to
    const message = await this.prisma.message.findUnique({ where: { id: data.messageId } });
    if (!message) return;

    await this.chatService.deleteMessage(data.messageId, user.id);
    const room = message.channelId ? `channel:${message.channelId}` : `dm:${message.dmRoomId}`;

    this.server.to(room).emit('message:deleted', { messageId: data.messageId });
  }

  // --- TYPING INDICATORS ---

  @SubscribeMessage('typing:start')
  async handleTypingStart(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { channelId?: string; dmRoomId?: string },
  ) {
    const user = client.data.user;
    if (!user) return;

    const room = data.channelId ? `channel:${data.channelId}` : `dm:${data.dmRoomId}`;
    client.to(room).emit('typing:indicator', { userId: user.id, fullName: user.fullName, isTyping: true });
  }

  @SubscribeMessage('typing:stop')
  async handleTypingStop(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { channelId?: string; dmRoomId?: string },
  ) {
    const user = client.data.user;
    if (!user) return;

    const room = data.channelId ? `channel:${data.channelId}` : `dm:${data.dmRoomId}`;
    client.to(room).emit('typing:indicator', { userId: user.id, fullName: user.fullName, isTyping: false });
  }

  // --- REACTIONS EVENTS ---

  @SubscribeMessage('reaction:add')
  async handleReactionAdd(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { messageId: string; emoji: string },
  ) {
    const user = client.data.user;
    if (!user) return;

    const result = await this.chatService.toggleReaction(data.messageId, user.id, data.emoji);
    
    // Fetch message for room context
    const message = await this.prisma.message.findUnique({ where: { id: data.messageId } });
    if (!message) return;

    const room = message.channelId ? `channel:${message.channelId}` : `dm:${message.dmRoomId}`;
    this.server.to(room).emit('reaction:changed', { messageId: data.messageId, userId: user.id, ...result });
  }

  // --- PINS EVENTS ---

  @SubscribeMessage('pin:add')
  async handlePinAdd(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { messageId: string; channelId: string },
  ) {
    const user = client.data.user;
    if (!user) return;

    const pin = await this.chatService.pinMessage(data.messageId, data.channelId, user.id);
    this.server.to(`channel:${data.channelId}`).emit('pin:changed', { action: 'added', pin });
  }

  @SubscribeMessage('pin:remove')
  async handlePinRemove(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { messageId: string; channelId: string },
  ) {
    const user = client.data.user;
    if (!user) return;

    await this.chatService.unpinMessage(data.messageId);
    this.server.to(`channel:${data.channelId}`).emit('pin:changed', { action: 'removed', messageId: data.messageId });
  }
}
