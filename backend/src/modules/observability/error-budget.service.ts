import { Injectable } from '@nestjs/common';

export interface ErrorBudgetStatus {
  workspaceId: string;
  targetAvailability: number; // e.g., 99.9
  currentAvailability: number;
  remainingBudgetPercent: number;
  isExhausted: boolean;
}

@Injectable()
export class ErrorBudgetService {
  private budgets = new Map<string, { target: number; requests: number; errors: number }>();

  getBudgetStatus(workspaceId: string): ErrorBudgetStatus {
    const data = this.budgets.get(workspaceId) || { target: 99.9, requests: 1000, errors: 0 };
    const currentAvailability = data.requests === 0 ? 100 : ((data.requests - data.errors) / data.requests) * 100;
    
    // Remaining budget: Allowed errors ratio vs actual errors ratio
    // Target availability of 99.9% means 0.1% errors allowed.
    const allowedErrorRatio = (100 - data.target) / 100;
    const actualErrorRatio = data.requests === 0 ? 0 : data.errors / data.requests;
    const remainingBudgetPercent = allowedErrorRatio === 0 ? 0 : Math.max(0, ((allowedErrorRatio - actualErrorRatio) / allowedErrorRatio) * 100);

    return {
      workspaceId,
      targetAvailability: data.target,
      currentAvailability: parseFloat(currentAvailability.toFixed(4)),
      remainingBudgetPercent: parseFloat(remainingBudgetPercent.toFixed(2)),
      isExhausted: actualErrorRatio >= allowedErrorRatio,
    };
  }

  recordRequest(workspaceId: string, isError: boolean) {
    const data = this.budgets.get(workspaceId) || { target: 99.9, requests: 0, errors: 0 };
    data.requests++;
    if (isError) {
      data.errors++;
    }
    this.budgets.set(workspaceId, data);
  }

  setTargetAvailability(workspaceId: string, target: number) {
    const data = this.budgets.get(workspaceId) || { target: 99.9, requests: 0, errors: 0 };
    data.target = target;
    this.budgets.set(workspaceId, data);
  }
}
