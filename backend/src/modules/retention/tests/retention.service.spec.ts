import { Test, TestingModule } from '@nestjs/testing';
import { RetentionService } from '../retention.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('RetentionService', () => {
  let service: RetentionService;
  let prisma: PrismaService;

  const mockPrismaService = {
    retentionPolicy: {
      findFirst: jest.fn(),
      update: jest.fn(),
      create: jest.fn(),
      findMany: jest.fn(),
    },
    legalHold: {
      findFirst: jest.fn(),
      update: jest.fn(),
      create: jest.fn(),
      findMany: jest.fn(),
    },
    message: {
      deleteMany: jest.fn(),
    },
    meeting: {
      deleteMany: jest.fn(),
    },
    document: {
      deleteMany: jest.fn(),
    },
    auditTrail: {
      deleteMany: jest.fn(),
    },
    aIConversation: {
      deleteMany: jest.fn(),
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        RetentionService,
        { provide: PrismaService, useValue: mockPrismaService },
      ],
    }).compile();

    service = module.get<RetentionService>(RetentionService);
    prisma = module.get<PrismaService>(PrismaService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should skip cleanup if active Legal Hold exists', async () => {
    mockPrismaService.legalHold.findFirst.mockResolvedValue({ id: 'hold-1', active: true });

    const result = await service.runRetentionCleanup('ws-1');
    expect(result.skipped).toBe(true);
    expect(result.reason).toBe('Legal Hold Active');
    expect(mockPrismaService.message.deleteMany).not.toHaveBeenCalled();
  });

  it('should execute cleanup when no active Legal Hold exists', async () => {
    mockPrismaService.legalHold.findFirst.mockResolvedValue(null); // No active hold
    mockPrismaService.retentionPolicy.findMany.mockResolvedValue([
      { targetType: 'Messages', retentionDays: 30 },
    ]);
    mockPrismaService.message.deleteMany.mockResolvedValue({ count: 10 });

    const result = await service.runRetentionCleanup('ws-1');
    expect(result.skipped).toBe(false);
    expect(result.results['Messages']).toBe(10);
    expect(mockPrismaService.message.deleteMany).toHaveBeenCalled();
  });
});
