import { Injectable } from '@nestjs/common';

export interface DigitalTwinState {
  services: { name: string; instances: number; status: 'HEALTHY' | 'DEGRADED' | 'DOWN'; version: string }[];
  databases: { name: string; type: string; connections: number; readReplicaLagMs: number; status: string }[];
  caches: { name: string; memoryUsedBytes: number; hitRatio: number; status: string }[];
  queues: { name: string; activeWorkers: number; waitingJobs: number; failedJobs: number }[];
  aiProviders: { name: string; latencyMs: number; errorRate: number; status: string }[];
  storage: { bucketName: string; spaceUsedBytes: number; status: string }[];
}

@Injectable()
export class DigitalTwinService {
  async getLiveTwinState(): Promise<DigitalTwinState> {
    return {
      services: [
        { name: 'teamos-backend', instances: 3, status: 'HEALTHY', version: 'v1.21.0-rc1' },
        { name: 'teamos-frontend', instances: 2, status: 'HEALTHY', version: 'v1.20.0' },
        { name: 'graphql-gateway', instances: 2, status: 'HEALTHY', version: 'v1.20.0' },
      ],
      databases: [
        { name: 'postgres-primary', type: 'PostgreSQL', connections: 45, readReplicaLagMs: 8, status: 'PRIMARY' },
        { name: 'postgres-read-replica-1', type: 'PostgreSQL', connections: 12, readReplicaLagMs: 14, status: 'REPLICA' },
      ],
      caches: [
        { name: 'redis-cluster', memoryUsedBytes: 429496729, hitRatio: 0.94, status: 'HEALTHY' },
      ],
      queues: [
        { name: 'bullmq-emails-queue', activeWorkers: 5, waitingJobs: 0, failedJobs: 2 },
        { name: 'bullmq-ai-processing', activeWorkers: 10, waitingJobs: 3, failedJobs: 1 },
      ],
      aiProviders: [
        { name: 'OpenAI API Gateway', latencyMs: 380, errorRate: 0.005, status: 'HEALTHY' },
        { name: 'Anthropic Claude Gateway', latencyMs: 410, errorRate: 0.012, status: 'HEALTHY' },
      ],
      storage: [
        { bucketName: 'teamos-enterprise-file-storage', spaceUsedBytes: 1530910122, status: 'HEALTHY' },
      ],
    };
  }
}
