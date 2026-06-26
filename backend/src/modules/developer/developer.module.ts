import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma/prisma.module';
import { DeveloperController } from './developer.controller';
import { DeveloperService } from './developer.service';

@Module({
  imports: [PrismaModule],
  controllers: [DeveloperController],
  providers: [DeveloperService],
  exports: [DeveloperService],
})
export class DeveloperModule {}
