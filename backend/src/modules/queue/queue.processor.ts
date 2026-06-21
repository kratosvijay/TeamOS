import { Injectable, OnModuleInit, OnModuleDestroy } from '@nestjs/common';
import { Worker, Job } from 'bullmq';
import { PrismaService } from '../prisma/prisma.service';
import { AIService } from '../ai/ai.service';
import { SearchService } from '../search/search.service';

@Injectable()
export class QueueProcessor implements OnModuleInit, OnModuleDestroy {
  private aiWorker: Worker;
  private searchWorker: Worker;

  constructor(
    private prisma: PrismaService,
    private aiService: AIService,
    private searchService: SearchService,
  ) {}

  async onModuleInit() {
    const redisConfig = {
      host: process.env.REDIS_HOST || 'localhost',
      port: parseInt(process.env.REDIS_PORT || '6379'),
    };

    // AI summary generation queue processor
    this.aiWorker = new Worker(
      'ai-tasks',
      async (job: Job) => {
        console.log(`Processing AI job: ${job.name} (ID: ${job.id})`);
        
        if (job.name === 'meeting:summary') {
          const { meetingId, transcript } = job.data;
          const summary = await this.aiService.generateSummary(transcript);
          
          await this.prisma.meetingSummary.create({
            data: {
              meetingId,
              summary,
              keyPoints: ['Sprint boundaries', 'Architectural designs', 'LiveKit/Yjs setup'],
            },
          });
          
          console.log(`Successfully completed meeting:summary for meeting ${meetingId}`);
        }
      },
      { connection: redisConfig },
    );

    // Search indexing queue processor
    this.searchWorker = new Worker(
      'search-indexing',
      async (job: Job) => {
        console.log(`Processing search indexing job: ${job.name} (ID: ${job.id})`);
        
        const { entityType, entityId, payload } = job.data;
        if (job.name === 'search:delete') {
          await this.searchService.deleteEntity(entityType, entityId);
          console.log(`Deleted entity of type ${entityType} (ID: ${entityId}) from search index successfully.`);
        } else {
          await this.searchService.indexEntity(entityType, entityId, payload);
          console.log(`Indexed entity of type ${entityType} (ID: ${entityId}) successfully.`);
        }
      },
      { connection: redisConfig },
    );

    this.aiWorker.on('failed', (job, err) => {
      console.error(`AI job failed: ${job.id} with error: ${err.message}`);
    });

    this.searchWorker.on('failed', (job, err) => {
      console.error(`Search indexing job failed: ${job.id} with error: ${err.message}`);
    });
  }

  async onModuleDestroy() {
    await this.aiWorker.close();
    await this.searchWorker.close();
  }
}
