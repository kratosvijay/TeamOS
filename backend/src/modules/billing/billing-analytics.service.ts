import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { RevenueAnalyticsService } from './revenue-analytics.service';
import { TrialService } from './trial.service';

@Injectable()
export class BillingAnalyticsService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly revenueService: RevenueAnalyticsService,
    private readonly trialService: TrialService,
  ) {}

  async getAdminDashboardMetrics() {
    const revenue = await this.revenueService.getRevenueMetrics();
    const trials = await this.trialService.getTrialAnalytics();

    const activeSubscriptions = await this.prisma.workspace.count({
      where: {
        subscriptionStatus: 'ACTIVE',
        plan: { in: ['STARTUP', 'BUSINESS', 'ENTERPRISE'] },
      },
    });

    const totalWorkspaces = await this.prisma.workspace.count();
    const arpu = activeSubscriptions > 0 ? revenue.mrr / activeSubscriptions : 0;
    
    // Simple mock calculation for churn rate
    const churnRate = activeSubscriptions > 0 ? (revenue.churnRevenue / (revenue.mrr || 1)) * 100 : 0;

    return {
      mrr: revenue.mrr,
      arr: revenue.arr,
      activeSubscriptions,
      churnRate: parseFloat(churnRate.toFixed(2)),
      arpu: parseFloat(arpu.toFixed(2)),
      trialConversionRate: trials.conversionRate,
      totalWorkspaces,
    };
  }
}
