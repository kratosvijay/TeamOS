import { Test, TestingModule } from '@nestjs/testing';
import { PortfolioService } from '../portfolio.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('PortfolioService', () => {
  let service: PortfolioService;
  let prisma: PrismaService;

  const mockPrismaService = {
    portfolio: {
      create: jest.fn(),
      findMany: jest.fn(),
      findUnique: jest.fn(),
    },
    program: {
      create: jest.fn(),
      findMany: jest.fn(),
    },
    task: {
      count: jest.fn(),
    },
    sprint: {
      count: jest.fn(),
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        PortfolioService,
        { provide: PrismaService, useValue: mockPrismaService },
      ],
    }).compile();

    service = module.get<PortfolioService>(PortfolioService);
    prisma = module.get<PrismaService>(PrismaService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should create portfolio successfully', async () => {
    mockPrismaService.portfolio.create.mockResolvedValue({ id: 'port-1', name: 'Strategic Portfolio' });

    const result = await service.createPortfolio('Strategic Portfolio', 'Description', ['ws-1']);
    expect(result).toBeDefined();
    expect(mockPrismaService.portfolio.create).toHaveBeenCalled();
  });

  it('should compute health, risk, and velocity correctly in getPortfolio', async () => {
    mockPrismaService.portfolio.findUnique.mockResolvedValue({
      id: 'port-1',
      name: 'Strategic Portfolio',
      workspaces: [{ id: 'ws-1', projects: [] }],
      programs: [],
    });

    mockPrismaService.task.count
      .mockResolvedValueOnce(10) // totalTasks
      .mockResolvedValueOnce(7)  // completedTasks
      .mockResolvedValueOnce(1);  // highRiskTasks

    mockPrismaService.sprint.count.mockResolvedValue(2);

    const result = await service.getPortfolio('port-1');
    expect(result.health).toBe(70); // (7/10)*100
    expect(result.riskLevel).toBe('LOW'); // 1 high priority incomplete tasks <= 2
    expect(result.velocity).toBe(4); // 7 completed / 2 sprints = 3.5 -> rounded to 4
  });
});
