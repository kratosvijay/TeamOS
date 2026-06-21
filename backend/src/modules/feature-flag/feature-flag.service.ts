import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class FeatureFlagService {
  constructor(private prisma: PrismaService) {}

  async isFeatureEnabled(workspaceId: string, key: string): Promise<boolean> {
    const flag = await this.prisma.featureFlag.findUnique({
      where: {
        workspaceId_key: { workspaceId, key },
      },
    });
    // Default to true if not explicitly disabled
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
}
