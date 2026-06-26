import { Module } from '@nestjs/common';
import { ProcessMiningService } from './process-mining.service';
import { PrismaModule } from '../prisma/prisma.module';

@Module({
  imports: [PrismaModule],
  providers: [ProcessMiningService],
  exports: [ProcessMiningService],
})
export class ProcessMiningModule {}
