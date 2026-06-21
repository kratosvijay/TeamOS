import { Injectable, OnModuleInit, OnModuleDestroy } from '@nestjs/common';
import { Worker, Job } from 'bullmq';
import { RetentionService } from './retention.service';

@Injectable()
export class RetentionProcessor implements OnModuleInit, OnModuleDestroy {
  private retentionCleanupWorker: Worker;
  private auditArchiveWorker: Worker;
  private documentExpirationWorker: Worker;

  constructor(private retentionService: RetentionService) {}

  async onModuleInit() {
    const redisConfig = {
      host: process.env.REDIS_HOST || 'localhost',
      port: parseInt(process.env.REDIS_PORT || '6379'),
    };

    // 1. retention-cleanup worker
    this.retentionCleanupWorker = new Worker(
      'retention-cleanup',
      async (job: Job) => {
        console.log(`Processing retention cleanup job: ${job.id}`);
        const { workspaceId } = job.data;
        const result = await this.retentionService.runRetentionCleanup(workspaceId);
        console.log(`Completed retention cleanup for workspace ${workspaceId}:`, result);
        return result;
      },
      { connection: redisConfig },
    );

    // 2. audit-archive worker
    this.auditArchiveWorker = new Worker(
      'audit-archive',
      async (job: Job) => {
        console.log(`Processing audit archive job: ${job.id}`);
        // Simply simulate packaging/archiving older audit logs
        return { archived: true, timestamp: new Date() };
      },
      { connection: redisConfig },
    );

    // 3. document-expiration worker
    this.documentExpirationWorker = new Worker(
      'document-expiration',
      async (job: Job) => {
        console.log(`Processing document expiration job: ${job.id}`);
        // Simply simulate checking document specific expirations
        return { checked: true, timestamp: new Date() };
      },
      { connection: redisConfig },
    );

    this.retentionCleanupWorker.on('failed', (job, err) => {
      console.error(`Retention cleanup job failed: ${job?.id} with error: ${err.message}`);
    });
  }

  async onModuleDestroy() {
    await this.retentionCleanupWorker.close();
    await this.auditArchiveWorker.close();
    await this.documentExpirationWorker.close();
  }
}
