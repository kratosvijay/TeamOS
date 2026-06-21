import { Test, TestingModule } from '@nestjs/testing';
import { BillingController } from '../billing.controller';
import { BillingService } from '../billing.service';
import { BillingAnalyticsService } from '../billing-analytics.service';
import { PrismaService } from '../../prisma/prisma.service';
import { JwtStrategy } from '../../auth/jwt.strategy';

describe('BillingController', () => {
  let controller: BillingController;
  let service: BillingService;

  const mockBillingService = {
    createCheckoutSession: jest.fn().mockResolvedValue({ url: 'http://checkout' }),
    createPortalSession: jest.fn().mockResolvedValue({ url: 'http://portal' }),
    getSubscription: jest.fn().mockResolvedValue({ plan: 'FREE', status: 'ACTIVE' }),
    getUsage: jest.fn().mockResolvedValue({ users: 2, projects: 5 }),
    getInvoices: jest.fn().mockResolvedValue([]),
    handleWebhook: jest.fn().mockResolvedValue({ received: true }),
  };

  const mockAnalyticsService = {
    getAdminDashboardMetrics: jest.fn().mockResolvedValue({ mrr: 1000 }),
  };

  const mockJwtStrategy = {
    validateToken: jest.fn().mockResolvedValue({ id: 'user-123', email: 'user@teamos.local' }),
  };

  const mockPrisma = {
    workspaceMember: {
      findUnique: jest.fn().mockResolvedValue({ userId: 'user-123', workspaceId: 'ws-123', status: 'ACTIVE' }),
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [BillingController],
      providers: [
        { provide: BillingService, useValue: mockBillingService },
        { provide: BillingAnalyticsService, useValue: mockAnalyticsService },
        { provide: JwtStrategy, useValue: mockJwtStrategy },
        { provide: PrismaService, useValue: mockPrisma },
      ],
    }).compile();

    controller = module.get<BillingController>(BillingController);
    service = module.get<BillingService>(BillingService);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });

  it('should return checkout session url', async () => {
    const res = await controller.checkoutSession('ws-123', 'STARTUP');
    expect(res.url).toBe('http://checkout');
  });

  it('should return subscription status', async () => {
    const res = await controller.getSubscription('ws-123');
    expect(res.plan).toBe('FREE');
  });
});
