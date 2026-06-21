import { Test, TestingModule } from '@nestjs/testing';
import { UsageMeterService } from '../usage-meter.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('UsageMeterService', () => {
  let service: UsageMeterService;
  let prisma: PrismaService;

  const mockPrisma = {
    workspace: {
      update: jest.fn(),
      findMany: jest.fn().mockResolvedValue([{ id: 'ws-123', aiTokensUsed: 100, storageBytesUsed: BigInt(500) }]),
    },
    workspaceSeat: {
      count: jest.fn().mockResolvedValue(2),
    },
    project: {
      count: jest.fn().mockResolvedValue(4),
    },
    document: {
      count: jest.fn().mockResolvedValue(3),
    },
    meeting: {
      count: jest.fn().mockResolvedValue(1),
    },
    usageSnapshot: {
      create: jest.fn(),
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        UsageMeterService,
        { provide: PrismaService, useValue: mockPrisma },
      ],
    }).compile();

    service = module.get<UsageMeterService>(UsageMeterService);
    prisma = module.get<PrismaService>(PrismaService);
  });

  it('should increment AI tokens used count', async () => {
    await service.incrementAITokens('ws-123', 500);
    expect(mockPrisma.workspace.update).toHaveBeenCalledWith({
      where: { id: 'ws-123' },
      data: { aiTokensUsed: { increment: 500 } },
    });
  });

  it('should create hourly snapshots for workspaces', async () => {
    await service.createHourlySnapshots();
    expect(mockPrisma.usageSnapshot.create).toHaveBeenCalledWith({
      data: {
        workspaceId: 'ws-123',
        usersCount: 2,
        projectsCount: 4,
        storageBytes: BigInt(500),
        aiTokens: 100,
        meetingMinutes: 45,
      },
    });
  });
});
