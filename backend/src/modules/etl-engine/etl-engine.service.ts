import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class EtlEngineService {
  constructor(private readonly prisma: PrismaService) {}

  async createPipeline(workspaceId: string, name: string, sourceConnId: string, targetConnId: string) {
    return this.prisma.etlPipeline.create({
      data: {
        workspaceId,
        name,
        sourceConnId,
        targetConnId,
      },
    });
  }

  async runPipeline(workspaceId: string, pipelineId: string, status: string, recordsCount: number) {
    return this.prisma.etlPipelineRun.create({
      data: {
        workspaceId,
        pipelineId,
        status,
        recordsCount,
      },
    });
  }

  async saveTemplate(workspaceId: string, name: string, configJson: string) {
    return this.prisma.etlPipelineTemplate.create({
      data: {
        workspaceId,
        name,
        configJson,
      },
    });
  }

  async registerDataset(workspaceId: string, name: string, type: string) {
    return this.prisma.etlDataset.create({
      data: {
        workspaceId,
        name,
        type,
      },
    });
  }

  async addDatasetVersion(workspaceId: string, datasetId: string, version: string, metadataJson: string) {
    return this.prisma.etlDatasetVersion.create({
      data: {
        workspaceId,
        datasetId,
        version,
        metadataJson,
      },
    });
  }
}
