import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

export interface WorkflowStepNode {
  id: string;
  type: 'GOAL' | 'PLANNER' | 'TOOL' | 'MEMORY' | 'LLM' | 'APPROVAL' | 'OUTPUT';
  label: string;
  timestamp: string;
  durationMs: number;
  metadata?: any;
}

export interface WorkflowExecutionGraph {
  executionId: string;
  steps: WorkflowStepNode[];
  edges: { from: string; to: string }[];
}

@Injectable()
export class WorkflowRecorderService {
  constructor(private readonly prisma: PrismaService) {}

  async generateGraph(executionId: string): Promise<WorkflowExecutionGraph> {
    const logs = await this.prisma.aIReasoningLog.findMany({
      where: { executionId },
      orderBy: { stepIndex: 'asc' },
    });

    const steps: WorkflowStepNode[] = [
      {
        id: 'start-goal',
        type: 'GOAL',
        label: 'Initialize Goal Step',
        timestamp: new Date().toISOString(),
        durationMs: 0,
      },
    ];

    const edges: { from: string; to: string }[] = [];
    let previousId = 'start-goal';

    logs.forEach((log, index) => {
      const stepId = `step-${index}`;
      steps.push({
        id: stepId,
        type: log.action.toUpperCase().includes('TOOL') ? 'TOOL' : 'PLANNER',
        label: `Step ${log.stepIndex}: ${log.thought.substring(0, 30)}...`,
        timestamp: log.createdAt.toISOString(),
        durationMs: 250,
        metadata: {
          thought: log.thought,
          action: log.action,
          observation: log.observation,
        },
      });

      edges.push({ from: previousId, to: stepId });
      previousId = stepId;
    });

    steps.push({
      id: 'end-output',
      type: 'OUTPUT',
      label: 'Produce Final Result Output',
      timestamp: new Date().toISOString(),
      durationMs: 0,
    });
    edges.push({ from: previousId, to: 'end-output' });

    return {
      executionId,
      steps,
      edges,
    };
  }

  async saveReasoningLog(executionId: string, stepIndex: number, thought: string, observation: string, action: string) {
    return this.prisma.aIReasoningLog.create({
      data: { executionId, stepIndex, thought, observation, action },
    });
  }
}
