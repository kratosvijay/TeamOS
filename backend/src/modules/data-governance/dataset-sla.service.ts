import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class DatasetSlaService {
  constructor(private readonly prisma: PrismaService) {}

  async createSla(workspaceId: string, datasetId: string, metric: string, threshold: number) {
    return this.prisma.datasetSla.create({
      data: {
        workspaceId,
        datasetId,
        metric,
        threshold,
      },
    });
  }

  async configureFreshness(workspaceId: string, datasetId: string, maxAgeMinutes: number) {
    return this.prisma.freshnessPolicy.create({
      data: {
        workspaceId,
        datasetId,
        maxAgeMinutes,
      },
    });
  }

  async configureAvailability(workspaceId: string, datasetId: string, uptimePct: number) {
    return this.prisma.availabilityPolicy.create({
      data: {
        workspaceId,
        datasetId,
        uptimePct,
      },
    });
  }

  async getSlas(workspaceId: string, datasetId: string) {
    return this.prisma.datasetSla.findMany({
      where: {
        workspaceId,
        datasetId,
      },
    });
  }
}
