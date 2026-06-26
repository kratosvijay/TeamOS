import { Injectable, HttpException, HttpStatus } from '@nestjs/common';

@Injectable()
export class RateLimitService {
  private throttles = new Map<string, { count: number; reset: number }>();

  async checkLimit(key: string, limit: number, windowMs = 60000) {
    const now = Date.now();
    const current = this.throttles.get(key);

    if (!current || now > current.reset) {
      this.throttles.set(key, { count: 1, reset: now + windowMs });
      return;
    }

    if (current.count >= limit) {
      throw new HttpException('Too Many Requests: rate limit exceeded', HttpStatus.TOO_MANY_REQUESTS);
    }

    current.count++;
    this.throttles.set(key, current);
  }

  async throttleRequest(workspaceId: string, userId: string, apiKey: string, ip: string) {
    // Dynamic throttling priorities: API key > User > Workspace > IP
    if (apiKey) {
      await this.checkLimit(`apikey:${apiKey}`, 200);
    } else if (userId) {
      await this.checkLimit(`user:${userId}`, 100);
    } else if (workspaceId) {
      await this.checkLimit(`workspace:${workspaceId}`, 1000);
    } else {
      await this.checkLimit(`ip:${ip}`, 50);
    }
  }
}
