import { Test, TestingModule } from '@nestjs/testing';
import { BillingAnalyticsService } from '../billing-analytics.service';
import { RevenueAnalyticsService } from '../revenue-analytics.service';
import { TrialService } from '../trial.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('BillingAnalytics', () => {
  let service: BillingAnalyticsService;
  let prisma: PrismaService;

  const mockRevenueService = {
    getRevenueMetrics: jest.fn().mockResolvedValue({
      mrr: 1500,
      arr: 18000,
      nrr: 102.5,
      expansionRevenue: 200,
      churnRevenue: 50,
      forecastedRevenue: 1725,
    }),
  };

  const mockTrialService = {
    getTrialAnalytics: jest.fn().mockResolvedValue({
      conversionRate: 25.5,
    }),
  };

  const mockPrisma = {
    workspace: {
      count: jest.fn().mockResolvedValue(10),
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        BillingAnalyticsService,
        { provide: RevenueAnalyticsService, useValue: mockRevenueService },
        { provide: TrialService, useValue: mockTrialService },
        { provide: PrismaService, useValue: mockPrisma },
      ],
    }).compile();

    service = module.get<BillingAnalyticsService>(BillingAnalyticsService);
    prisma = module.get<PrismaService>(PrismaService);
  });

  it('should compile SaaS administrative KPIs correctly', async () => {
    const res = await service.getAdminDashboardMetrics();
    expect(res.mrr).toBe(1500);
    expect(res.arr).toBe(18000);
    expect(res.trialConversionRate).toBe(25.5);
    expect(res.arpu).toBe(150); // mrr (1500) / activeSubscriptions (10)
  });
});
