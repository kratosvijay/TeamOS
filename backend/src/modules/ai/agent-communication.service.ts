import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { AgentMessageType } from '@prisma/client';

@Injectable()
export class AgentCommunicationService {
  constructor(private readonly prisma: PrismaService) {}

  async sendMessage(
    senderId: string,
    receiverId: string,
    messageType: AgentMessageType,
    payloadContext: any,
    parentExecutionId?: string,
  ) {
    return this.prisma.agentMessage.create({
      data: {
        senderId,
        receiverId,
        messageType,
        payloadContext,
        parentExecutionId,
      },
    });
  }

  async getMessageQueueForAgent(receiverId: string) {
    return this.prisma.agentMessage.findMany({
      where: { receiverId },
      orderBy: { createdAt: 'asc' },
    });
  }

  async getExecutionHistory(parentExecutionId: string) {
    return this.prisma.agentMessage.findMany({
      where: { parentExecutionId },
      orderBy: { createdAt: 'asc' },
    });
  }
}
