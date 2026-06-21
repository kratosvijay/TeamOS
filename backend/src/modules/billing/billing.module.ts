import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma/prisma.module';
import { AuthModule } from '../auth/auth.module';
import { NotificationModule } from '../notification/notification.module';
import { BillingController } from './billing.controller';
import { BillingService } from './billing.service';
import { TrialService } from './trial.service';
import { BillingGraceService } from './billing-grace.service';
import { UsageMeterService } from './usage-meter.service';
import { BillingNotificationService } from './billing-notification.service';
import { RevenueAnalyticsService } from './revenue-analytics.service';
import { BillingAnalyticsService } from './billing-analytics.service';
import { BillingLimitGuard } from './guards/billing-limit.guard';

@Module({
  imports: [PrismaModule, AuthModule, NotificationModule],
  controllers: [BillingController],
  providers: [
    BillingService,
    TrialService,
    BillingGraceService,
    UsageMeterService,
    BillingNotificationService,
    RevenueAnalyticsService,
    BillingAnalyticsService,
    BillingLimitGuard,
  ],
  exports: [
    BillingService,
    TrialService,
    BillingGraceService,
    UsageMeterService,
    BillingNotificationService,
    RevenueAnalyticsService,
    BillingAnalyticsService,
    BillingLimitGuard,
  ],
})
export class BillingModule {}
