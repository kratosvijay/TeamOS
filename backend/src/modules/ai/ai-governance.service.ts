import { Injectable, ForbiddenException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class AIGovernanceService {
  constructor(private readonly prisma: PrismaService) {}

  async enforceLimits(workspaceId: string, requestedCost: number): Promise<boolean> {
    const budget = await this.prisma.aIBudget.findUnique({
      where: { workspaceId },
    });

    if (!budget) return true;

    // Get current usage cost
    const usageLogs = await this.prisma.aIUsageLog.findMany({
      where: { workspaceId },
    });
    const currentSpend = usageLogs.reduce((sum, log) => sum + log.cost, 0);

    if (currentSpend + requestedCost > budget.monthlyLimit) {
      throw new ForbiddenException(`Workspace AI budget limit exceeded. Spend: $${currentSpend.toFixed(2)}, Limit: $${budget.monthlyLimit.toFixed(2)}`);
    }

    return true;
  }

  async runPrivacySafetyCheck(prompt: string): Promise<string> {
    // 1. Redact PII (e.g. social security numbers, emails, passwords)
    let sanitized = prompt;
    sanitized = sanitized.replace(/[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}/g, '[REDACTED_EMAIL]');
    sanitized = sanitized.replace(/\b\d{3}-\d{2}-\d{4}\b/g, '[REDACTED_SSN]');
    return sanitized;
  }

  async createApprovalGate(
    agentId: string,
    actionType: string,
    payload: any,
  ) {
    return this.prisma.aIPendingAction.create({
      data: {
        agentId,
        actionType,
        payload,
        status: 'PENDING',
      },
    });
  }
}
