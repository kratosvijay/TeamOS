import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class StrategyService {
  constructor(private readonly prisma: PrismaService) {}

  async getStrategicInitiatives(workspaceId: string) {
    const list = await this.prisma.strategicInitiative.findMany({
      where: { workspaceId },
    });

    if (list.length === 0) {
      return [
        await this.prisma.strategicInitiative.create({
          data: {
            workspaceId,
            name: 'Maximize SLA Delivery rate',
            description: 'Ensure 95% of tasks are completed within SLA constraints.',
            targetValue: 0.95,
            currentValue: 0.88,
            dueDate: new Date(Date.now() + 30 * 86400 * 1000), // 30 days
          },
        }),
        await this.prisma.strategicInitiative.create({
          data: {
            workspaceId,
            name: 'Optimize Infrastructure Spending',
            description: 'Limit monthly VM cost allocation under $5,000.',
            targetValue: 5000,
            currentValue: 4200,
            dueDate: new Date(Date.now() + 60 * 86400 * 1000), // 60 days
          },
        }),
      ];
    }
    return list;
  }

  async getBalancedScorecard(workspaceId: string, period: string) {
    let scorecard = await this.prisma.enterpriseScorecard.findFirst({
      where: { workspaceId, period },
    });

    if (!scorecard) {
      scorecard = await this.prisma.enterpriseScorecard.create({
        data: {
          workspaceId,
          period,
          financialScore: 84.5,
          customerScore: 89.0,
          processScore: 78.2,
          learningScore: 82.0,
          technologyScore: 91.0,
          aiScore: 95.0,
        },
      });
    }

    return scorecard;
  }

  async getGoalPropagation(recommendationId: string) {
    // Return path tracing Recommendation -> Initiative -> OKR -> Strategy
    return {
      recommendationId,
      path: [
        { level: 'RECOMMENDATION', id: recommendationId, label: 'Add review step automation' },
        { level: 'INITIATIVE', id: 'init-sla', label: 'Improve process mining SLA rate' },
        { level: 'OKR', id: 'okr-1.2', label: 'Reduce cycle time by 20%' },
        { level: 'COMPANY_STRATEGY', id: 'strat-primary', label: 'Operational Efficiency Milestone' },
      ],
    };
  }

  async getKPIDependencyGraph(workspaceId: string) {
    const deps = await this.prisma.kPIDependency.findMany({
      where: { workspaceId },
    });

    if (deps.length === 0) {
      return [
        await this.prisma.kPIDependency.create({
          data: { workspaceId, parentKpi: 'REVENUE', childKpi: 'SALES', weight: 0.85 },
        }),
        await this.prisma.kPIDependency.create({
          data: { workspaceId, parentKpi: 'SALES', childKpi: 'LEADS', weight: 0.65 },
        }),
        await this.prisma.kPIDependency.create({
          data: { workspaceId, parentKpi: 'LEADS', childKpi: 'MARKETING', weight: 0.90 },
        }),
      ];
    }

    return deps;
  }
}
