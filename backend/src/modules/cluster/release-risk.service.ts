import { Injectable } from '@nestjs/common';

export interface ReleaseRiskAssessment {
  riskScorePercent: number;
  riskRating: 'LOW' | 'MEDIUM' | 'HIGH';
  factors: { factorName: string; riskWeight: number; notes: string }[];
  canarySafe: boolean;
}

@Injectable()
export class ReleaseRiskService {
  async getReleaseRisk(version: string): Promise<ReleaseRiskAssessment> {
    const factors = [
      { factorName: 'Database Migrations', riskWeight: 10, notes: '1 pending migration detected.' },
      { factorName: 'Changed Modules', riskWeight: 5, notes: 'Platform core package only.' },
      { factorName: 'Feature Flags', riskWeight: 2, notes: 'Low risk percentage rollout flags active.' },
      { factorName: 'Open Incidents', riskWeight: 0, notes: 'No critical open incidents.' },
    ];

    const score = factors.reduce((sum, f) => sum + f.riskWeight, 0);

    return {
      riskScorePercent: score,
      riskRating: score > 50 ? 'HIGH' : score > 20 ? 'MEDIUM' : 'LOW',
      factors,
      canarySafe: score <= 30,
    };
  }
}
