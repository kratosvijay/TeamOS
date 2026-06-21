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
import { AIService } from './ai.service';
import { Injectable } from '@nestjs/common';

@WebSocketGateway({
  namespace: 'ai',
  cors: { origin: '*' },
})
@Injectable()
export class AIGateway implements OnGatewayConnection, OnGatewayDisconnect {
  @WebSocketServer()
  server: Server;

  constructor(private aiService: AIService) {}

  async handleConnection(client: Socket) {
    console.log(`AI client connected: ${client.id}`);
  }

  async handleDisconnect(client: Socket) {
    console.log(`AI client disconnected: ${client.id}`);
  }

  @SubscribeMessage('ai:chat')
  async handleAIChat(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { workspaceId: string; userId: string; conversationId: string; message: string; agentId?: string },
  ) {
    try {
      // 1. Emit thinking state
      client.emit('ai:thinking', { status: 'Retrieving context from MCP and generating response...' });

      // 2. Stream chunk simulator
      let chunkCount = 0;
      const interval = setInterval(() => {
        if (chunkCount < 4) {
          client.emit('ai:stream', { text: `[Stream Chunk ${chunkCount + 1}] Analyzing workspace data... ` });
          chunkCount++;
        } else {
          clearInterval(interval);
        }
      }, 300);

      // 3. Process LLM request
      const response = await this.aiService.executeChat(
        data.workspaceId,
        data.userId,
        data.conversationId,
        data.message,
        data.agentId,
      );

      // Wait a moment to align stream timing
      setTimeout(() => {
        client.emit('ai:complete', {
          messageId: response.messageId,
          content: response.content,
          citations: response.citations,
        });
      }, 1500);

    } catch (error) {
      console.error(`AIGateway Error: ${error.message}`);
      client.emit('ai:error', { message: error.message || 'Error occurred during AI processing' });
    }
  }
}
