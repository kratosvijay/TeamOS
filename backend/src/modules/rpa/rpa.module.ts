import { Module } from '@nestjs/common';
import { DesktopAutomationService } from './desktop-automation.service';
import { BrowserAutomationService } from './browser-automation.service';
import { RpaBotService } from './rpa-bot.service';
import { PrismaModule } from '../prisma/prisma.module';

@Module({
  imports: [PrismaModule],
  providers: [DesktopAutomationService, BrowserAutomationService, RpaBotService],
  exports: [DesktopAutomationService, BrowserAutomationService, RpaBotService],
})
export class RpaModule {}