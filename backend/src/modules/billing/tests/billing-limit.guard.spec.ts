import { Test, TestingModule } from '@nestjs/testing';
import { Reflector } from '@nestjs/core';
import { BillingLimitGuard, LIMIT_METADATA_KEY } from '../guards/billing-limit.guard';
import { PrismaService } from '../../prisma/prisma.service';
import { BillingGraceService } from '../billing-grace.service';
import { ExecutionContext, HttpException, HttpStatus } from '@nestjs/common';

describe('BillingLimitGuard', () => {
  let guard: BillingLimitGuard;
  let prisma: PrismaService;
  let reflector: Reflector;

  const mockPrisma = {
    workspace: {
      findUnique: jest.fn().mockResolvedValue({
        plan: 'FREE',
        subscriptionStatus: 'ACTIVE',
        aiTokensUsed: 6000,
        storageBytesUsed: BigInt(500),
      }),
    },
    project: {
      count: jest.fn().mockResolvedValue(6),
    },
    workspaceSeat: {
      count: jest.fn().mockResolvedValue(2),
    },
  };

  const mockGraceService = {
    checkGracePeriod: jest.fn().mockResolvedValue({ allowed: true, inGrace: false }),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        BillingLimitGuard,
        Reflector,
        { provide: PrismaService, useValue: mockPrisma },
        { provide: BillingGraceService, useValue: mockGraceService },
      ],
    }).compile();

    guard = module.get<BillingLimitGuard>(BillingLimitGuard);
    prisma = module.get<PrismaService>(PrismaService);
    reflector = module.get<Reflector>(Reflector);
  });

  const createMockContext = (limitType: string | null, workspaceId = 'ws-123'): ExecutionContext => {
    const mockRequest = {
      headers: { 'x-workspace-id': workspaceId },
      query: {},
      params: {},
    };
    return {
      switchToHttp: () => ({
        getRequest: () => mockRequest,
      }),
      getHandler: () => ({}),
      getClass: () => ({}),
    } as any;
  };

  it('should allow request when no limit type is metadata key defined', async () => {
    jest.spyOn(reflector, 'get').mockReturnValue(null);
    const context = createMockContext(null);
    const res = await guard.canActivate(context);
    expect(res).toBe(true);
  });

  it('should throw 402 if projects count limit is breached', async () => {
    jest.spyOn(reflector, 'get').mockReturnValue('PROJECTS');
    const context = createMockContext('PROJECTS');
    
    await expect(guard.canActivate(context)).rejects.toThrow(
      new HttpException(
        {
          code: 'PLAN_LIMIT_REACHED',
          limit: 'PROJECTS',
          current: 7,
          allowed: 5,
        },
        HttpStatus.PAYMENT_REQUIRED,
      ),
    );
  });

  it('should throw 402 if AI token limits are breached', async () => {
    jest.spyOn(reflector, 'get').mockReturnValue('AI_TOKENS');
    const context = createMockContext('AI_TOKENS');

    await expect(guard.canActivate(context)).rejects.toThrow(
      new HttpException(
        {
          code: 'PLAN_LIMIT_REACHED',
          limit: 'AI_TOKENS',
          current: 6001,
          allowed: 5000,
        },
        HttpStatus.PAYMENT_REQUIRED,
      ),
    );
  });
});
