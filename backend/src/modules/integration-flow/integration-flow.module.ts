import { Module } from '@nestjs/common';
import { FlowService } from './flow.service';
import { FlowBuilderService } from './flow-builder.service';
import { FlowRuntimeService } from './flow-runtime.service';
import { FlowDebuggerService } from './flow-debugger.service';
import { PrismaModule } from '../prisma/prisma.module';

@Module({
  imports: [PrismaModule],
  providers: [FlowService, FlowBuilderService, FlowRuntimeService, FlowDebuggerService],
  exports: [FlowService, FlowBuilderService, FlowRuntimeService, FlowDebuggerService],
})
export class IntegrationFlowModule {}