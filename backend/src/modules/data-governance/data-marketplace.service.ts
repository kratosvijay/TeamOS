import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class DataMarketplaceService {
  constructor(private readonly prisma: PrismaService) {}

  async publishDataset(workspaceId: string, name: string, description: string, price: number) {
    return this.prisma.marketplaceDataset.create({
      data: {
        workspaceId,
        name,
        description,
        price,
      },
    });
  }

  async requestAccess(workspaceId: string, datasetId: string, requestorId: string) {
    return this.prisma.accessRequest.create({
      data: {
        workspaceId,
        datasetId,
        requestorId,
        status: 'PENDING',
      },
    });
  }

  async approveRequest(requestId: string) {
    return this.prisma.accessRequest.update({
      where: { id: requestId },
      data: { status: 'APPROVED' },
    });
  }
}
