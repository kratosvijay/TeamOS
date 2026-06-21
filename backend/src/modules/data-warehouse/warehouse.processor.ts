import { Injectable, OnModuleInit, OnModuleDestroy } from '@nestjs/common';
import { Worker, Job } from 'bullmq';
import { WarehouseService } from './warehouse.service';

@Injectable()
export class WarehouseProcessor implements OnModuleInit, OnModuleDestroy {
  private warehouseWorker: Worker;
  private trendWorker: Worker;

  constructor(private warehouseService: WarehouseService) {}

  async onModuleInit() {
    const redisConfig = {
      host: process.env.REDIS_HOST || 'localhost',
      port: parseInt(process.env.REDIS_PORT || '6379'),
    };

    // 1. warehouse-snapshot queue worker
    this.warehouseWorker = new Worker(
      'warehouse-snapshot',
      async (job: Job) => {
        console.log(`Processing warehouse snapshot job: ${job.id}`);
        const { workspaceId } = job.data;
        const result = await this.warehouseService.runETLPipeline(workspaceId);
        console.log(`Successfully completed warehouse-snapshot for workspace ${workspaceId}`);
        return result;
      },
      { connection: redisConfig },
    );

    // 2. trend-analysis queue worker
    this.trendWorker = new Worker(
      'trend-analysis',
      async (job: Job) => {
        console.log(`Processing trend analysis job: ${job.id}`);
        // Simulate trend aggregates calculation
        return { calculated: true, timestamp: new Date() };
      },
      { connection: redisConfig },
    );

    this.warehouseWorker.on('failed', (job, err) => {
      console.error(`Warehouse snapshot job failed: ${job?.id} with error: ${err.message}`);
    });
  }

  async onModuleDestroy() {
    await this.warehouseWorker.close();
    await this.trendWorker.close();
  }
}
