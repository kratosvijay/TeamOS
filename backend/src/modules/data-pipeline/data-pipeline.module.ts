import { Module } from '@nestjs/common';
import { PipelineService } from './pipeline.service';
import { PipelineTransformService } from './pipeline-transform.service';
import { PipelineMappingService } from './pipeline-mapping.service';
import { PipelineValidationService } from './pipeline-validation.service';
import { PipelineSchedulerService } from './pipeline-scheduler.service';
import { PrismaModule } from '../prisma/prisma.module';

@Module({
  imports: [PrismaModule],
  providers: [PipelineService, PipelineTransformService, PipelineMappingService, PipelineValidationService, PipelineSchedulerService],
  exports: [PipelineService, PipelineTransformService, PipelineMappingService, PipelineValidationService, PipelineSchedulerService],
})
export class DataPipelineModule {}