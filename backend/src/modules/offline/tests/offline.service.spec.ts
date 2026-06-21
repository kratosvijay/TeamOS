import { Test, TestingModule } from '@nestjs/testing';
import { OfflineService, SyncBatch } from '../offline.service';
import { PrismaService } from '../../prisma/prisma.service';
import { SearchService } from '../../search/search.service';

describe('OfflineService', () => {
  let service: OfflineService;
  let prisma: PrismaService;
  let search: SearchService;

  const mockPrisma = {
    syncJournal: {
      findUnique: jest.fn(),
      findFirst: jest.fn(),
      upsert: jest.fn(),
      update: jest.fn(),
    },
    deviceSession: {
      findFirst: jest.fn(),
      upsert: jest.fn(),
    },
    task: {
      create: jest.fn(),
      findUnique: jest.fn(),
      update: jest.fn(),
      delete: jest.fn(),
    },
    document: {
      create: jest.fn(),
      findUnique: jest.fn(),
      update: jest.fn(),
      count: jest.fn(),
    },
    documentContent: {
      create: jest.fn(),
      findFirst: jest.fn(),
      update: jest.fn(),
    },
    workspaceSettings: {
      findUnique: jest.fn(),
      create: jest.fn(),
      update: jest.fn(),
    },
    taskComment: {
      create: jest.fn(),
    },
  };

  const mockSearch = {
    indexEntity: jest.fn(),
    deleteEntity: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        OfflineService,
        { provide: PrismaService, useValue: mockPrisma },
        { provide: SearchService, useValue: mockSearch },
      ],
    }).compile();

    service = module.get<OfflineService>(OfflineService);
    prisma = module.get<PrismaService>(PrismaService);
    search = module.get<SearchService>(SearchService);

    jest.clearAllMocks();
  });

  it('should skip processing if batch is already completed (idempotency)', async () => {
    mockPrisma.syncJournal.findUnique.mockResolvedValue({
      id: 'journal-1',
      status: 'COMPLETED',
    });

    const batch: SyncBatch = {
      batchId: 'batch-1',
      deviceId: 'device-1',
      sequenceNumber: 1,
      mutations: [],
      createdAt: new Date().toISOString(),
    };

    const result = await service.processSyncBatch('user-1', batch);
    expect(result.success).toBe(true);
    expect(result.message).toContain('already processed');
    expect(mockPrisma.syncJournal.upsert).not.toHaveBeenCalled();
  });

  it('should process and log task mutations', async () => {
    mockPrisma.syncJournal.findUnique.mockResolvedValue(null);
    mockPrisma.syncJournal.upsert.mockResolvedValue({ id: 'journal-1' });
    mockPrisma.deviceSession.upsert.mockResolvedValue({});
    mockPrisma.task.findUnique.mockResolvedValue(null);
    mockPrisma.task.create.mockResolvedValue({ id: 'task-1', title: 'Test Task' });

    const batch: SyncBatch = {
      batchId: 'batch-2',
      deviceId: 'device-1',
      sequenceNumber: 2,
      mutations: [
        {
          action: 'CREATE',
          entity: 'Task',
          entityId: 'task-1',
          data: { title: 'Test Task', status: 'TODO', projectId: 'project-1' },
          clientUpdatedAt: new Date().toISOString(),
        },
      ],
      createdAt: new Date().toISOString(),
    };

    const result = await service.processSyncBatch('user-1', batch);
    expect(result.success).toBe(true);
    expect(mockPrisma.task.create).toHaveBeenCalled();
    expect(mockSearch.indexEntity).toHaveBeenCalledWith('tasks', 'task-1', expect.any(Object));
    expect(mockPrisma.syncJournal.update).toHaveBeenCalledWith(
      expect.objectContaining({
        where: { batchId: 'batch-2' },
        data: { status: 'COMPLETED', completedAt: expect.any(Date) },
      }),
    );
  });
});
