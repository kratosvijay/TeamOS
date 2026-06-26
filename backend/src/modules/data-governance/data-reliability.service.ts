import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class DataReliabilityService {
  constructor(private readonly prisma: PrismaService) {}

  async updateReliabilityScore(workspaceId: string, datasetId: string, score: number) {
    const existing = await this.prisma.reliabilityScore.findFirst({
      where: { workspaceId, datasetId },
    });

    if (existing) {
      return this.prisma.reliabilityScore.update({
        where: { id: existing.id },
        data: { score },
      });
    }

    return this.prisma.reliabilityScore.create({
      data: {
        workspaceId,
        datasetId,
        score,
      },
    });
  }

  async reportIncident(workspaceId: string, datasetId: string, title: string, description: string) {
    return this.prisma.reliabilityIncident.create({
      data: {
        workspaceId,
        datasetId,
        title,
        description,
        status: 'OPEN',
      },
    });
  }

  async resolveIncident(incidentId: string) {
    return this.prisma.reliabilityIncident.update({
      where: { id: incidentId },
      data: { status: 'RESOLVED' },
    });
  }
}
