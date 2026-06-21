import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class ForecastingService {
  constructor(private prisma: PrismaService) {}

  async calculateDeliveryForecast(workspaceId: string, remainingStoryPoints = 50) {
    const completedTasksCount = await this.prisma.task.count({
      where: { project: { workspaceId }, status: 'DONE' },
    });

    const sprintsCount = await this.prisma.sprint.count({
      where: { project: { workspaceId } },
    });

    // Assume average story points per task is 3. Average velocity is (completedTasks * 3) / sprints
    const averageVelocity = sprintsCount > 0 ? Math.max((completedTasksCount * 3) / sprintsCount, 10) : 15;
    const remainingSprints = Math.ceil(remainingStoryPoints / averageVelocity);
    const estimatedCompletionDate = new Date(Date.now() + remainingSprints * 14 * 24 * 60 * 60 * 1000);

    return {
      averageVelocity,
      remainingStoryPoints,
      remainingSprints,
      estimatedCompletionDate,
    };
  }

  async calculateBurnoutForecast(workspaceId: string) {
    const members = await this.prisma.workspaceMember.findMany({
      where: { workspaceId },
      include: {
        user: true,
      },
    });

    const results = [];

    for (const member of members) {
      const activeHighPriorityTasks = await this.prisma.task.count({
        where: {
          assigneeId: member.userId,
          status: { not: 'DONE' },
          priority: 'HIGH',
        },
      });

      const meetingsCount = await this.prisma.meetingParticipant.count({
        where: { userId: member.userId },
      });

      // Rule: >5 High Priority Active Tasks = Burnout Warning
      const burnoutWarning = activeHighPriorityTasks > 5;

      results.push({
        userId: member.userId,
        fullName: member.user.fullName,
        activeHighPriorityTasks,
        meetingsCount,
        burnoutWarning,
      });
    }

    return results;
  }

  async calculateCapacityForecast(workspaceId: string) {
    const totalMembersCount = await this.prisma.workspaceMember.count({
      where: { workspaceId },
    });

    // 40 hours per week per developer
    const totalCapacityHours = totalMembersCount * 40;

    const activeTasksCount = await this.prisma.task.count({
      where: { project: { workspaceId }, status: { not: 'DONE' } },
    });

    // Assume average active task consumes 8 hours of capacity
    const consumedCapacity = activeTasksCount * 8;
    const remainingCapacity = Math.max(totalCapacityHours - consumedCapacity, 0);

    return {
      totalCapacityHours,
      consumedCapacity,
      remainingCapacity,
      utilizationRate: totalCapacityHours > 0 ? Math.round((consumedCapacity / totalCapacityHours) * 100) : 0,
    };
  }

  async generateForecast(workspaceId: string, forecastType: 'DELIVERY' | 'CAPACITY' | 'REVENUE' | 'BUDGET' | 'RISK') {
    let resultJson: any = {};

    if (forecastType === 'DELIVERY') {
      resultJson = await this.calculateDeliveryForecast(workspaceId);
    } else if (forecastType === 'CAPACITY') {
      resultJson = await this.calculateCapacityForecast(workspaceId);
    } else if (forecastType === 'RISK') {
      resultJson = await this.calculateBurnoutForecast(workspaceId);
    } else {
      // Mock BUDGET or REVENUE forecasts
      resultJson = {
        forecastedBudgetBurn: 15000,
        expectedVariance: 500,
        runRate: 1200,
      };
    }

    return this.prisma.forecast.create({
      data: {
        workspaceId,
        forecastType,
        result: JSON.parse(JSON.stringify(resultJson)),
      },
    });
  }

  async getForecasts(workspaceId: string) {
    return this.prisma.forecast.findMany({
      where: { workspaceId },
      orderBy: { createdAt: 'desc' },
    });
  }
}
