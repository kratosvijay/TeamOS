import { Module } from '@nestjs/common';
import { DLPService } from './dlp.service';
import { DLPController } from './dlp.controller';
import { PrismaModule } from '../prisma/prisma.module';
import { SecurityModule } from '../security/security.module';

@Module({
  imports: [PrismaModule, SecurityModule],
  providers: [DLPService],
  controllers: [DLPController],
  exports: [DLPService],
})
export class DLPModule {}
