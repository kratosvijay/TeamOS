import { Module } from '@nestjs/common';
import { ResourcePlanningService } from './resource-planning.service';
import { ResourcePlanningController } from './resource-planning.controller';
import { PrismaModule } from '../prisma/prisma.module';

@Module({
  imports: [PrismaModule],
  providers: [ResourcePlanningService],
  controllers: [ResourcePlanningController],
  exports: [ResourcePlanningService],
})
export class ResourcePlanningModule {}
