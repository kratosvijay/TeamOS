import { Module } from '@nestjs/common';
import { QueueProcessor } from './queue.processor';
import { AIModule } from '../ai/ai.module';
import { SearchModule } from '../search/search.module';

@Module({
  imports: [AIModule, SearchModule],
  providers: [QueueProcessor],
  exports: [QueueProcessor],
})
export class QueueModule {}
