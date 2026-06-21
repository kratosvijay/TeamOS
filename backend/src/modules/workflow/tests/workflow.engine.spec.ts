import { Test, TestingModule } from '@nestjs/testing';
import { WorkflowEngine } from '../workflow.engine';
import { PrismaService } from '../../prisma/prisma.service';
import { WorkflowExecutionStatus } from '@prisma/client';

describe('WorkflowEngine', () => {
  let engine: WorkflowEngine;
  let prisma: PrismaService;

  const mockPrismaService = {
    workflowExecution: {
      findUnique: jest.fn(),
      update: jest.fn(),
    },
    workflowExecutionLog: {
      create: jest.fn(),
    },
    approvalRequest: {
      create: jest.fn(),
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        WorkflowEngine,
        { provide: PrismaService, useValue: mockPrismaService },
      ],
    }).compile();

    engine = module.get<WorkflowEngine>(WorkflowEngine);
    prisma = module.get<PrismaService>(PrismaService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should run execution and update status to COMPLETED', async () => {
    const mockExecution = {
      id: 'ex-1',
      inputData: { sample: 'data' },
      workflow: {
        definition: {
          nodes: [
            { id: 'n-start', type: 'TRIGGER', name: 'Trigger' },
            { id: 'n-action', type: 'ACTION', name: 'Action Node' },
          ],
          edges: [
            { source: 'n-start', target: 'n-action' },
          ],
        },
      },
    };

    mockPrismaService.workflowExecution.findUnique.mockResolvedValue(mockExecution);
    mockPrismaService.workflowExecution.update.mockResolvedValue({ status: WorkflowExecutionStatus.COMPLETED });

    await engine.execute('ex-1');

    expect(mockPrismaService.workflowExecution.update).toHaveBeenCalledWith({
      where: { id: 'ex-1' },
      data: expect.objectContaining({
        status: WorkflowExecutionStatus.COMPLETED,
      }),
    });
  });

  it('should evaluate conditional nodes true edge routing path', async () => {
    const mockExecution = {
      id: 'ex-2',
      inputData: { checkField: 'valid' },
      workflow: {
        definition: {
          nodes: [
            { id: 'n-start', type: 'TRIGGER', name: 'Trigger' },
            { id: 'n-cond', type: 'CONDITION', name: 'Condition Node' },
            { id: 'n-true', type: 'ACTION', name: 'True Path' },
            { id: 'n-false', type: 'ACTION', name: 'False Path' },
          ],
          edges: [
            { source: 'n-start', target: 'n-cond' },
            { source: 'n-cond', target: 'n-true', sourceHandle: 'true' },
            { source: 'n-cond', target: 'n-false', sourceHandle: 'false' },
          ],
        },
      },
    };

    mockPrismaService.workflowExecution.findUnique.mockResolvedValue(mockExecution);
    await engine.execute('ex-2');

    // Confirm that n-true was logged as executed
    const logCalls = mockPrismaService.workflowExecutionLog.create.mock.calls;
    const completedLog = logCalls.find((call) => call[0].data.nodeId === 'n-true' && call[0].data.status === 'COMPLETED');
    expect(completedLog).toBeDefined();
  });
});
