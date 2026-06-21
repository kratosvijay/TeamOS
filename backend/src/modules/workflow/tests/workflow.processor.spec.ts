import { Test, TestingModule } from '@nestjs/testing';
import { WorkflowProcessor } from '../workflow.processor';
import { WorkflowEngine } from '../workflow.engine';
import { PrismaService } from '../../prisma/prisma.service';

describe('WorkflowProcessor', () => {
  let processor: WorkflowProcessor;
  let engine: WorkflowEngine;

  const mockWorkflowEngine = {
    execute: jest.fn().mockResolvedValue(undefined),
  };

  const mockPrismaService = {
    sLAConfiguration: {
      findFirst: jest.fn(),
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        WorkflowProcessor,
        { provide: WorkflowEngine, useValue: mockWorkflowEngine },
        { provide: PrismaService, useValue: mockPrismaService },
      ],
    }).compile();

    processor = module.get<WorkflowProcessor>(WorkflowProcessor);
    engine = module.get<WorkflowEngine>(WorkflowEngine);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should instantiate and compile queues', async () => {
    expect(processor).toBeDefined();
  });

  it('should process workflow execution job', async () => {
    const job: any = {
      id: 'job-1',
      data: { executionId: 'ex-1' },
    };

    const result = await (processor as any).handleJob('workflow-execution', job);
    expect(result.executed).toBe(true);
    expect(engine.execute).toHaveBeenCalledWith('ex-1');
  });

  it('should process timers and check SLA targets', async () => {
    const timerJob: any = {
      id: 'job-2',
      data: { executionId: 'ex-1' },
    };
    const slaJob: any = {
      id: 'job-3',
      data: { workflowId: 'w-1', workspaceId: 'ws-1' },
    };

    mockPrismaService.sLAConfiguration.findFirst.mockResolvedValue({ id: 'sla-1', name: 'Critical SLA' });

    const timerResult = await (processor as any).handleJob('workflow-timers', timerJob);
    const slaResult = await (processor as any).handleJob('workflow-sla-monitor', slaJob);

    expect(timerResult.timerCompleted).toBe(true);
    expect(slaResult.slaMonitored).toBe(true);
  });
});
