import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma/prisma.module';
import { RulesEngineService } from './rules-engine.service';

@Module({
  imports: [PrismaModule],
  providers: [RulesEngineService],
  exports: [RulesEngineService],
})
export class RulesEngineModule {}
