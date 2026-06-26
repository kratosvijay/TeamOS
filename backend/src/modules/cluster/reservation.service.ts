import { Injectable } from '@nestjs/common';

export interface ReservedInstanceSavings {
  serviceName: string;
  provider: 'AWS' | 'GCP' | 'AZURE';
  recommendedPlan: string;
  upfrontCost: number;
  monthlySavings: number;
}

@Injectable()
export class ReservationService {
  async getSavingsPlans(): Promise<ReservedInstanceSavings[]> {
    return [
      { serviceName: 'EC2 Node Group VMs', provider: 'AWS', recommendedPlan: '1-Year Standard Reserved VM Instance', upfrontCost: 0, monthlySavings: 420.00 },
      { serviceName: 'PostgreSQL DB Instance', provider: 'AWS', recommendedPlan: '3-Year No Upfront Reserved DB Instance', upfrontCost: 0, monthlySavings: 280.00 },
    ];
  }
}
