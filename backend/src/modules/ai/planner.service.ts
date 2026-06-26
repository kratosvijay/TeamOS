import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

export interface ExecutionPlanPreview {
  goal: string;
  planSteps: string[];
  estimatedTimeMs: number;
  estimatedCost: number;
  requiredTokens: number;
  requiredSkills: string[];
  approvalNeeded: boolean;
}

@Injectable()
export class PlannerService {
  constructor(private readonly prisma: PrismaService) {}

  async generatePlanPreview(workspaceId: string, goal: string): Promise<ExecutionPlanPreview> {
    const isHighRisk = goal.toLowerCase().includes('payment') || goal.toLowerCase().includes('rollback');
    const estimatedCost = isHighRisk ? 0.85 : 0.12;
    const requiredTokens = isHighRisk ? 12000 : 2500;
    const estimatedTimeMs = isHighRisk ? 5000 : 1200;

    const planSteps = [
      'Analyze request intent and verify authorization scopes.',
      'Query relevant workspace context resources via Semantic Context Builder.',
    ];

    const requiredSkills: string[] = ['context_query'];

    if (goal.toLowerCase().includes('invoice') || goal.toLowerCase().includes('payment')) {
      planSteps.push('Execute sandboxed Invoice OCR skill to extract invoice details.');
      planSteps.push('Verify ERP ledger entries and check account balances.');
      requiredSkills.push('invoice_ocr');
    }

    if (isHighRisk) {
      planSteps.push('Request manual human-in-the-loop (HITL) approval gate execution.');
      planSteps.push('Commit transaction changes and log compliance telemetry.');
    } else {
      planSteps.push('Generate execution outputs and return response payload.');
    }

    return {
      goal,
      planSteps,
      estimatedTimeMs,
      estimatedCost,
      requiredTokens,
      requiredSkills,
      approvalNeeded: isHighRisk,
    };
  }
}
