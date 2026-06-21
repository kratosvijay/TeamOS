import { Test, TestingModule } from '@nestjs/testing';
import { ComplianceService } from '../compliance.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('ComplianceService', () => {
  let service: ComplianceService;
  let prisma: PrismaService;

  const mockPrismaService = {
    securityPolicy: {
      findUnique: jest.fn(),
    },
    dLPPolicy: {
      count: jest.fn(),
    },
    retentionPolicy: {
      count: jest.fn(),
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ComplianceService,
        { provide: PrismaService, useValue: mockPrismaService },
      ],
    }).compile();

    service = module.get<ComplianceService>(ComplianceService);
    prisma = module.get<PrismaService>(PrismaService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should calculate compliance score based on configured features', async () => {
    mockPrismaService.securityPolicy.findUnique.mockResolvedValue({
      requireMFA: true,
      ipAllowlist: ['192.168.1.1'],
    });
    mockPrismaService.dLPPolicy.count.mockResolvedValue(1);
    mockPrismaService.retentionPolicy.count.mockResolvedValue(1);

    const report = await service.generateComplianceReport('ws-1', 'SOC2');
    expect(report.score).toBe(100); // Base 50 + 15 (MFA) + 15 (IP) + 10 (DLP) + 10 (retention)
    expect(report.recommendations).toHaveLength(0);
  });

  it('should report lower scores and offer recommendations when configurations are missing', async () => {
    mockPrismaService.securityPolicy.findUnique.mockResolvedValue(null);
    mockPrismaService.dLPPolicy.count.mockResolvedValue(0);
    mockPrismaService.retentionPolicy.count.mockResolvedValue(0);

    const report = await service.generateComplianceReport('ws-1', 'ISO27001');
    expect(report.score).toBe(50);
    expect(report.recommendations.length).toBeGreaterThan(0);
  });
});
