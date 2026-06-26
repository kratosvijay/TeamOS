import { Injectable } from '@nestjs/common';

export interface BudgetForecast {
  currentSpend: number;
  projectedSpend: number;
  thresholdAlerts: { budgetName: string; limit: number; projected: number; isViolated: boolean }[];
}

@Injectable()
export class BudgetForecastService {
  async getBudgetForecasts(): Promise<BudgetForecast> {
    return {
      currentSpend: 4420.00,
      projectedSpend: 4890.00,
      thresholdAlerts: [
        { budgetName: 'Global AWS Infrastructure', limit: 5000.0, projected: 4890.0, isViolated: false },
        { budgetName: 'AI Tokens Token Allotment', limit: 800.0, projected: 920.0, isViolated: true },
      ],
    };
  }
}
