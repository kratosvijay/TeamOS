import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class RuleEngineService {
  constructor(private prisma: PrismaService) {}

  evaluateExpression(expression: string, context: any): boolean {
    // Simple logic evaluator safely
    try {
      const keys = Object.keys(context);
      const vals = Object.values(context);
      const fn = new Function(...keys, `return ${expression};`);
      return !!fn(...vals);
    } catch {
      return false;
    }
  }

  async checkFieldVisibility(workspaceId: string, entityId: string, fieldName: string, context: any) {
    const rules = await this.prisma.applicationValidationRule.findMany({
      where: { entityId, fieldName, ruleType: 'VISIBILITY' },
    });

    for (const rule of rules) {
      const config = JSON.parse(rule.ruleConfig);
      if (config.expression) {
        const visible = this.evaluateExpression(config.expression, context);
        if (!visible) return false;
      }
    }

    return true;
  }
}
