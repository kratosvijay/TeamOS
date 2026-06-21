import { Test, TestingModule } from '@nestjs/testing';
import { ForecastingService } from '../forecasting.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('ForecastingService', () => {
  let service: ForecastingService;
  let prisma: PrismaService;

  const mockPrismaService = {
    task: {
      count: jest.fn(),
    },
    sprint: {
      count: jest.fn(),
    },
    workspaceMember: {
      findMany: jest.fn(),
    },
    meetingParticipant: {
      count: jest.fn(),
    },
    forecast: {
      create: jest.fn(),
      findMany: jest.fn(),
    },
    workspace: {
      findUnique: jest.fn(),
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ForecastingService,
        { provide: PrismaService, useValue: mockPrismaService },
      ],
    }).compile();

    service = module.get<ForecastingService>(ForecastingService);
    prisma = module.get<PrismaService>(PrismaService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should calculate delivery completion date successfully', async () => {
    mockPrismaService.task.count.mockResolvedValue(15);
    mockPrismaService.sprint.count.mockResolvedValue(3);

    const result = await service.calculateDeliveryForecast('ws-1', 45);
    expect(result.averageVelocity).toBe(15); // (15 * 3) / 3 = 15
    expect(result.remainingSprints).toBe(3);  // 45 / 15 = 3
    expect(result.estimatedCompletionDate).toBeInstanceOf(Date);
  });

  it('should trigger burnout warning when high priority active tasks exceed 5', async () => {
    mockPrismaService.workspaceMember.findMany.mockResolvedValue([
      { userId: 'user-1', user: { fullName: 'Alex Rivera' } },
    ]);
    mockPrismaService.task.count.mockResolvedValue(6); // 6 active high priority tasks (> 5)
    mockPrismaService.meetingParticipant.count.mockResolvedValue(3);

    const result = await service.calculateBurnoutForecast('ws-1');
    expect(result[0].burnoutWarning).toBe(true);
  });
});
