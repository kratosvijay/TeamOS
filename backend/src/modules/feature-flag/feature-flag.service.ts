import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import * as crypto from 'crypto';

@Injectable()
export class FeatureFlagService {
  constructor(private prisma: PrismaService) {}

  async isFeatureEnabled(workspaceId: string, key: string): Promise<boolean> {
    const flag = await this.prisma.featureFlag.findUnique({
      where: {
        workspaceId_key: { workspaceId, key },
      },
    });
    return flag ? flag.enabled : true;
  }

  async setFeatureStatus(workspaceId: string, key: string, enabled: boolean) {
    return this.prisma.featureFlag.upsert({
      where: {
        workspaceId_key: { workspaceId, key },
      },
      update: { enabled },
      create: { workspaceId, key, enabled },
    });
  }

  // Enhanced features for Phase 21
  async evaluateFlag(workspaceId: string, key: string, userId?: string, rolloutPercent = 100): Promise<boolean> {
    const isGloballyEnabled = await this.isFeatureEnabled(workspaceId, key);
    if (!isGloballyEnabled) return false; // Kill switch triggered

    if (userId && rolloutPercent < 100) {
      // Deterministic percentage rollout based on hashing user ID
      const hash = crypto.createHash('md5').update(userId + key).digest('hex');
      const score = parseInt(hash.substring(0, 8), 16) % 100;
      return score < rolloutPercent;
    }

    return true;
  }
}
