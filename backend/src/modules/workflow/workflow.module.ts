import { Module, forwardRef } from '@nestjs/common';
import { PrismaModule } from '../prisma/prisma.module';
import { WorkflowService } from './workflow.service';
import { WorkflowController } from './workflow.controller';
import { WorkflowEngine } from './workflow.engine';
import { WorkflowProcessor } from './workflow.processor';

@Module({
  imports: [forwardRef(() => PrismaModule)],
  controllers: [WorkflowController],
  providers: [WorkflowService, WorkflowEngine, WorkflowProcessor],
  exports: [WorkflowService, WorkflowEngine, WorkflowProcessor],
})
export class WorkflowModule {}
