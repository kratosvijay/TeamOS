import { Test, TestingModule } from '@nestjs/testing';
import { WorkflowService } from '../workflow.service';
import { PrismaService } from '../../prisma/prisma.service';
import { WorkflowEngine } from '../workflow.engine';
import { WorkflowStatus, WorkflowExecutionStatus } from '@prisma/client';

describe('WorkflowService', () => {
  let service: WorkflowService;
  let prisma: PrismaService;

  const mockPrismaService = {
    workflow: {
      create: jest.fn(),
      findMany: jest.fn(),
      findUnique: jest.fn(),
      update: jest.fn(),
      delete: jest.fn(),
    },
    workflowExecution: {
      create: jest.fn(),
      findMany: jest.fn(),
    },
  };

  const mockWorkflowEngine = {
    execute: jest.fn().mockResolvedValue(undefined),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        WorkflowService,
        { provide: PrismaService, useValue: mockPrismaService },
        { provide: WorkflowEngine, useValue: mockWorkflowEngine },
      ],
    }).compile();

    service = module.get<WorkflowService>(WorkflowService);
    prisma = module.get<PrismaService>(PrismaService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should create a workflow in DRAFT status', async () => {
    mockPrismaService.workflow.create.mockResolvedValue({ id: 'w-1', status: WorkflowStatus.DRAFT });

    const result = await service.createWorkflow('ws-1', 'user-1', { name: 'My Flow', definition: {} });
    expect(result.status).toBe(WorkflowStatus.DRAFT);
    expect(mockPrismaService.workflow.create).toHaveBeenCalled();
  });

  it('should publish a workflow', async () => {
    mockPrismaService.workflow.findUnique.mockResolvedValue({ id: 'w-1', status: WorkflowStatus.DRAFT });
    mockPrismaService.workflow.update.mockResolvedValue({ id: 'w-1', status: WorkflowStatus.ACTIVE });

    const result = await service.publishWorkflow('w-1');
    expect(result.status).toBe(WorkflowStatus.ACTIVE);
  });

  it('should pause a workflow', async () => {
    mockPrismaService.workflow.findUnique.mockResolvedValue({ id: 'w-1', status: WorkflowStatus.ACTIVE });
    mockPrismaService.workflow.update.mockResolvedValue({ id: 'w-1', status: WorkflowStatus.PAUSED });

    const result = await service.pauseWorkflow('w-1');
    expect(result.status).toBe(WorkflowStatus.PAUSED);
  });

  it('should run a workflow and spawn execution', async () => {
    mockPrismaService.workflow.findUnique.mockResolvedValue({ id: 'w-1' });
    mockPrismaService.workflowExecution.create.mockResolvedValue({ id: 'ex-1', status: WorkflowExecutionStatus.RUNNING });

    const result = await service.runWorkflow('w-1', { val: 42 });
    expect(result.status).toBe(WorkflowExecutionStatus.RUNNING);
    expect(mockPrismaService.workflowExecution.create).toHaveBeenCalledWith({
      data: {
        workflowId: 'w-1',
        status: WorkflowExecutionStatus.RUNNING,
        triggerEvent: 'MANUAL',
        inputData: { val: 42 },
      },
    });
  });
});
