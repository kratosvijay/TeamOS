import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class ResourcePlanningService {
  constructor(private prisma: PrismaService) {}

  async calculateCapacity(workspaceId: string) {
    const totalMembers = await this.prisma.workspaceMember.count({
      where: { workspaceId },
    });

    const activeTasks = await this.prisma.task.count({
      where: {
        project: { workspaceId },
        status: { not: 'DONE' },
      },
    });

    // 160 hours per month base capacity per member
    const totalCapacityHours = totalMembers * 160;
    // Assume average task takes 20 hours
    const allocatedHours = activeTasks * 20;
    const remainingHours = Math.max(totalCapacityHours - allocatedHours, 0);

    return {
      totalMembers,
      totalCapacityHours,
      allocatedHours,
      remainingHours,
      availabilityPercentage: totalCapacityHours > 0 ? Math.round((remainingHours / totalCapacityHours) * 100) : 100,
    };
  }

  async calculateUtilization(workspaceId: string) {
    const members = await this.prisma.workspaceMember.findMany({
      where: { workspaceId },
      include: {
        user: true,
      },
    });

    const utilizationResults = [];

    for (const member of members) {
      const activeTasksCount = await this.prisma.task.count({
        where: {
          assigneeId: member.userId,
          status: { not: 'DONE' },
        },
      });

      // Target baseline is 4 active tasks per developer.
      const utilizationPercentage = Math.round((activeTasksCount / 4) * 100);
      const overcommitted = utilizationPercentage > 100;
      const burnoutRisk = activeTasksCount > 5;

      utilizationResults.push({
        userId: member.userId,
        fullName: member.user.fullName,
        activeTasksCount,
        utilizationPercentage,
        overcommitted,
        burnoutRisk,
      });
    }

    return utilizationResults;
  }
}
