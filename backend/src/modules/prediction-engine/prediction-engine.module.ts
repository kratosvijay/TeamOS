import { Module } from '@nestjs/common';
import { PredictionEngineService } from './prediction-engine.service';
import { PrismaModule } from '../prisma/prisma.module';

@Module({
  imports: [PrismaModule],
  providers: [PredictionEngineService],
  exports: [PredictionEngineService],
})
export class PredictionEngineModule {}
