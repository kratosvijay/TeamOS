import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class AssetsService {
  constructor(private prisma: PrismaService) {}

  async createAsset(workspaceId: string, name: string, category: string, value: number) {
    return this.prisma.eRPAsset.create({
      data: {
        workspaceId,
        name,
        category,
        value,
        status: 'ACTIVE',
      },
    });
  }

  async getAssets(workspaceId: string) {
    return this.prisma.eRPAsset.findMany({
      where: { workspaceId },
      orderBy: { name: 'asc' },
    });
  }

  async scheduleMaintenance(assetId: string, title: string, scheduledDate: Date) {
    const asset = await this.prisma.eRPAsset.findUnique({
      where: { id: assetId },
    });
    if (!asset) {
      throw new NotFoundException(`Asset with ID ${assetId} not found`);
    }

    return this.prisma.assetMaintenance.create({
      data: {
        assetId,
        title,
        scheduledDate,
        status: 'SCHEDULED',
      },
    });
  }

  async getMaintenanceTasks(assetId: string) {
    return this.prisma.assetMaintenance.findMany({
      where: { assetId },
      orderBy: { scheduledDate: 'asc' },
    });
  }
}
