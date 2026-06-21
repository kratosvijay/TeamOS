import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class BIService {
  constructor(private prisma: PrismaService) {}

  async generateBIDashboard(workspaceId: string) {
    // 1. Sprint Velocity Trends
    const sprints = await this.prisma.sprint.findMany({
      where: { project: { workspaceId } },
      take: 5,
      orderBy: { startDate: 'desc' },
    });

    const velocityTrends = await Promise.all(
      sprints.map(async (s) => {
        const completedCount = await this.prisma.task.count({
          where: { sprintId: s.id, status: 'DONE' },
        });
        return {
          sprintName: s.name,
          completedTasks: completedCount,
        };
      }),
    );

    // 2. Delivery Trends (Count of tasks completed per month for the last 3 months)
    const now = new Date();
    const deliveryTrends = [];
    for (let i = 2; i >= 0; i--) {
      const startOfMonth = new Date(now.getFullYear(), now.getMonth() - i, 1);
      const endOfMonth = new Date(now.getFullYear(), now.getMonth() - i + 1, 0);

      const completedCount = await this.prisma.task.count({
        where: {
          project: { workspaceId },
          status: 'DONE',
          updatedAt: {
            gte: startOfMonth,
            lte: endOfMonth,
          },
        },
      });

      deliveryTrends.push({
        month: startOfMonth.toLocaleString('default', { month: 'short' }),
        completedTasks: completedCount,
      });
    }

    // 3. Workspace Productivity Score
    const totalMembers = await this.prisma.workspaceMember.count({
      where: { workspaceId },
    });
    const completedTasks = await this.prisma.task.count({
      where: { project: { workspaceId }, status: 'DONE' },
    });
    const productivityScore = totalMembers > 0 ? Math.round((completedTasks / totalMembers) * 10) : 100;

    // 4. Meeting Efficiency Score
    const meetingsCount = await this.prisma.meeting.count({
      where: { workspaceId },
    });
    const meetingEfficiency = meetingsCount > 0 ? Math.max(100 - meetingsCount * 5, 40) : 100;

    // 5. AI Productivity
    const workspace = await this.prisma.workspace.findUnique({
      where: { id: workspaceId },
      select: { aiTokensUsed: true },
    });
    const aiTokens = workspace?.aiTokensUsed || 0;
    const aiProductivityMultiplier = aiTokens > 0 ? Math.round((completedTasks / aiTokens) * 1000) : 10;

    // 6. Department Performance (Mocked node values for demonstration)
    const departments = await this.prisma.department.findMany({
      where: { organization: { workspaces: { some: { id: workspaceId } } } },
    });

    const departmentPerformance = departments.map((d, index) => ({
      departmentName: d.name,
      performanceScore: 80 + (index * 5) % 20, // e.g. 80%, 85%, 90%
    }));

    return {
      workspaceId,
      velocityTrends,
      deliveryTrends,
      productivityScore,
      meetingEfficiency,
      aiProductivityMultiplier,
      departmentPerformance,
      timestamp: new Date().toISOString(),
    };
  }
}
