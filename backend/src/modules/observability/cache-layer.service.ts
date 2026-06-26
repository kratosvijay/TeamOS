import { Injectable } from '@nestjs/common';
import { MetricsService } from './metrics.service';

@Injectable()
export class CacheLayerService {
  private localCache = new Map<string, { value: any; expires: number }>();

  constructor(private readonly metrics: MetricsService) {}

  async get<T>(workspaceId: string, key: string): Promise<T | null> {
    const fullKey = `${workspaceId}:${key}`;
    const cached = this.localCache.get(fullKey);

    if (cached && cached.expires > Date.now()) {
      this.metrics.incrementCacheHit(workspaceId);
      return cached.value as T;
    }

    this.metrics.incrementCacheMiss(workspaceId);
    return null;
  }

  async set<T>(workspaceId: string, key: string, value: T, ttlSeconds = 60): Promise<void> {
    const fullKey = `${workspaceId}:${key}`;
    this.localCache.set(fullKey, {
      value,
      expires: Date.now() + ttlSeconds * 1000,
    });
  }

  async invalidate(workspaceId: string, key: string): Promise<void> {
    const fullKey = `${workspaceId}:${key}`;
    this.localCache.delete(fullKey);
  }

  clearAll() {
    this.localCache.clear();
  }
}
