import { Module } from '@nestjs/common';
import { RootCauseAnalysisService } from './root-cause-analysis.service';
import { PrismaModule } from '../prisma/prisma.module';

@Module({
  imports: [PrismaModule],
  providers: [RootCauseAnalysisService],
  exports: [RootCauseAnalysisService],
})
export class RootCauseAnalysisModule {}
