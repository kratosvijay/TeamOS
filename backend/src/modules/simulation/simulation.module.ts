import { Module } from '@nestjs/common';
import { SimulationService } from './simulation.service';
import { PrismaModule } from '../prisma/prisma.module';

@Module({
  imports: [PrismaModule],
  providers: [SimulationService],
  exports: [SimulationService],
})
export class SimulationModule {}
