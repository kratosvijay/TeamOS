import { Module } from '@nestjs/common';
import { RetentionService } from './retention.service';
import { RetentionProcessor } from './retention.processor';
import { RetentionController } from './retention.controller';
import { PrismaModule } from '../prisma/prisma.module';

@Module({
  imports: [PrismaModule],
  providers: [RetentionService, RetentionProcessor],
  controllers: [RetentionController],
  exports: [RetentionService, RetentionProcessor],
})
export class RetentionModule {}
