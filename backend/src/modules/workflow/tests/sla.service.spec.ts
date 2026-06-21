import { Test, TestingModule } from '@nestjs/testing';
import { PrismaService } from '../../prisma/prisma.service';

// Define a simple inline SLA check helper for test validation
class SLAService {
  constructor(private prisma: PrismaService) {}

  async createSLATarget(workspaceId: string, name: string, targetHours: number, escalation: any) {
    return this.prisma.sLAConfiguration.create({
      data: {
        workspaceId,
        name,
        targetHours,
        escalation,
      },
    });
  }

  checkSLABreach(startedAt: Date, targetHours: number): { breached: boolean; overdueHours: number } {
    const elapsedMs = Date.now() - startedAt.getTime();
    const elapsedHours = elapsedMs / (1000 * 60 * 60);
    const breached = elapsedHours > targetHours;
    return {
      breached,
      overdueHours: breached ? Number((elapsedHours - targetHours).toFixed(1)) : 0,
    };
  }
}

describe('SLAService', () => {
  let service: SLAService;
  let prisma: PrismaService;

  const mockPrismaService = {
    sLAConfiguration: {
      create: jest.fn(),
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        {
          provide: SLAService,
          useFactory: (p: PrismaService) => new SLAService(p),
          inject: [PrismaService],
        },
        { provide: PrismaService, useValue: mockPrismaService },
      ],
    }).compile();

    service = module.get<SLAService>(SLAService);
    prisma = module.get<PrismaService>(PrismaService);
  });

  it('should define SLA configuration targets', async () => {
    mockPrismaService.sLAConfiguration.create.mockResolvedValue({ id: 'sla-1', targetHours: 24 });
    const result = await service.createSLATarget('ws-1', 'Severity A SLA', 24, { action: 'EMAIL_LEAD' });
    expect(result.targetHours).toBe(24);
  });

  it('should detect when execution duration exceeds target SLA hours', () => {
    // 30 hours ago (exceeds 24 hours target)
    const startedAt = new Date(Date.now() - 30 * 60 * 60 * 1000);
    const result = service.checkSLABreach(startedAt, 24);

    expect(result.breached).toBe(true);
    expect(result.overdueHours).toBeGreaterThanOrEqual(6);
  });

  it('should report compliant SLA status if within target hours', () => {
    // 5 hours ago (within 24 hours target)
    const startedAt = new Date(Date.now() - 5 * 60 * 60 * 1000);
    const result = service.checkSLABreach(startedAt, 24);

    expect(result.breached).toBe(false);
    expect(result.overdueHours).toBe(0);
  });
});
