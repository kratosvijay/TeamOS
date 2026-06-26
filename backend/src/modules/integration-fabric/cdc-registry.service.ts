import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class CdcRegistryService {
  constructor(private readonly prisma: PrismaService) {}

  async registerFeed(workspaceId: string, tableName: string) {
    return this.prisma.changeFeed.create({
      data: {
        workspaceId,
        tableName,
        status: 'ACTIVE',
      },
    });
  }

  async subscribe(workspaceId: string, feedId: string, consumerName: string) {
    return this.prisma.changeSubscription.create({
      data: {
        workspaceId,
        feedId,
        consumerName,
      },
    });
  }

  async updateCheckpoint(workspaceId: string, subscriptionId: string, sequenceNumber: string) {
    const existing = await this.prisma.changeCheckpoint.findFirst({
      where: { workspaceId, subscriptionId },
    });

    if (existing) {
      return this.prisma.changeCheckpoint.update({
        where: { id: existing.id },
        data: { sequenceNumber },
      });
    }

    return this.prisma.changeCheckpoint.create({
      data: {
        workspaceId,
        subscriptionId,
        sequenceNumber,
      },
    });
  }
}
