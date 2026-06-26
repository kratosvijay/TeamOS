import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class ReverseEtlService {
  constructor(private readonly prisma: PrismaService) {}

  async createPipeline(workspaceId: string, name: string, sourceTable: string, targetId: string) {
    return this.prisma.reverseEtlPipeline.create({
      data: {
        workspaceId,
        name,
        sourceTable,
        targetId,
      },
    });
  }

  async runPipeline(workspaceId: string, pipelineId: string, recordsSynced: number, status: string) {
    return this.prisma.reverseEtlRun.create({
      data: {
        workspaceId,
        pipelineId,
        recordsSynced,
        status,
      },
    });
  }

  async createSyncTarget(workspaceId: string, name: string, type: string, configJson: string) {
    return this.prisma.syncTarget.create({
      data: {
        workspaceId,
        name,
        type,
        configJson,
      },
    });
  }

  async getPipelines(workspaceId: string) {
    return this.prisma.reverseEtlPipeline.findMany({
      where: { workspaceId },
    });
  }
}
