import { Module } from '@nestjs/common';
import { EventStreamService } from './event-stream.service';
import { EventTopicService } from './event-topic.service';
import { EventConsumerService } from './event-consumer.service';
import { EventPublisherService } from './event-publisher.service';
import { EventReplayService } from './event-replay.service';
import { DeadLetterQueueService } from './dead-letter-queue.service';
import { PrismaModule } from '../prisma/prisma.module';

@Module({
  imports: [PrismaModule],
  providers: [EventStreamService, EventTopicService, EventConsumerService, EventPublisherService, EventReplayService, DeadLetterQueueService],
  exports: [EventStreamService, EventTopicService, EventConsumerService, EventPublisherService, EventReplayService, DeadLetterQueueService],
})
export class EventStreamingModule {}