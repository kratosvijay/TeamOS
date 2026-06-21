import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class PortfolioService {
  constructor(private prisma: PrismaService) {}

  async createPortfolio(name: string, description?: string, workspaceIds: string[] = []) {
    return this.prisma.portfolio.create({
      data: {
        name,
        description,
        workspaces: {
          connect: workspaceIds.map((id) => ({ id })),
        },
      },
    });
  }

  async getPortfolios() {
    return this.prisma.portfolio.findMany({
      include: {
        workspaces: true,
        programs: true,
      },
    });
  }

  async getPortfolio(id: string) {
    const portfolio = await this.prisma.portfolio.findUnique({
      where: { id },
      include: {
        workspaces: {
          include: {
            projects: true,
          },
        },
        programs: true,
      },
    });

    if (!portfolio) {
      throw new NotFoundException(`Portfolio with ID ${id} not found`);
    }

    // 1. Calculate Portfolio Health (e.g. ratio of completed tasks)
    const workspaceIds = portfolio.workspaces.map((w) => w.id);
    const totalTasks = await this.prisma.task.count({
      where: { project: { workspaceId: { in: workspaceIds } } },
    });
    const completedTasks = await this.prisma.task.count({
      where: {
        project: { workspaceId: { in: workspaceIds } },
        status: 'DONE',
      },
    });
    const health = totalTasks > 0 ? Math.round((completedTasks / totalTasks) * 100) : 100;

    // 2. Calculate Portfolio Risk
    const highRiskTasks = await this.prisma.task.count({
      where: {
        project: { workspaceId: { in: workspaceIds } },
        priority: 'HIGH',
        status: { not: 'DONE' },
      },
    });
    const riskLevel = highRiskTasks > 5 ? 'HIGH' : (highRiskTasks > 2 ? 'MEDIUM' : 'LOW');

    // 3. Calculate Portfolio Velocity
    const sprintCount = await this.prisma.sprint.count({
      where: { project: { workspaceId: { in: workspaceIds } } },
    });
    const velocity = sprintCount > 0 ? Math.round(completedTasks / sprintCount) : completedTasks;

    return {
      ...portfolio,
      health,
      riskLevel,
      velocity,
      strategicAlignment: 'Aligned',
    };
  }

  async createProgram(portfolioId: string, name: string, description?: string, startDate?: string, endDate?: string) {
    return this.prisma.program.create({
      data: {
        portfolioId,
        name,
        description,
        startDate: startDate ? new Date(startDate) : undefined,
        endDate: endDate ? new Date(endDate) : undefined,
      },
    });
  }

  async getPrograms(portfolioId?: string) {
    return this.prisma.program.findMany({
      where: portfolioId ? { portfolioId } : undefined,
      include: {
        portfolio: true,
      },
    });
  }
}
