import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma/prisma.module';
import { SdkService } from './sdk.service';

@Module({
  imports: [PrismaModule],
  providers: [SdkService],
  exports: [SdkService],
})
export class SdkModule {}
