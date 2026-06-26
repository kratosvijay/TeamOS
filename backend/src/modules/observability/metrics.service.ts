import { Injectable } from '@nestjs/common';

@Injectable()
export class MetricsService {
  private metricsStore = new Map<string, any>();

  incrementHttpRequests(workspaceId: string, path: string, status: number) {
    const key = `http:${workspaceId}:${path}:${status}`;
    const current = this.metricsStore.get(key) || 0;
    this.metricsStore.set(key, current + 1);
  }

  incrementGraphqlQueries(workspaceId: string, resolver: string) {
    const key = `graphql:${workspaceId}:${resolver}`;
    const current = this.metricsStore.get(key) || 0;
    this.metricsStore.set(key, current + 1);
  }

  recordDatabaseLatency(workspaceId: string, query: string, durationMs: number) {
    const key = `db_latency:${workspaceId}:${query}`;
    this.metricsStore.set(key, durationMs);
  }

  incrementCacheHit(workspaceId: string) {
    const key = `cache_hit:${workspaceId}`;
    const current = this.metricsStore.get(key) || 0;
    this.metricsStore.set(key, current + 1);
  }

  incrementCacheMiss(workspaceId: string) {
    const key = `cache_miss:${workspaceId}`;
    const current = this.metricsStore.get(key) || 0;
    this.metricsStore.set(key, current + 1);
  }

  recordAiTokenUsage(workspaceId: string, tokens: number) {
    const key = `ai_tokens:${workspaceId}`;
    const current = this.metricsStore.get(key) || 0;
    this.metricsStore.set(key, current + tokens);
  }

  getMetricsDump() {
    const lines: string[] = [];
    this.metricsStore.forEach((value, key) => {
      lines.push(`${key} ${value}`);
    });
    return lines.join('\n');
  }

  getCacheHitRatio(workspaceId: string): number {
    const hits = this.metricsStore.get(`cache_hit:${workspaceId}`) || 0;
    const misses = this.metricsStore.get(`cache_miss:${workspaceId}`) || 0;
    const total = hits + misses;
    return total === 0 ? 1.0 : hits / total;
  }
}
