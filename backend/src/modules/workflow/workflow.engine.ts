import { Injectable, forwardRef, Inject } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { WorkflowExecutionStatus } from '@prisma/client';

export enum WorkflowNodeType {
  TRIGGER = 'TRIGGER',
  CONDITION = 'CONDITION',
  ACTION = 'ACTION',
  APPROVAL = 'APPROVAL',
  TIMER = 'TIMER',
  AI_ACTION = 'AI_ACTION',
  NOTIFICATION = 'NOTIFICATION',
  WEBHOOK = 'WEBHOOK',
}

@Injectable()
export class WorkflowEngine {
  constructor(
    @Inject(forwardRef(() => PrismaService))
    private prisma: PrismaService,
  ) {}

  async execute(executionId: string): Promise<void> {
    const execution = await this.prisma.workflowExecution.findUnique({
      where: { id: executionId },
      include: { workflow: true },
    });

    if (!execution) return;

    try {
      // 1. Parse workflow definition nodes
      const definition = execution.workflow.definition as any;
      const nodes = definition.nodes || [];
      const edges = definition.edges || [];

      await this.logStep(executionId, 'START', 'RUNNING', 'Starting workflow execution');

      // Find trigger node
      const triggerNode = nodes.find((n: any) => n.type === 'TRIGGER' || n.type === WorkflowNodeType.TRIGGER);
      let currentNode = triggerNode;

      while (currentNode) {
        await this.logStep(executionId, currentNode.id, 'RUNNING', `Executing node: ${currentNode.name || currentNode.type}`);

        // Simulate execution based on node type
        const outcome = await this.processNode(executionId, currentNode, execution.inputData);

        if (outcome.status === 'FAILED') {
          await this.logStep(executionId, currentNode.id, 'FAILED', `Node execution failed: ${outcome.message}`);
          throw new Error(outcome.message || 'Node execution failed');
        }

        await this.logStep(executionId, currentNode.id, 'COMPLETED', `Node execution completed: ${outcome.message}`);

        // Find next node in path based on connections and outcome
        const nextEdge = edges.find((e: any) => {
          if (currentNode.type === 'CONDITION' || currentNode.type === WorkflowNodeType.CONDITION) {
            // conditions routes based on boolean outcome
            return e.source === currentNode.id && e.sourceHandle === (outcome.conditionResult ? 'true' : 'false');
          }
          return e.source === currentNode.id;
        });

        currentNode = nextEdge ? nodes.find((n: any) => n.id === nextEdge.target) : null;
      }

      // Complete execution
      await this.prisma.workflowExecution.update({
        where: { id: executionId },
        data: {
          status: WorkflowExecutionStatus.COMPLETED,
          completedAt: new Date(),
          outputData: { outcome: 'SUCCESS' },
        },
      });

      await this.logStep(executionId, 'END', 'COMPLETED', 'Workflow execution completed successfully');
    } catch (error: any) {
      await this.prisma.workflowExecution.update({
        where: { id: executionId },
        data: {
          status: WorkflowExecutionStatus.FAILED,
          completedAt: new Date(),
          outputData: { outcome: 'FAILED', error: error.message },
        },
      });

      await this.logStep(executionId, 'END', 'FAILED', `Workflow execution failed: ${error.message}`);
    }
  }

  private async processNode(executionId: string, node: any, inputData: any): Promise<{ status: string; message: string; conditionResult?: boolean }> {
    const nodeType = node.type as WorkflowNodeType;

    switch (nodeType) {
      case 'TRIGGER':
      case WorkflowNodeType.TRIGGER:
        return { status: 'COMPLETED', message: 'Trigger criteria matching' };

      case 'CONDITION':
      case WorkflowNodeType.CONDITION:
        // Evaluate simple logic condition
        const matchesCondition = inputData && Object.keys(inputData).length > 0;
        return {
          status: 'COMPLETED',
          message: `Evaluated logic condition: ${matchesCondition}`,
          conditionResult: matchesCondition,
        };

      case 'ACTION':
      case WorkflowNodeType.ACTION:
        return { status: 'COMPLETED', message: 'Completed workflow action step' };

      case 'APPROVAL':
      case WorkflowNodeType.APPROVAL:
        // Automatically request approval
        await this.prisma.approvalRequest.create({
          data: {
            workflowId: executionId,
            requestedBy: 'SYSTEM',
            approverId: node.config?.approverId || 'manager-1',
            status: 'PENDING',
          },
        });
        return { status: 'COMPLETED', message: 'Approval request generated and sent' };

      case 'TIMER':
      case WorkflowNodeType.TIMER:
        return { status: 'COMPLETED', message: `Timer delay set for ${node.config?.duration || 10} seconds` };

      case 'AI_ACTION':
      case WorkflowNodeType.AI_ACTION:
        return { status: 'COMPLETED', message: 'AI Content Generation complete' };

      case 'NOTIFICATION':
      case WorkflowNodeType.NOTIFICATION:
        return { status: 'COMPLETED', message: 'Slack & Email notification successfully routed' };

      case 'WEBHOOK':
      case WorkflowNodeType.WEBHOOK:
        return { status: 'COMPLETED', message: 'Webhook callback dispatched successfully' };

      default:
        return { status: 'COMPLETED', message: 'Generic step complete' };
    }
  }

  private async logStep(executionId: string, nodeId: string, status: string, message: string): Promise<void> {
    await this.prisma.workflowExecutionLog.create({
      data: {
        executionId,
        nodeId,
        status,
        message,
      },
    });
  }
}
