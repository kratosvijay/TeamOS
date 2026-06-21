import { Module } from '@nestjs/common';
import { CustomDashboardService } from './custom-dashboard.service';
import { CustomDashboardController } from './custom-dashboard.controller';
import { PrismaModule } from '../prisma/prisma.module';

@Module({
  imports: [PrismaModule],
  providers: [CustomDashboardService],
  controllers: [CustomDashboardController],
  exports: [CustomDashboardService],
})
export class CustomDashboardModule {}
