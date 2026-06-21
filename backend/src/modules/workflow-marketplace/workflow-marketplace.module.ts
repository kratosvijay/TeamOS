import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma/prisma.module';
import { WorkflowMarketplaceService } from './workflow-marketplace.service';
import { WorkflowMarketplaceController } from './workflow-marketplace.controller';

@Module({
  imports: [PrismaModule],
  controllers: [WorkflowMarketplaceController],
  providers: [WorkflowMarketplaceService],
  exports: [WorkflowMarketplaceService],
})
export class WorkflowMarketplaceModule {}
