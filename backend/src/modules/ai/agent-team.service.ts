import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

export interface TeamMember {
  agentId: string;
  role: 'COORDINATOR' | 'WORKER' | 'REVIEWER' | 'APPROVER';
}

@Injectable()
export class AgentTeamService {
  private teams = new Map<string, TeamMember[]>();

  constructor(private readonly prisma: PrismaService) {}

  async createTeam(teamId: string, members: TeamMember[]) {
    this.teams.set(teamId, members);
    return { teamId, members };
  }

  async getTeam(teamId: string): Promise<TeamMember[]> {
    return this.teams.get(teamId) || [];
  }

  async runTeamCollaboration(
    teamId: string,
    goal: string,
    executeStepCallback: (agentId: string, input: string) => Promise<string>,
  ) {
    const members = await this.getTeam(teamId);
    if (members.length === 0) {
      throw new Error(`Team ${teamId} not found or has no members.`);
    }

    const coordinator = members.find(m => m.role === 'COORDINATOR');
    const workers = members.filter(m => m.role === 'WORKER');
    const reviewer = members.find(m => m.role === 'REVIEWER');
    const approver = members.find(m => m.role === 'APPROVER');

    let currentInput = goal;
    const logs: any[] = [];

    // 1. Coordinator plans/starts
    if (coordinator) {
      const planOutput = await executeStepCallback(coordinator.agentId, `Coordinate goal: ${currentInput}`);
      logs.push({ agentId: coordinator.agentId, role: 'COORDINATOR', output: planOutput });
      currentInput = planOutput;
    }

    // 2. Workers execute
    for (const worker of workers) {
      const workerOutput = await executeStepCallback(worker.agentId, `Execute task step based on context: ${currentInput}`);
      logs.push({ agentId: worker.agentId, role: 'WORKER', output: workerOutput });
      currentInput = workerOutput;
    }

    // 3. Reviewer checks
    if (reviewer) {
      const reviewOutput = await executeStepCallback(reviewer.agentId, `Review results: ${currentInput}`);
      logs.push({ agentId: reviewer.agentId, role: 'REVIEWER', output: reviewOutput });
      currentInput = reviewOutput;
    }

    // 4. Approver signs off
    if (approver) {
      const approvalOutput = await executeStepCallback(approver.agentId, `Approve outputs: ${currentInput}`);
      logs.push({ agentId: approver.agentId, role: 'APPROVER', output: approvalOutput });
      currentInput = approvalOutput;
    }

    return {
      finalOutput: currentInput,
      collaborationPath: logs,
    };
  }
}
