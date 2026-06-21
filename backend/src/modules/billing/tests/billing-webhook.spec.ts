import { Test, TestingModule } from '@nestjs/testing';
import { BillingService } from '../billing.service';
import { PrismaService } from '../../prisma/prisma.service';
import { BadRequestException } from '@nestjs/common';

describe('BillingWebhook', () => {
  let service: BillingService;
  let prisma: PrismaService;

  const mockPrisma = {
    billingEvent: {
      findUnique: jest.fn(),
      create: jest.fn(),
      update: jest.fn(),
    },
    workspace: {
      findFirst: jest.fn(),
      update: jest.fn(),
    },
    subscriptionAudit: {
      create: jest.fn(),
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

  it('should process webhook event successfully and enforce idempotency', async () => {
    // 1. Mock event already processed
    mockPrisma.billingEvent.findUnique.mockResolvedValue({ id: 'evt_123' });

    const res = await service.handleWebhook('sig_123', Buffer.from(JSON.stringify({ id: 'evt_123', type: 'invoice.paid' })));
    expect(res.received).toBe(true);
    expect(mockPrisma.billingEvent.create).not.toHaveBeenCalled();
  });

  it('should reject webhook if JSON signature verification fails', async () => {
    // Force Stripe constructEvent to fail by passing invalid signature and env keys
    process.env.STRIPE_API_KEY = 'sk_test_123';
    process.env.STRIPE_WEBHOOK_SECRET = 'whsec_123';

    await expect(service.handleWebhook('invalid_sig', Buffer.from('payload'))).rejects.toThrow(
      BadRequestException,
    );

    delete process.env.STRIPE_API_KEY;
    delete process.env.STRIPE_WEBHOOK_SECRET;
  });
});
