import { Injectable } from '@nestjs/common';

export interface ResourceForecast {
  resourceName: string;
  currentUsagePercent: number;
  exhaustionDate: string; // e.g. '2026-10-15'
  status: 'STABLE' | 'WARNING' | 'CRITICAL';
}

@Injectable()
export class CapacityPlannerService {
  async getExhaustionForecasts(): Promise<ResourceForecast[]> {
    return [
      { resourceName: 'GKE Cluster CPU Cores pool', currentUsagePercent: 68.0, exhaustionDate: '2026-10-15', status: 'WARNING' },
      { resourceName: 'PostgreSQL RDS primary disk space', currentUsagePercent: 82.5, exhaustionDate: '2026-08-30', status: 'CRITICAL' },
      { resourceName: 'Redis memory allocation', currentUsagePercent: 42.0, exhaustionDate: '2027-02-10', status: 'STABLE' },
      { resourceName: 'OpenSearch index volume size', currentUsagePercent: 71.2, exhaustionDate: '2026-11-05', status: 'WARNING' },
    ];
  }

  async getAiTokenMonthlyForecast(): Promise<{ currentMonthTokens: number; projectedMonthTokens: number; estimatedCostUSD: number }> {
    return {
      currentMonthTokens: 25000000,
      projectedMonthTokens: 31000000,
      estimatedCostUSD: 620.00,
    };
  }
}
