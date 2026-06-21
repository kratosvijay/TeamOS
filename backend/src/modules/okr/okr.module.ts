import { Module } from '@nestjs/common';
import { OKRService } from './okr.service';
import { OKRController } from './okr.controller';
import { PrismaModule } from '../prisma/prisma.module';

@Module({
  imports: [PrismaModule],
  providers: [OKRService],
  controllers: [OKRController],
  exports: [OKRService],
})
export class OKRModule {}
