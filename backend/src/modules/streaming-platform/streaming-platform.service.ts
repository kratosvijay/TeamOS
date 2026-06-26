import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class StreamingPlatformService {
  constructor(private readonly prisma: PrismaService) {}

  async createTopic(workspaceId: string, topicName: string, partitions = 1) {
    return this.prisma.streamTopic.create({
      data: {
        workspaceId,
        topicName,
        partitions,
      },
    });
  }

  async registerConsumer(workspaceId: string, groupName: string, topicId: string) {
    return this.prisma.streamConsumer.create({
      data: {
        workspaceId,
        groupName,
        topicId,
        isActive: true,
      },
    });
  }

  async updateOffset(workspaceId: string, consumerId: string, partition: number, offsetValue: number) {
    const existing = await this.prisma.streamOffset.findFirst({
      where: {
        workspaceId,
        consumerId,
        partition,
      },
    });

    if (existing) {
      return this.prisma.streamOffset.update({
        where: { id: existing.id },
        data: { offsetValue },
      });
    }

    return this.prisma.streamOffset.create({
      data: {
        workspaceId,
        consumerId,
        partition,
        offsetValue,
      },
    });
  }

  async saveCheckpoint(workspaceId: string, consumerId: string, checkpointData: string) {
    const existing = await this.prisma.streamCheckpoint.findFirst({
      where: {
        workspaceId,
        consumerId,
      },
    });

    if (existing) {
      return this.prisma.streamCheckpoint.update({
        where: { id: existing.id },
        data: { checkpointData },
      });
    }

    return this.prisma.streamCheckpoint.create({
      data: {
        workspaceId,
        consumerId,
        checkpointData,
      },
    });
  }

  async runReplayJob(workspaceId: string, topicId: string, startOffset: number, endOffset: number) {
    return this.prisma.replayJob.create({
      data: {
        workspaceId,
        topicId,
        startOffset,
        endOffset,
        status: 'SUCCESS',
      },
    });
  }
}
