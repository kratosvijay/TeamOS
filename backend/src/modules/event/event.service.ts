import { Injectable } from '@nestjs/common';
import { Queue } from 'bullmq';

@Injectable()
export class EventService {
  private queues: Map<string, Queue> = new Map();

  constructor() {
    const redisHost = process.env.REDIS_HOST || 'localhost';
    const redisPort = parseInt(process.env.REDIS_PORT || '6379');
    
    // Dedicated Queues setup
    const queueNames = [
      'project-provisioning',
      'notifications',
      'search-indexing',
      'ai-processing',
      'document-sync',
      'meeting-processing',
    ];

    for (const name of queueNames) {
      this.queues.set(
        name,
        new Queue(name, {
          connection: { host: redisHost, port: redisPort },
        }),
      );
    }
  }

  async dispatch(queueName: string, jobName: string, data: any, options?: any) {
    const queue = this.queues.get(queueName);
    if (!queue) {
      throw new Error(`Queue ${queueName} not configured`);
    }

    return queue.add(jobName, data, {
      attempts: 3,
      backoff: { type: 'exponential', delay: 5000 },
      ...options,
    });
  }
}
