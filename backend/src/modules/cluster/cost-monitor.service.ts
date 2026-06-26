import { Injectable } from '@nestjs/common';

@Injectable()
export class CostMonitorService {
  async getCloudSpend() {
    return {
      monthlyTotal: 4250.0,
      forecastedTotal: 4620.0,
      breakdown: {
        kubernetes: 2100.0,
        database: 950.0,
        storage: 400.0,
        gpus: 800.0,
      },
    };
  }

  async getCapacityForecast() {
    return {
      cpuSaturationDate: '2026-10-15',
      memorySaturationDate: '2026-11-20',
      storageSaturationDate: '2027-02-05',
      gpuUtilizationPercent: 42.5,
      recommendations: [
        'Scale down teamos-backend replica requests in GKE during off-peak hours.',
        'Resize test workspaces storage volume size limits to reclaim 120GiB.',
      ],
    };
  }

  async getWorkspaceCostAllocation() {
    return [
      { workspaceId: 'ws-marketing', allocationPercent: 15.0, cost: 637.5 },
      { workspaceId: 'ws-engineering', allocationPercent: 65.0, cost: 2762.5 },
      { workspaceId: 'ws-sales', allocationPercent: 20.0, cost: 850.0 },
    ];
  }
}
