import { Injectable, HttpException, HttpStatus } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import * as crypto from 'crypto';

@Injectable()
export class ApiGatewayService {
  private rateLimits = new Map<string, { count: number; resetTime: number }>();

  constructor(private readonly prisma: PrismaService) {}

  hashKey(key: string): string {
    return crypto.createHash('sha256').update(key).digest('hex');
  }

  async validateApiKey(key: string): Promise<any> {
    const hashed = this.hashKey(key);
    const apiKey = await this.prisma.aPIKey.findUnique({
      where: { keyHash: hashed },
    });

    if (!apiKey) {
      throw new HttpException('Invalid API key', HttpStatus.UNAUTHORIZED);
    }

    if (apiKey.expiresAt && apiKey.expiresAt < new Date()) {
      throw new HttpException('API key has expired', HttpStatus.UNAUTHORIZED);
    }

    // Update lastUsed
    await this.prisma.aPIKey.update({
      where: { id: apiKey.id },
      data: { lastUsed: new Date() },
    });

    return apiKey;
  }

  checkRateLimit(identifier: string, limit = 100, windowMs = 60000): void {
    const now = Date.now();
    const rate = this.rateLimits.get(identifier);

    if (!rate || now > rate.resetTime) {
      this.rateLimits.set(identifier, {
        count: 1,
        resetTime: now + windowMs,
      });
      return;
    }

    if (rate.count >= limit) {
      throw new HttpException('Too many requests. Rate limit exceeded.', HttpStatus.TOO_MANY_REQUESTS);
    }

    rate.count++;
  }

  async logAnalytics(workspaceId: string, path: string, duration: number, error = false) {
    console.log(`[API Analytics] Workspace: ${workspaceId} | Path: ${path} | Duration: ${duration}ms | Error: ${error}`);
    try {
      await this.prisma.extensionAnalytics.create({
        data: {
          extensionId: 'api-gateway',
          installs: 1,
          activeUsers: 1,
          crashes: error ? 1 : 0,
          averageExecutionTime: duration,
          errors: error ? 1 : 0,
        },
      });
    } catch {
      // Swallowed
    }
  }
}
