import { Injectable } from '@nestjs/common';

export interface RightsizingRecommendation {
  resourceName: string;
  resourceType: 'DEPLOYMENT' | 'DB_INSTANCE' | 'PV';
  currentSize: string;
  recommendedSize: string;
  savingsMonthly: number;
}

@Injectable()
export class RightsizingService {
  async getRecommendations(): Promise<RightsizingRecommendation[]> {
    return [
      { resourceName: 'teamos-backend', resourceType: 'DEPLOYMENT', currentSize: 'CPU limits: 2.0, Mem: 2Gi', recommendedSize: 'CPU limits: 1.0, Mem: 1Gi', savingsMonthly: 180.0 },
      { resourceName: 'teamos-postgres', resourceType: 'DB_INSTANCE', currentSize: 'db.r6g.xlarge', recommendedSize: 'db.r6g.large', savingsMonthly: 310.0 },
    ];
  }
}
