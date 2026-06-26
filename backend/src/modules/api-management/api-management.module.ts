import { Module } from '@nestjs/common';
import { ApiProductService } from './api-product.service';
import { ApiSubscriptionService } from './api-subscription.service';
import { ApiGatewayService } from './api-gateway.service';
import { ApiAnalyticsService } from './api-analytics.service';
import { ApiMockingService } from './api-mocking.service';
import { PrismaModule } from '../prisma/prisma.module';

@Module({
  imports: [PrismaModule],
  providers: [ApiProductService, ApiSubscriptionService, ApiGatewayService, ApiAnalyticsService, ApiMockingService],
  exports: [ApiProductService, ApiSubscriptionService, ApiGatewayService, ApiAnalyticsService, ApiMockingService],
})
export class ApiManagementModule {}