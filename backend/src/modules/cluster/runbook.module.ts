import { Module } from '@nestjs/common';
import { RunbookService } from './runbook.service';

@Module({
  providers: [RunbookService],
  exports: [RunbookService],
})
export class RunbookModule {}
