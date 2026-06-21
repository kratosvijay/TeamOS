import { Test, TestingModule } from '@nestjs/testing';
import { WarehouseService } from '../warehouse.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('WarehouseService', () => {
  let service: WarehouseService;
  let prisma: PrismaService;

  const mockPrismaService = {
    project: {
      count: jest.fn(),
    },
    task: {
      count: jest.fn(),
    },
    meeting: {
      count: jest.fn(),
    },
    workspace: {
      findUnique: jest.fn(),
    },
    warehouseSnapshot: {
      create: jest.fn(),
      findMany: jest.fn(),
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        WarehouseService,
        { provide: PrismaService, useValue: mockPrismaService },
      ],
    }).compile();

    service = module.get<WarehouseService>(WarehouseService);
    prisma = module.get<PrismaService>(PrismaService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should run ETL pipeline and create analytical snapshot successfully', async () => {
    mockPrismaService.project.count.mockResolvedValue(3);
    mockPrismaService.task.count
      .mockResolvedValueOnce(20) // total
      .mockResolvedValueOnce(12); // completed
    mockPrismaService.meeting.count.mockResolvedValue(5);
    mockPrismaService.workspace.findUnique.mockResolvedValue({ aiTokensUsed: 1500, storageBytesUsed: BigInt(1048576) });
    mockPrismaService.warehouseSnapshot.create.mockResolvedValue({ id: 'snapshot-1' });

    const result = await service.runETLPipeline('ws-1');
    expect(result).toBeDefined();
    expect(mockPrismaService.warehouseSnapshot.create).toHaveBeenCalledWith(
      expect.objectContaining({
        data: expect.objectContaining({
          projectsCount: 3,
          tasksCount: 20,
          completedTasks: 12,
          meetingsCount: 5,
          meetingMinutes: 225, // 5 * 45 = 225
          aiTokens: 1500,
        }),
      }),
    );
  });
});
