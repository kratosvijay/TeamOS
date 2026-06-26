import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma/prisma.module';
import { BackupService } from './backup.service';
import { DisasterRecoveryService } from './disaster-recovery.service';
import { DrDrillsService } from './dr-drills.service';

@Module({
  imports: [PrismaModule],
  providers: [BackupService, DisasterRecoveryService, DrDrillsService],
  exports: [BackupService, DisasterRecoveryService, DrDrillsService],
})
export class BackupModule {}
