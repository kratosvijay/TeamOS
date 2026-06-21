import { Test, TestingModule } from '@nestjs/testing';
import { BillingService } from '../billing.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('BillingService', () => {
  let service: BillingService;
  let prisma: PrismaService;

  const mockWorkspace = {
    id: 'ws-123',
    stripeCustomerId: 'cus_123',
    stripeSubscriptionId: 'sub_123',
    plan: 'FREE',
    subscriptionStatus: 'ACTIVE',
    subscriptionPeriodEnd: new Date(),
    aiTokensUsed: 1000,
    storageBytesUsed: BigInt(500),
  };

  const mockPrisma = {
    workspace: {
      findUnique: jest.fn().mockResolvedValue(mockWorkspace),
      findFirst: jest.fn().mockResolvedValue(mockWorkspace),
      update: jest.fn().mockResolvedValue(mockWorkspace),
    },
    usageSnapshot: {
      findFirst: jest.fn().mockResolvedValue(null),
    },
    workspaceSeat: {
      count: jest.fn().mockResolvedValue(2),
    },
    project: {
      count: jest.fn().mockResolvedValue(5),
    },
    document: {
      count: jest.fn().mockResolvedValue(3),
    },
    subscriptionInvoice: {
      findMany: jest.fn().mockResolvedValue([]),
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        BillingService,
        { provide: PrismaService, useValue: mockPrisma },
      ],
    }).compile();

    service = module.get<BillingService>(BillingService);
    prisma = module.get<PrismaService>(PrismaService);
  });

  it('should generate mock checkout session URLs', async () => {
    const res = await service.createCheckoutSession('ws-123', 'STARTUP');
    expect(res.url).toContain('checkout.stripe.com/pay/mock_session_ws-123_startup');
  });

  it('should generate mock portal session URLs', async () => {
    const res = await service.createPortalSession('ws-123');
    expect(res.url).toContain('billing.stripe.com/p/session/mock_portal_ws-123');
  });

  it('should fetch workspace subscription parameters', async () => {
    const res = await service.getSubscription('ws-123');
    expect(res.plan).toBe('FREE');
    expect(res.status).toBe('ACTIVE');
  });

  it('should calculate live usage numbers', async () => {
    const res = await service.getUsage('ws-123');
    expect(res.users).toBe(2);
    expect(res.projects).toBe(5);
    expect(res.storage).toBe(500);
  });
});
