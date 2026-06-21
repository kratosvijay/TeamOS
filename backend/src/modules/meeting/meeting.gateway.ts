import {
  WebSocketGateway,
  WebSocketServer,
  SubscribeMessage,
  MessageBody,
  ConnectedSocket,
  OnGatewayConnection,
  OnGatewayDisconnect,
} from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import { Injectable, UnauthorizedException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { JwtStrategy } from '../auth/jwt.strategy';
import { MeetingService } from './meeting.service';

@WebSocketGateway({
  cors: { origin: '*' },
})
@Injectable()
export class MeetingGateway implements OnGatewayConnection, OnGatewayDisconnect {
  @WebSocketServer()
  server: Server;

  constructor(
    private prisma: PrismaService,
    private jwtStrategy: JwtStrategy,
    private meetingService: MeetingService,
  ) {}

  async handleConnection(client: Socket) {
    try {
      const token = (client.handshake.query.token as string) || (client.handshake.auth.token as string);
      if (!token) throw new UnauthorizedException('Authentication token missing');
      
      const payload = await this.jwtStrategy.validateToken(token);
      client.data = { userId: payload.id, email: payload.email };
      console.log(`Meeting WebSocket: Client connected [${client.id}] user: ${payload.email}`);
    } catch (e) {
      console.error(`Meeting WebSocket: Unauthorized connection attempt: ${e.message}`);
      client.disconnect();
    }
  }

  handleDisconnect(client: Socket) {
    console.log(`Meeting WebSocket: Client disconnected [${client.id}]`);
  }

  // --- ROOM JOIN/LEAVE MANAGEMENT ---

  @SubscribeMessage('meeting:join')
  async handleJoin(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { meetingId: string; userName: string },
  ) {
    const userId = client.data.userId;
    const room = `meeting:${data.meetingId}`;
    client.join(room);

    await this.meetingService.joinMeeting(data.meetingId, userId, data.userName);

    // Broadcast attendance list update
    this.server.to(room).emit('meeting:participant:joined', { userId, userName: data.userName });
    console.log(`Meeting WebSocket: User ${userId} joined room ${room}`);
  }

  @SubscribeMessage('meeting:leave')
  async handleLeave(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { meetingId: string },
  ) {
    const userId = client.data.userId;
    const room = `meeting:${data.meetingId}`;
    client.leave(room);

    await this.meetingService.leaveMeeting(data.meetingId, userId);

    // Broadcast user left event
    this.server.to(room).emit('meeting:participant:left', { userId });
    console.log(`Meeting WebSocket: User ${userId} left room ${room}`);
  }

  // --- AUDIO/VIDEO & CONTROLS ---

  @SubscribeMessage('meeting:participant:update')
  async handleParticipantUpdate(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { meetingId: string; micOn: boolean; cameraOn: boolean; screenShareOn: boolean },
  ) {
    const userId = client.data.userId;
    const room = `meeting:${data.meetingId}`;
    
    // Broadcast status to other room members
    client.to(room).emit('meeting:participant:status', {
      userId,
      micOn: data.micOn,
      cameraOn: data.cameraOn,
      screenShareOn: data.screenShareOn,
    });
  }

  @SubscribeMessage('meeting:hand:raise')
  async handleHandRaise(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { meetingId: string; raised: boolean },
  ) {
    const userId = client.data.userId;
    const room = `meeting:${data.meetingId}`;

    client.to(room).emit('meeting:hand:state', {
      userId,
      raised: data.raised,
    });
  }

  // --- WAITING ROOM ---

  @SubscribeMessage('meeting:waiting-room:join')
  async handleWaitingRoomJoin(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { meetingId: string; userName: string },
  ) {
    const userId = client.data.userId;
    const room = `meeting:${data.meetingId}`;

    await this.meetingService.requestWaitingRoom(data.meetingId, userId);

    // Alert host/co-hosts in the room
    this.server.to(room).emit('meeting:waiting-room:requested', {
      userId,
      userName: data.userName,
    });
  }

  // --- BREAKOUT ROOMS ---

  @SubscribeMessage('meeting:breakout:create')
  async handleBreakoutCreate(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { meetingId: string; rooms: { id: string; name: string }[] },
  ) {
    const room = `meeting:${data.meetingId}`;
    this.server.to(room).emit('meeting:breakout:created', { rooms: data.rooms });
  }

  @SubscribeMessage('meeting:breakout:join')
  async handleBreakoutJoin(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { meetingId: string; breakoutRoomId: string; targetUserId: string },
  ) {
    const room = `meeting:${data.meetingId}`;
    this.server.to(room).emit('meeting:breakout:redirected', {
      userId: data.targetUserId,
      breakoutRoomId: data.breakoutRoomId,
    });
  }

  @SubscribeMessage('meeting:breakout:close')
  async handleBreakoutClose(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { meetingId: string },
  ) {
    const room = `meeting:${data.meetingId}`;
    this.server.to(room).emit('meeting:breakout:closed');
  }

  // --- MEETING COLLABORATION EVENTS ---

  @SubscribeMessage('meeting:action-item:create')
  async handleActionItemCreate(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { meetingId: string; actionItemId: string; title: string },
  ) {
    const room = `meeting:${data.meetingId}`;
    this.server.to(room).emit('meeting:action-item:added', {
      id: data.actionItemId,
      title: data.title,
    });
  }

  @SubscribeMessage('meeting:decision:create')
  async handleDecisionCreate(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { meetingId: string; decisionId: string; decision: string },
  ) {
    const room = `meeting:${data.meetingId}`;
    this.server.to(room).emit('meeting:decision:added', {
      id: data.decisionId,
      decision: data.decision,
    });
  }

  @SubscribeMessage('meeting:transcript:update')
  async handleTranscriptUpdate(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { meetingId: string; content: string },
  ) {
    const room = `meeting:${data.meetingId}`;
    this.server.to(room).emit('meeting:transcript:chunk', {
      content: data.content,
      timestamp: new Date().toISOString(),
    });
  }
}
