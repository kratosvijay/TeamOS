import { Module } from '@nestjs/common';
import { BIService } from './bi.service';
import { BIController } from './bi.controller';
import { PrismaModule } from '../prisma/prisma.module';

@Module({
  imports: [PrismaModule],
  providers: [BIService],
  controllers: [BIController],
  exports: [BIService],
})
export class BusinessIntelligenceModule {}
