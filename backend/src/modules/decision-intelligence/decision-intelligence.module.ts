import { Module } from '@nestjs/common';
import { DecisionIntelligenceService } from './decision-intelligence.service';
import { PrismaModule } from '../prisma/prisma.module';

@Module({
  imports: [PrismaModule],
  providers: [DecisionIntelligenceService],
  exports: [DecisionIntelligenceService],
})
export class DecisionIntelligenceModule {}
