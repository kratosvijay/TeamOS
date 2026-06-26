import { Injectable, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { AgentState } from '@prisma/client';

@Injectable()
export class AgentLifecycleService {
  constructor(private readonly prisma: PrismaService) {}

  async createAgent(workspaceId: string, name: string, purpose: string, systemPrompt: string) {
    const agent = await this.prisma.aIAgent.create({
      data: { workspaceId, name, purpose, systemPrompt },
    });

    // Create registry entry linked to this agent with DRAFT state
    await this.prisma.agentExecution.create({
      data: {
        agentId: agent.id,
        status: AgentState.DRAFT,
        plan: {},
        steps: {},
      },
    });

    return agent;
  }

  async transitionState(executionId: string, targetState: AgentState): Promise<AgentState> {
    const execution = await this.prisma.agentExecution.findUnique({
      where: { id: executionId },
    });
    if (!execution) throw new BadRequestException(`Execution ID ${executionId} not found.`);

    const validTransitions: Record<AgentState, AgentState[]> = {
      [AgentState.DRAFT]: [AgentState.CONFIGURED, AgentState.ARCHIVED],
      [AgentState.CONFIGURED]: [AgentState.READY, AgentState.DRAFT],
      [AgentState.READY]: [AgentState.RUNNING, AgentState.WAITING_APPROVAL, AgentState.ARCHIVED],
      [AgentState.RUNNING]: [AgentState.WAITING_APPROVAL, AgentState.COMPLETED, AgentState.FAILED, AgentState.PAUSED],
      [AgentState.WAITING_APPROVAL]: [AgentState.RUNNING, AgentState.FAILED, AgentState.PAUSED],
      [AgentState.PAUSED]: [AgentState.RUNNING, AgentState.ARCHIVED],
      [AgentState.COMPLETED]: [AgentState.ARCHIVED],
      [AgentState.FAILED]: [AgentState.RETRYING, AgentState.ARCHIVED],
      [AgentState.RETRYING]: [AgentState.RUNNING, AgentState.FAILED],
      [AgentState.ARCHIVED]: [],
    };

    const allowed = validTransitions[execution.status] || [];
    if (!allowed.includes(targetState)) {
      throw new BadRequestException(`Invalid state transition from ${execution.status} to ${targetState}`);
    }

    const updated = await this.prisma.agentExecution.update({
      where: { id: executionId },
      data: { status: targetState },
    });

    return updated.status;
  }
}
