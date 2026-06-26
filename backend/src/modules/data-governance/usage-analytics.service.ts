import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class UsageAnalyticsService {
  constructor(private readonly prisma: PrismaService) {}

  async logUsage(workspaceId: string, datasetId: string, userId: string, actionType: string) {
    return this.prisma.datasetUsageLog.create({
      data: {
        workspaceId,
        datasetId,
        userId,
        actionType,
      },
    });
  }

  async trackPopularQuery(workspaceId: string, datasetId: string, queryString: string) {
    const existing = await this.prisma.popularQuery.findFirst({
      where: {
        workspaceId,
        datasetId,
        queryString,
      },
    });

    if (existing) {
      return this.prisma.popularQuery.update({
        where: { id: existing.id },
        data: { runCount: existing.runCount + 1 },
      });
    }

    return this.prisma.popularQuery.create({
      data: {
        workspaceId,
        datasetId,
        queryString,
        runCount: 1,
      },
    });
  }

  async trackConsumerStatistic(workspaceId: string, datasetId: string, consumerId: string, count = 1) {
    const existing = await this.prisma.consumerStatistic.findFirst({
      where: {
        workspaceId,
        datasetId,
        consumerId,
      },
    });

    if (existing) {
      return this.prisma.consumerStatistic.update({
        where: { id: existing.id },
        data: { readCount: existing.readCount + count },
      });
    }

    return this.prisma.consumerStatistic.create({
      data: {
        workspaceId,
        datasetId,
        consumerId,
        readCount: count,
      },
    });
  }
}
