import { Module } from '@nestjs/common';
import { PortfolioService } from './portfolio.service';
import { PortfolioController, ProgramController } from './portfolio.controller';
import { PrismaModule } from '../prisma/prisma.module';

@Module({
  imports: [PrismaModule],
  providers: [PortfolioService],
  controllers: [PortfolioController, ProgramController],
  exports: [PortfolioService],
})
export class PortfolioModule {}
