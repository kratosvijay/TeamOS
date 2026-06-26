import { Module } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CanonicalMappingService } from './canonical-mapping.service';

@Module({
  providers: [
    PrismaService,
    CanonicalMappingService,
  ],
  exports: [
    CanonicalMappingService,
  ],
})
export class CanonicalMappingModule {}
