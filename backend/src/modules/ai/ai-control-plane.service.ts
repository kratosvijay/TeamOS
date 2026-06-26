import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { AgentLifecycleService } from './agent-lifecycle.service';
import { ModelRegistryService } from './model-registry.service';
import { AIPolicyService } from './ai-policy.service';
import { AIGovernanceService } from './ai-governance.service';
import { AgentState } from '@prisma/client';

@Injectable()
export class AIControlPlaneService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly lifecycleService: AgentLifecycleService,
    private readonly modelRegistry: ModelRegistryService,
    private readonly policyService: AIPolicyService,
    private readonly governanceService: AIGovernanceService,
  ) {}

  async coordinateExecutionRequest(
    workspaceId: string,
    userId: string,
    agentId: string,
    goal: string,
    actionType: string,
  ): Promise<any> {
    // 1. Policy enforcement Check
    await this.policyService.checkPermission(workspaceId, userId, agentId, actionType);

    // 2. Budget limits enforcement
    const route = await this.modelRegistry.getRouteForTask('general');
    await this.governanceService.enforceLimits(workspaceId, route.costPerThousandTokens * 3);

    // 3. Create execution and set state transition
    const agentExecution = await this.prisma.agentExecution.create({
      data: {
        agentId,
        status: AgentState.READY,
        plan: {},
        steps: {},
      },
    });

    // 4. Check if high-risk HITL approval required
    const isHighRisk = actionType === 'DEPLOY' || goal.toLowerCase().includes('payment');
    if (isHighRisk) {
      await this.lifecycleService.transitionState(agentExecution.id, AgentState.WAITING_APPROVAL);
      const approvalGate = await this.governanceService.createApprovalGate(agentId, actionType, {
        executionId: agentExecution.id,
        goal,
      });

      return {
        status: 'WAITING_APPROVAL',
        executionId: agentExecution.id,
        approvalId: approvalGate.id,
        message: 'High-risk action detected. Human-in-the-loop approval gate triggered.',
      };
    }

    return {
      status: 'READY',
      executionId: agentExecution.id,
      message: 'Execution request coordinates verified. Ready for runtime loops.',
    };
  }
}
