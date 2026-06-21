import { Test, TestingModule } from '@nestjs/testing';
import { ResourcePlanningService } from '../resource-planning.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('ResourcePlanningService', () => {
  let service: ResourcePlanningService;
  let prisma: PrismaService;

  const mockPrismaService = {
    workspaceMember: {
      count: jest.fn(),
      findMany: jest.fn(),
    },
    task: {
      count: jest.fn(),
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ResourcePlanningService,
        { provide: PrismaService, useValue: mockPrismaService },
      ],
    }).compile();

    service = module.get<ResourcePlanningService>(ResourcePlanningService);
    prisma = module.get<PrismaService>(PrismaService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should calculate remaining resource capacity correctly', async () => {
    mockPrismaService.workspaceMember.count.mockResolvedValue(2);
    mockPrismaService.task.count.mockResolvedValue(10); // 10 active tasks = 10 * 20 = 200 hours allocated

    const result = await service.calculateCapacity('ws-1');
    expect(result.totalCapacityHours).toBe(320); // 2 * 160 = 320
    expect(result.allocatedHours).toBe(200);
    expect(result.remainingHours).toBe(120);
    expect(result.availabilityPercentage).toBe(38); // Math.round(120/320 * 100) = 38
  });

  it('should flag developer overcommitment when active tasks exceed 4', async () => {
    mockPrismaService.workspaceMember.findMany.mockResolvedValue([
      { userId: 'user-1', user: { fullName: 'Alex Rivera' } },
    ]);
    mockPrismaService.task.count.mockResolvedValue(5); // > 4 active tasks

    const result = await service.calculateUtilization('ws-1');
    expect(result[0].utilizationPercentage).toBe(125); // 5/4 * 100
    expect(result[0].overcommitted).toBe(true);
  });
});
