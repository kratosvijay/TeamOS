import { Injectable, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { IntegrationService } from '../integration/integration.service';
import { IntegrationPermission } from '@prisma/client';

@Injectable()
export class MarketplaceService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly integrationService: IntegrationService,
  ) {}

  async getCatalog() {
    const hardcoded = [
      {
        id: 'market-github',
        provider: 'GITHUB',
        name: 'GitHub Connector',
        description: 'Connect repository pull requests, commit pushes, actions, and releases to tasks',
        rating: 4.8,
        category: 'Development',
        version: '1.2.0',
        permissionsRequired: ['READ_WRITE', 'ADMIN'],
        author: 'TeamOS Core',
        downloads: 1540,
      },
      {
        id: 'market-gitlab',
        provider: 'GITLAB',
        name: 'GitLab Sync',
        description: 'Sync merge requests, issues, and CI pipelines monitoring with sprint boards',
        rating: 4.6,
        category: 'Development',
        version: '1.0.5',
        permissionsRequired: ['READ_WRITE'],
        author: 'TeamOS Core',
        downloads: 870,
      },
    ];

    // Fetch approved developer apps from Prisma database
    const dbApps = await this.prisma.developerApp.findMany({
      where: { status: 'APPROVED' },
    });

    const mappedDbApps = dbApps.map((app) => ({
      id: app.id,
      provider: app.slug.toUpperCase(),
      name: app.name,
      description: app.description,
      rating: app.rating,
      category: app.category,
      version: app.version,
      permissionsRequired: ['READ_ONLY'],
      author: app.author,
      downloads: app.downloads,
    }));

    return [...hardcoded, ...mappedDbApps];
  }

  async installMarketplaceIntegration(
    workspaceId: string,
    userId: string,
    provider: string,
    permission: IntegrationPermission,
  ) {
    const catalog = await this.getCatalog();
    const item = catalog.find((c) => c.provider === provider.toUpperCase());
    if (!item) {
      throw new Error(`Integration for provider ${provider} not found in marketplace`);
    }

    // Verify app database entry and increment downloads
    const app = await this.prisma.developerApp.findFirst({
      where: { slug: provider.toLowerCase() },
    });
    if (app) {
      await this.prisma.developerApp.update({
        where: { id: app.id },
        data: { downloads: app.downloads + 1 },
      });
    }

    // Record installation
    await this.prisma.installedExtension.create({
      data: {
        workspaceId,
        extensionId: item.id,
        version: item.version,
        enabled: true,
        installedBy: userId,
      },
    });

    return this.integrationService.installIntegration(workspaceId, userId, {
      provider,
      name: item.name,
      settings: { installedFromMarketplace: true, catalogVersion: item.version },
      permission,
    });
  }

  async uninstallMarketplaceIntegration(workspaceId: string, extensionId: string) {
    const installed = await this.prisma.installedExtension.findFirst({
      where: { workspaceId, extensionId },
    });

    if (!installed) {
      throw new BadRequestException('Extension not installed in this workspace');
    }

    await this.prisma.installedExtension.delete({
      where: { id: installed.id },
    });

    return { success: true };
  }

  async addReview(appId: string, reviewer: string, rating: number, text: string) {
    // Add review
    const review = await this.prisma.marketplaceReview.create({
      data: {
        appId,
        reviewer,
        rating,
        reviewText: text,
        status: 'APPROVED',
      },
    });

    // Update app rating
    const allReviews = await this.prisma.marketplaceReview.findMany({
      where: { appId },
    });
    const avgRating = allReviews.reduce((sum, r) => sum + r.rating, 0) / allReviews.length;

    await this.prisma.developerApp.update({
      where: { id: appId },
      data: { rating: avgRating },
    });

    return review;
  }
}
