import { Injectable } from '@nestjs/common';

export interface SpotAnalysis {
  potentialSavingsPercent: number;
  spotEligibleWorkloads: string[];
  spotNodeCount: number;
}

export interface IdleResourceReport {
  name: string;
  type: 'CPU' | 'MEMORY' | 'STORAGE' | 'VM';
  workspaceId: string;
  monthlyWasteCost: number;
  recommendation: string;
}

@Injectable()
export class FinOpsService {
  async getSpotAnalysis(): Promise<SpotAnalysis> {
    return {
      potentialSavingsPercent: 42.5,
      spotEligibleWorkloads: ['teamos-bi-worker', 'teamos-chat-archiver', 'ai-evaluator'],
      spotNodeCount: 4,
    };
  }

  async getIdleResources(): Promise<IdleResourceReport[]> {
    return [
      {
        name: 'teamos-dev-workspace-pv',
        type: 'STORAGE',
        workspaceId: 'ws-dev',
        monthlyWasteCost: 120.0,
        recommendation: 'Delete unused persistent volume of 500GiB.',
      },
      {
        name: 'bi-engine-replica',
        type: 'VM',
        workspaceId: 'ws-bi',
        monthlyWasteCost: 280.0,
        recommendation: 'Scale down CPU core count from 8 to 2 based on <10% utilization history.',
      },
    ];
  }

  async getChargebackReport() {
    return [
      { department: 'Engineering', cost: 2450.00, allocationPercent: 55.4 },
      { department: 'Marketing', cost: 890.00, allocationPercent: 20.1 },
      { department: 'Sales', cost: 1080.00, allocationPercent: 24.5 },
    ];
  }
}
