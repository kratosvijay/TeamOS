import { Test, TestingModule } from '@nestjs/testing';
import { ActivityController } from '../activity.controller';
import { PrismaService } from '../../prisma/prisma.service';
import { JwtStrategy } from '../../auth/jwt.strategy';

describe('ActivityController', () => {
  let controller: ActivityController;
  let prisma: PrismaService;

  const mockPrisma = {
    auditTrail: {
      findMany: jest.fn(),
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
      controllers: [ActivityController],
      providers: [
        { provide: PrismaService, useValue: mockPrisma },
        { provide: JwtStrategy, useValue: mockJwtStrategy },
      ],
    }).compile();

    controller = module.get<ActivityController>(ActivityController);
    prisma = module.get<PrismaService>(PrismaService);
  });

  it('should fetch audit logs and format them for the timeline', async () => {
    mockPrisma.auditTrail.findMany.mockResolvedValue([
      {
        id: 'trail-1',
        action: 'TASK_CREATE',
        entityType: 'Task',
        entityId: 'task-101',
        oldValue: null,
        newValue: { title: 'Do task' },
        actor: { id: 'user-1', fullName: 'John Doe', email: 'john@example.com' },
        createdAt: new Date(),
      },
    ]);

    const result = await controller.getTimeline('workspace-1', '10', '0');
    expect(result).toHaveLength(1);
    expect(result[0].id).toBe('trail-1');
    expect(result[0].type).toBe('AUDIT');
    expect(result[0].actor.fullName).toBe('John Doe');
  });
});
