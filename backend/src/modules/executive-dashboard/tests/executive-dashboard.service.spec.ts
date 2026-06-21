import { Test, TestingModule } from '@nestjs/testing';
import { ExecutiveService } from '../executive.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('ExecutiveService', () => {
  let service: ExecutiveService;
  let prisma: PrismaService;

  const mockPrismaService = {
    workspaceSeat: {
      count: jest.fn(),
    },
    task: {
      count: jest.fn(),
    },
    securityPolicy: {
      findUnique: jest.fn(),
    },
    dLPPolicy: {
      count: jest.fn(),
    },
    retentionPolicy: {
      count: jest.fn(),
    },
    portfolio: {
      findFirst: jest.fn(),
    },
    workspaceMember: {
      count: jest.fn(),
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ExecutiveService,
        { provide: PrismaService, useValue: mockPrismaService },
      ],
    }).compile();

    service = module.get<ExecutiveService>(ExecutiveService);
    prisma = module.get<PrismaService>(PrismaService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should compile financial and security metrics successfully', async () => {
    mockPrismaService.workspaceSeat.count.mockResolvedValue(10); // MRR = 5000 + 10 * 15 = 5150
    mockPrismaService.task.count
      .mockResolvedValueOnce(30) // total
      .mockResolvedValueOnce(18) // completed -> health = 60%
      .mockResolvedValueOnce(2);  // high priority incomplete tasks
    mockPrismaService.securityPolicy.findUnique.mockResolvedValue({ requireMFA: true, ipAllowlist: ['192.168.1.1'] });
    mockPrismaService.dLPPolicy.count.mockResolvedValue(1);
    mockPrismaService.retentionPolicy.count.mockResolvedValue(1);
    mockPrismaService.portfolio.findFirst.mockResolvedValue({ id: 'port-1' });
    mockPrismaService.workspaceMember.count.mockResolvedValue(5);

    const result = await service.getExecutiveDashboard('ws-1');
    expect(result.mrr).toBe(5150);
    expect(result.arr).toBe(5150 * 12);
    expect(result.workspaceHealth).toBe(60);
    expect(result.securityScore).toBe(100); // 60 + 20 + 20
    expect(result.complianceScore).toBe(100); // 50 + 15 + 15 + 10 + 10
    expect(result.portfolioHealth).toBe(85);
  });
});
