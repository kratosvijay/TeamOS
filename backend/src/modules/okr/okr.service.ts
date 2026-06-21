import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class OKRService {
  constructor(private prisma: PrismaService) {}

  async createObjective(workspaceId: string, title: string, description?: string) {
    return this.prisma.objective.create({
      data: {
        workspaceId,
        title,
        description,
        progress: 0,
      },
    });
  }

  async createKeyResult(objectiveId: string, title: string, currentValue: number, targetValue: number) {
    if (targetValue <= 0) {
      throw new Error('Target value must be greater than zero');
    }

    const kr = await this.prisma.keyResult.create({
      data: {
        objectiveId,
        title,
        currentValue,
        targetValue,
      },
    });

    // Recompute Objective progress
    await this.updateObjectiveProgress(objectiveId);

    return kr;
  }

  async updateObjectiveProgress(objectiveId: string) {
    const objective = await this.prisma.objective.findUnique({
      where: { id: objectiveId },
      include: { keyResults: true },
    });

    if (!objective) {
      throw new NotFoundException(`Objective with ID ${objectiveId} not found`);
    }

    if (objective.keyResults.length === 0) {
      return this.prisma.objective.update({
        where: { id: objectiveId },
        data: { progress: 0 },
      });
    }

    // Compute progress for each KeyResult: (currentValue / targetValue) * 100
    let totalProgress = 0;
    for (const kr of objective.keyResults) {
      const progress = Math.min((kr.currentValue / kr.targetValue) * 100, 100);
      totalProgress += progress;
    }

    const averageProgress = Math.round(totalProgress / objective.keyResults.length);

    return this.prisma.objective.update({
      where: { id: objectiveId },
      data: { progress: averageProgress },
    });
  }

  async getOkrDashboard(workspaceId: string) {
    const objectives = await this.prisma.objective.findMany({
      where: { workspaceId },
      include: { keyResults: true },
      orderBy: { createdAt: 'desc' },
    });

    return objectives;
  }
}
