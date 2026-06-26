import { Module } from '@nestjs/common';
import { SyncEngineService } from './sync-engine.service';
import { SyncConflictService } from './sync-conflict.service';
import { SyncMergeService } from './sync-merge.service';
import { PrismaModule } from '../prisma/prisma.module';

@Module({
  imports: [PrismaModule],
  providers: [SyncEngineService, SyncConflictService, SyncMergeService],
  exports: [SyncEngineService, SyncConflictService, SyncMergeService],
})
export class SyncEngineModule {}