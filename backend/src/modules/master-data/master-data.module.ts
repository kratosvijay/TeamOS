import { Module } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { MasterDataService } from './master-data.service';
import { ReconciliationService } from './reconciliation.service';

@Module({
  providers: [PrismaService, MasterDataService, ReconciliationService],
  exports: [MasterDataService, ReconciliationService],
})
export class MasterDataModule {}
