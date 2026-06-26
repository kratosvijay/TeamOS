import { Module } from '@nestjs/common';
import { ExecutiveIntelligenceService } from './executive-intelligence.service';
import { PrismaModule } from '../prisma/prisma.module';

@Module({
  imports: [PrismaModule],
  providers: [ExecutiveIntelligenceService],
  exports: [ExecutiveIntelligenceService],
})
export class ExecutiveIntelligenceModule {}
