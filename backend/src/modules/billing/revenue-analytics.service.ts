import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class RevenueAnalyticsService {
  constructor(private readonly prisma: PrismaService) {}

  private getPlanMonthlyValue(plan: string): number {
    switch (plan) {
      case 'STARTUP':
        return 29;
      case 'BUSINESS':
        return 99;
      case 'ENTERPRISE':
        return 999;
      default:
        return 0;
    }
  }

  async getRevenueMetrics() {
    const activeWorkspaces = await this.prisma.workspace.findMany({
      where: { subscriptionStatus: 'ACTIVE' },
      select: { plan: true },
    });

    let mrr = 0;
    for (const ws of activeWorkspaces) {
      mrr += this.getPlanMonthlyValue(ws.plan);
    }

    const arr = mrr * 12;

    // Fetch audits or invoice collections to estimate expansion/churn
    const churnedWorkspaces = await this.prisma.workspace.findMany({
      where: { subscriptionStatus: 'CANCELED', plan: 'FREE' },
      select: { id: true },
    });

    // Mock expansion and churn based on database audit stats or defaults
    const churnCount = churnedWorkspaces.length;
    const churnRevenue = churnCount * 29;
    const expansionRevenue = 158; // Mocked value
    const forecastedRevenue = mrr * 1.15; // Forecasting 15% growth

    // Net Revenue Retention
    const startingMrr = Math.max(100, mrr - expansionRevenue + churnRevenue);
    const nrr = parseFloat((((startingMrr + expansionRevenue - churnRevenue) / startingMrr) * 100).toFixed(2));

    return {
      mrr,
      arr,
      nrr,
      expansionRevenue,
      churnRevenue,
      forecastedRevenue: parseFloat(forecastedRevenue.toFixed(2)),
    };
  }
}
