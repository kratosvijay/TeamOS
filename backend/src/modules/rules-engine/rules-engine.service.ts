import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class RulesEngineService {
  constructor(private prisma: PrismaService) {}

  async createBusinessRule(workspaceId: string, name: string, condition: any, action: any) {
    return this.prisma.businessRule.create({
      data: {
        workspaceId,
        name,
        condition: condition || {},
        action: action || {},
      },
    });
  }

  async getBusinessRules(workspaceId: string) {
    return this.prisma.businessRule.findMany({
      where: { workspaceId },
    });
  }

  /**
   * Evaluates a workflow rule condition against a given facts payload
   */
  evaluateRule(condition: any, facts: any): boolean {
    if (!condition || Object.keys(condition).length === 0) {
      return true;
    }

    const { field, operator, value } = condition;
    if (!field || !operator) return true;

    const factValue = facts[field];
    if (factValue === undefined) return false;

    switch (operator) {
      case '>':
        return Number(factValue) > Number(value);
      case '<':
        return Number(factValue) < Number(value);
      case '>=':
        return Number(factValue) >= Number(value);
      case '<=':
        return Number(factValue) <= Number(value);
      case '==':
      case '===':
        return String(factValue) === String(value);
      case '!=':
      case '!==':
        return String(factValue) !== String(value);
      case 'contains':
        return String(factValue).includes(String(value));
      default:
        return false;
    }
  }

  async evaluateBusinessRule(ruleId: string, facts: any): Promise<boolean> {
    const rule = await this.prisma.businessRule.findUnique({
      where: { id: ruleId },
    });
    if (!rule) return false;
    return this.evaluateRule(rule.condition, facts);
  }
}
