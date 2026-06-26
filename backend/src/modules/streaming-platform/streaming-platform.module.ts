import { Module } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { StreamingPlatformService } from './streaming-platform.service';

@Module({
  providers: [
    PrismaService,
    StreamingPlatformService,
  ],
  exports: [
    StreamingPlatformService,
  ],
})
export class StreamingPlatformModule {}
