import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class DataQualityEngineService {
  constructor(private readonly prisma: PrismaService) {}

  async createRule(workspaceId: string, name: string, ruleType: string, paramsJson: string) {
    return this.prisma.dataQualityRule.create({
      data: {
        workspaceId,
        name,
        ruleType,
        paramsJson,
      },
    });
  }

  async runValidation(workspaceId: string, ruleId: string, records: any[]) {
    const rule = await this.prisma.dataQualityRule.findUnique({
      where: { id: ruleId },
    });
    if (!rule) throw new Error('Data quality rule not found');

    let passedCount = 0;
    let failedCount = 0;

    for (const record of records) {
      if (rule.ruleType === 'NOT_NULL') {
        const field = JSON.parse(rule.paramsJson).field;
        if (record[field] !== null && record[field] !== undefined && record[field] !== '') {
          passedCount++;
        } else {
          failedCount++;
        }
      } else if (rule.ruleType === 'EMAIL_FORMAT') {
        const field = JSON.parse(rule.paramsJson).field;
        const email = record[field];
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (email && emailRegex.test(email)) {
          passedCount++;
        } else {
          failedCount++;
        }
      } else {
        passedCount++; // default passed for other mocked rules
      }
    }

    return this.prisma.dataQualityResult.create({
      data: {
        workspaceId,
        ruleId,
        passedCount,
        failedCount,
      },
    });
  }
}
