import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class FeatureStoreService {
  constructor(private readonly prisma: PrismaService) {}

  async registerFeature(workspaceId: string, name: string, type: string, entityId: string) {
    return this.prisma.feature.create({
      data: {
        workspaceId,
        name,
        type,
        entityId,
      },
    });
  }

  async createFeatureGroup(workspaceId: string, name: string, entityName: string, featuresList: string[]) {
    return this.prisma.featureGroup.create({
      data: {
        workspaceId,
        name,
        entityName,
        featuresList: JSON.stringify(featuresList),
      },
    });
  }

  async updateOnlineCache(workspaceId: string, featureKey: string, featureValue: string) {
    const existing = await this.prisma.onlineFeatureCache.findFirst({
      where: { workspaceId, featureKey },
    });

    if (existing) {
      return this.prisma.onlineFeatureCache.update({
        where: { id: existing.id },
        data: { featureValue },
      });
    }

    return this.prisma.onlineFeatureCache.create({
      data: {
        workspaceId,
        featureKey,
        featureValue,
      },
    });
  }
}
