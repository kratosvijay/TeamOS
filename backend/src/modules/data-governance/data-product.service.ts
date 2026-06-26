import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class DataProductService {
  constructor(private readonly prisma: PrismaService) {}

  async createProduct(workspaceId: string, name: string, description: string, ownerUserId: string) {
    const product = await this.prisma.dataProduct.create({
      data: {
        workspaceId,
        name,
        description,
        status: 'ACTIVE',
      },
    });

    await this.prisma.dataProductOwner.create({
      data: {
        workspaceId,
        dataProductId: product.id,
        ownerUserId,
      },
    });

    return product;
  }

  async addProductVersion(workspaceId: string, dataProductId: string, version: string, schemaJson: string) {
    return this.prisma.dataProductVersion.create({
      data: {
        workspaceId,
        dataProductId,
        version,
        schemaJson,
      },
    });
  }
}
