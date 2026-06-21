import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { WorkflowEngine } from './workflow.engine';
import { WorkflowStatus, WorkflowExecutionStatus } from '@prisma/client';

@Injectable()
export class WorkflowService {
  constructor(
    private prisma: PrismaService,
    private engine: WorkflowEngine,
  ) {}

  async createWorkflow(workspaceId: string, createdBy: string, data: { name: string; description?: string; definition: any }) {
    return this.prisma.workflow.create({
      data: {
        workspaceId,
        name: data.name,
        description: data.description,
        status: WorkflowStatus.DRAFT,
        definition: data.definition || {},
        createdBy,
      },
    });
  }

  async getWorkflows(workspaceId: string) {
    return this.prisma.workflow.findMany({
      where: { workspaceId },
      orderBy: { createdAt: 'desc' },
    });
  }

  async getWorkflowById(id: string) {
    const workflow = await this.prisma.workflow.findUnique({
      where: { id },
    });
    if (!workflow) {
      throw new NotFoundException(`Workflow with ID ${id} not found`);
    }
    return workflow;
  }

  async updateWorkflow(id: string, data: { name?: string; description?: string; definition?: any }) {
    await this.getWorkflowById(id);
    return this.prisma.workflow.update({
      where: { id },
      data: {
        name: data.name,
        description: data.description,
        definition: data.definition,
      },
    });
  }

  async deleteWorkflow(id: string) {
    await this.getWorkflowById(id);
    return this.prisma.workflow.delete({
      where: { id },
    });
  }

  async publishWorkflow(id: string) {
    await this.getWorkflowById(id);
    return this.prisma.workflow.update({
      where: { id },
      data: { status: WorkflowStatus.ACTIVE },
    });
  }

  async pauseWorkflow(id: string) {
    await this.getWorkflowById(id);
    return this.prisma.workflow.update({
      where: { id },
      data: { status: WorkflowStatus.PAUSED },
    });
  }

  async runWorkflow(id: string, inputPayload: any) {
    const workflow = await this.getWorkflowById(id);
    const execution = await this.prisma.workflowExecution.create({
      data: {
        workflowId: id,
        status: WorkflowExecutionStatus.RUNNING,
        triggerEvent: 'MANUAL',
        inputData: inputPayload || {},
      },
    });

    // Run execution via the engine asynchronously
    this.engine.execute(execution.id).catch((err) => {
      console.error(`Workflow execution ${execution.id} failed:`, err);
    });

    return execution;
  }

  async getWorkflowExecutions(workflowId: string) {
    return this.prisma.workflowExecution.findMany({
      where: { workflowId },
      include: { logs: true },
      orderBy: { startedAt: 'desc' },
    });
  }
}
