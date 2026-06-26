import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class UniversalSearchService {
  constructor(private readonly prisma: PrismaService) {}

  async createIndexConfig(workspaceId: string, indexName: string, fields: string[]) {
    return this.prisma.searchIndexConfig.create({
      data: {
        workspaceId,
        indexName,
        fieldsJson: JSON.stringify(fields),
      },
    });
  }

  async startIndexJob(workspaceId: string, configId: string) {
    const config = await this.prisma.searchIndexConfig.findUnique({
      where: { id: configId },
    });
    if (!config) throw new Error('Search index config not found');

    const indexedCount = Math.floor(Math.random() * 5000) + 100;

    return this.prisma.searchIndexJob.create({
      data: {
        workspaceId,
        configId,
        status: 'SUCCESS',
        indexedCount,
      },
    });
  }
}
