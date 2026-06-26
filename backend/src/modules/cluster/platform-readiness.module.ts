import { Module } from '@nestjs/common';
import { PlatformReadinessService } from './platform-readiness.service';

@Module({
  providers: [PlatformReadinessService],
  exports: [PlatformReadinessService],
})
export class PlatformReadinessModule {}
