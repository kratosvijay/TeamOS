import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { AgentTeamService } from './agent-team.service';
import { AgentLifecycleService } from './agent-lifecycle.service';
import { AgentState } from '@prisma/client';

@Injectable()
export class OrchestratorService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly teamService: AgentTeamService,
    private readonly lifecycleService: AgentLifecycleService,
  ) {}

  async runOrchestrationChain(
    workspaceId: string,
    teamId: string,
    goal: string,
    executionId: string,
  ) {
    // 1. Transition agent state to RUNNING
    await this.lifecycleService.transitionState(executionId, AgentState.RUNNING);

    try {
      const collaboration = await this.teamService.runTeamCollaboration(
        teamId,
        goal,
        async (agentId, input) => {
          // Simulation of individual agent step run
          return `Processed: ${input} by agent ${agentId}`;
        },
      );

      // Update execution results in database
      await this.prisma.agentExecution.update({
        where: { id: executionId },
        data: {
          steps: collaboration.collaborationPath,
          completedAt: new Date(),
        },
      });

      // 2. Transition state to COMPLETED
      await this.lifecycleService.transitionState(executionId, AgentState.COMPLETED);

      return {
        status: 'COMPLETED',
        output: collaboration.finalOutput,
        path: collaboration.collaborationPath,
      };
    } catch (e) {
      await this.prisma.agentExecution.update({
        where: { id: executionId },
        data: {
          error: e.message,
          completedAt: new Date(),
        },
      });

      // 2. Transition state to FAILED
      await this.lifecycleService.transitionState(executionId, AgentState.FAILED);

      return {
        status: 'FAILED',
        error: e.message,
      };
    }
  }
}
