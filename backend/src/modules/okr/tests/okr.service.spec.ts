import { Test, TestingModule } from '@nestjs/testing';
import { OKRService } from '../okr.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('OKRService', () => {
  let service: OKRService;
  let prisma: PrismaService;

  const mockPrismaService = {
    objective: {
      create: jest.fn(),
      findUnique: jest.fn(),
      update: jest.fn(),
      findMany: jest.fn(),
    },
    keyResult: {
      create: jest.fn(),
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        OKRService,
        { provide: PrismaService, useValue: mockPrismaService },
      ],
    }).compile();

    service = module.get<OKRService>(OKRService);
    prisma = module.get<PrismaService>(PrismaService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should create objective successfully', async () => {
    mockPrismaService.objective.create.mockResolvedValue({ id: 'obj-1', title: 'Q3 Goal' });

    const result = await service.createObjective('ws-1', 'Q3 Goal', 'Description');
    expect(result).toBeDefined();
    expect(mockPrismaService.objective.create).toHaveBeenCalled();
  });

  it('should compute average progress from key results progress', async () => {
    mockPrismaService.objective.findUnique.mockResolvedValue({
      id: 'obj-1',
      title: 'Q3 Goal',
      keyResults: [
        { id: 'kr-1', currentValue: 5, targetValue: 10 },  // 50%
        { id: 'kr-2', currentValue: 8, targetValue: 10 },  // 80%
      ],
    });

    mockPrismaService.objective.update.mockResolvedValue({ id: 'obj-1', progress: 65 });

    const result = await service.updateObjectiveProgress('obj-1');
    expect(result.progress).toBe(65); // Average of 50 and 80 is 65
    expect(mockPrismaService.objective.update).toHaveBeenCalledWith(
      expect.objectContaining({
        data: { progress: 65 },
      }),
    );
  });
});
