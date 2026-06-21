import { Test, TestingModule } from '@nestjs/testing';
import { BIService } from '../bi.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('BIService', () => {
  let service: BIService;
  let prisma: PrismaService;

  const mockPrismaService = {
    sprint: {
      findMany: jest.fn(),
      count: jest.fn(),
    },
    task: {
      count: jest.fn(),
    },
    workspaceMember: {
      count: jest.fn(),
    },
    meeting: {
      count: jest.fn(),
    },
    workspace: {
      findUnique: jest.fn(),
    },
    department: {
      findMany: jest.fn(),
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        BIService,
        { provide: PrismaService, useValue: mockPrismaService },
      ],
    }).compile();

    service = module.get<BIService>(BIService);
    prisma = module.get<PrismaService>(PrismaService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should compile BI trends and scores successfully', async () => {
    mockPrismaService.sprint.findMany.mockResolvedValue([
      { id: 'sprint-1', name: 'Sprint 1' },
    ]);
    mockPrismaService.task.count
      .mockResolvedValueOnce(5)  // sprint tasks completed
      .mockResolvedValueOnce(3)  // month 3 completed
      .mockResolvedValueOnce(4)  // month 2 completed
      .mockResolvedValueOnce(5)  // month 1 completed
      .mockResolvedValueOnce(12); // total completed for productivity
    mockPrismaService.workspaceMember.count.mockResolvedValue(4);
    mockPrismaService.meeting.count.mockResolvedValue(5);
    mockPrismaService.workspace.findUnique.mockResolvedValue({ aiTokensUsed: 100 });
    mockPrismaService.department.findMany.mockResolvedValue([
      { id: 'dep-1', name: 'Software Development' },
    ]);

    const result = await service.generateBIDashboard('ws-1');
    expect(result.velocityTrends).toHaveLength(1);
    expect(result.deliveryTrends).toHaveLength(3);
    expect(result.productivityScore).toBe(30); // 12 completed / 4 members * 10 = 30
    expect(result.meetingEfficiency).toBe(75); // 100 - 5 * 5 = 75
    expect(result.aiProductivityMultiplier).toBe(120); // 12 completed / 100 tokens * 1000 = 120
    expect(result.departmentPerformance[0].performanceScore).toBe(80);
  });
});
