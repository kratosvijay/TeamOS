import { Test, TestingModule } from '@nestjs/testing';
import { EventBusService } from '../event-bus.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('EventBusService', () => {
  let service: EventBusService;
  let prisma: PrismaService;

  const mockPrisma = {
    eventSubscription: {
      findMany: jest.fn(),
      create: jest.fn(),
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        EventBusService,
        { provide: PrismaService, useValue: mockPrisma },
      ],
    }).compile();

    service = module.get<EventBusService>(EventBusService);
    prisma = module.get<PrismaService>(PrismaService);
  });

  it('should publish events to subscribers', async () => {
    mockPrisma.eventSubscription.findMany.mockResolvedValue([
      { id: 'sub-1', targetUrl: 'http://localhost/webhook-endpoint', active: true },
    ]);

    const event = await service.publish('TaskCreated', 'ws-1', { taskId: 'task-1' });
    expect(event.name).toBe('TaskCreated');
    expect(service.getHistory('ws-1')).toHaveLength(1);
    expect(service.getDlq()).toHaveLength(0);
  });

  it('should redirect failed deliveries to DLQ', async () => {
    mockPrisma.eventSubscription.findMany.mockResolvedValue([
      { id: 'sub-2', targetUrl: 'http://localhost/fail-endpoint', active: true },
    ]);

    await service.publish('TaskCreated', 'ws-1', { taskId: 'task-2' });
    expect(service.getDlq()).toHaveLength(1);
    expect(service.getDlq()[0].error).toContain('Simulated HTTP connection timeout');
  });

  it('should subscribe and register subscriptions in DB', async () => {
    mockPrisma.eventSubscription.create.mockResolvedValue({ id: 'sub-3' });
    const sub = await service.subscribe('ws-1', 'TaskUpdated', 'http://localhost/callback');
    expect(sub.id).toBe('sub-3');
  });
});
