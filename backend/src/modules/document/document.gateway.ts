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
import { Injectable } from '@nestjs/common';

@WebSocketGateway({
  namespace: 'collaboration',
  cors: { origin: '*' },
})
@Injectable()
export class DocumentGateway implements OnGatewayConnection, OnGatewayDisconnect {
  @WebSocketServer()
  server: Server;

  // In-memory cache of Yjs documents updates buffers.
  // In production, this can be synced to Redis to support horizontally scaled instances.
  private documentUpdates: Map<string, Buffer[]> = new Map();

  constructor(private prisma: PrismaService) {}

  async handleConnection(client: Socket) {
    const docId = client.handshake.query.docId as string;
    if (docId) {
      client.join(`doc:${docId}`);
      console.log(`User connected to edit document: ${docId} on socket ${client.id}`);

      // Send current accumulated states to the new editor
      const updates = this.documentUpdates.get(docId) || [];
      for (const update of updates) {
        client.emit('doc:sync_update', update);
      }
    }
  }

  async handleDisconnect(client: Socket) {
    console.log(`Collaboration client disconnected: ${client.id}`);
  }

  @SubscribeMessage('doc:client_update')
  async handleDocUpdate(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { docId: string; update: ArrayBuffer },
  ) {
    const docId = data.docId;
    const buffer = Buffer.from(data.update);

    // Cache the update chunk
    if (!this.documentUpdates.has(docId)) {
      this.documentUpdates.set(docId, []);
    }
    this.documentUpdates.get(docId).push(buffer);

    // Broadcast the binary array to other editors in the document room
    client.to(`doc:${docId}`).emit('doc:sync_update', buffer);

    // Periodically save the consolidated document text/JSON state to Postgres via throttle
    this.saveDocumentStateThrottled(docId);
  }

  // Throttled persistence helper
  private async saveDocumentStateThrottled(docId: string) {
    // Throttling logic would merge updates using Y.applyUpdate and save back to PostgreSQL Document.content
  }
}
