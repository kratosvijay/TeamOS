import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class DataFederationService {
  constructor(private readonly prisma: PrismaService) {}

  async registerSource(workspaceId: string, name: string, type: string, configJson: string) {
    return this.prisma.federationSource.create({
      data: {
        workspaceId,
        name,
        type,
        configJson,
      },
    });
  }

  async logQuery(workspaceId: string, sourceId: string, queryText: string, runTimeMs: number) {
    return this.prisma.federationQuery.create({
      data: {
        workspaceId,
        sourceId,
        queryText,
        runTimeMs,
      },
    });
  }

  async setCache(workspaceId: string, queryKey: string, resultData: string, expiresAt: Date) {
    return this.prisma.federationCache.create({
      data: {
        workspaceId,
        queryKey,
        resultData,
        expiresAt,
      },
    });
  }

  async getCache(workspaceId: string, queryKey: string) {
    return this.prisma.federationCache.findFirst({
      where: {
        workspaceId,
        queryKey,
        expiresAt: {
          gt: new Date(),
        },
      },
    });
  }
}
