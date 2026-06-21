import { Module } from '@nestjs/common';
import { HRMSController } from './hrms.controller';
import { HRMSService } from './hrms.service';
import { PrismaModule } from '../prisma/prisma.module';
import { AIModule } from '../ai/ai.module';

@Module({
  imports: [PrismaModule, AIModule],
  controllers: [HRMSController],
  providers: [HRMSService],
  exports: [HRMSService],
})
export class HRMSModule {}
