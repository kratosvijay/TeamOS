import { Module } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { EtlEngineService } from './etl-engine.service';
import { ReverseEtlService } from './reverse-etl.service';

@Module({
  providers: [
    PrismaService,
    EtlEngineService,
    ReverseEtlService,
  ],
  exports: [
    EtlEngineService,
    ReverseEtlService,
  ],
})
export class EtlEngineModule {}
