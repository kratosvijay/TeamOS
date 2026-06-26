import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class ApplicationMarketplaceService {
  constructor(private prisma: PrismaService) {}

  async listInMarketplace(workspaceId: string, name: string, description: string, version: string, packageJson: string, price: number) {
    const signature = `sha256-marketplace-sig-${Buffer.from(packageJson).toString('base64').substring(0, 32)}`;
    return this.prisma.marketplaceApplication.create({
      data: {
        workspaceId,
        name,
        description,
        publisher: 'Partner Tenant',
        version,
        packageJson,
        price,
        signature,
        isApproved: false,
      },
    });
  }

  async approveMarketplaceApplication(id: string) {
    return this.prisma.marketplaceApplication.update({
      where: { id },
      data: { isApproved: true },
    });
  }

  async purchaseApplication(workspaceId: string, blueprintId: string, amount: number) {
    const blueprint = await this.prisma.marketplaceApplication.findUnique({ where: { id: blueprintId } });
    if (!blueprint) throw new Error('Marketplace blueprint not found');

    const licenseKey = `EAP-LIC-${Math.random().toString(36).substring(2, 10).toUpperCase()}`;

    return this.prisma.marketplacePurchase.create({
      data: {
        workspaceId,
        blueprintId,
        licenseKey,
        amountPaid: amount,
      },
    });
  }

  async getMarketplaceApps() {
    return this.prisma.marketplaceApplication.findMany({
      where: { isApproved: true },
    });
  }
}
