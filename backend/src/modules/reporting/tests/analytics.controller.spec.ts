import { Test, TestingModule } from '@nestjs/testing';
import { AnalyticsController } from '../analytics.controller';
import { PrismaService } from '../../prisma/prisma.service';
import { JwtStrategy } from '../../auth/jwt.strategy';

describe('AnalyticsController', () => {
  let controller: AnalyticsController;
  let prisma: PrismaService;

  const mockPrisma = {
    workLog: {
      findMany: jest.fn(),
    },
    meeting: {
      findMany: jest.fn(),
    },
    task: {
      findMany: jest.fn(),
    },
    document: {
      count: jest.fn(),
    },
    workspaceMember: {
      findUnique: jest.fn(),
    },
  };

  const mockJwtStrategy = {
    validateToken: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [AnalyticsController],
      providers: [
        { provide: PrismaService, useValue: mockPrisma },
        { provide: JwtStrategy, useValue: mockJwtStrategy },
      ],
    }).compile();

    controller = module.get<AnalyticsController>(AnalyticsController);
    prisma = module.get<PrismaService>(PrismaService);
  });

  it('should return productivity score aggregates', async () => {
    mockPrisma.workLog.findMany.mockResolvedValue([
      { id: 'w1', hours: 4.5 },
      { id: 'w2', hours: 2.0 },
    ]);

    mockPrisma.meeting.findMany.mockResolvedValue([
      {
        id: 'm1',
        startedAt: new Date('2026-06-21T10:00:00Z'),
        endedAt: new Date('2026-06-21T11:00:00Z'),
      },
    ]);

    mockPrisma.task.findMany.mockResolvedValue([
      { id: 't1', status: 'DONE' },
      { id: 't2', status: 'IN_PROGRESS' },
    ]);

    mockPrisma.document.count.mockResolvedValue(3);

    const result = await controller.getProductivity('workspace-1', { user: { id: 'user-1' } });
    expect(result.focusTimeHours).toBe(6.5);
    expect(result.meetingTimeHours).toBe(1.0);
    expect(result.workspaceHealthScore).toBe(100);
    expect(result.documentationCount).toBe(3);
  });
});
