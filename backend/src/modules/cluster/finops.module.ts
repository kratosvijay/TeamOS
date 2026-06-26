import { Module } from '@nestjs/common';
import { FinOpsService } from './finops.service';
import { BudgetForecastService } from './budget-forecast.service';
import { RightsizingService } from './rightsizing.service';
import { ReservationService } from './reservation.service';

@Module({
  providers: [
    FinOpsService,
    BudgetForecastService,
    RightsizingService,
    ReservationService,
  ],
  exports: [
    FinOpsService,
    BudgetForecastService,
    RightsizingService,
    ReservationService,
  ],
})
export class FinOpsModule {}
