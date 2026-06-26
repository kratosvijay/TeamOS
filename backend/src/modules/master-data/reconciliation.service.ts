import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class ReconciliationService {
  constructor(private readonly prisma: PrismaService) {}

  async createRule(workspaceId: string, ruleName: string, sourceExpr: string, targetExpr: string, tolerance: number) {
    return this.prisma.reconciliationRule.create({
      data: {
        workspaceId,
        ruleName,
        sourceExpr,
        targetExpr,
        tolerance,
      },
    });
  }

  async runReconciliation(workspaceId: string, ruleId: string, sourceVal: number, targetVal: number) {
    const rule = await this.prisma.reconciliationRule.findUnique({
      where: { id: ruleId },
    });
    if (!rule) throw new Error('Reconciliation rule not found');

    const discrepancy = Math.abs(sourceVal - targetVal);
    const status = discrepancy <= rule.tolerance ? 'PASSED' : 'FAILED';

    return this.prisma.reconciliationRun.create({
      data: {
        workspaceId,
        ruleId,
        status,
        discrepancy,
      },
    });
  }
}
