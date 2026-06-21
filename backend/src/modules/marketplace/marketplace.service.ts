import { Injectable } from '@nestjs/common';
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
    return [
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
      },
      {
        id: 'market-google',
        provider: 'GOOGLE',
        name: 'Google Workspace',
        description: 'Synchronize Google Calendar events, Google Drive documents, and Meet appointments',
        rating: 4.9,
        category: 'Productivity',
        version: '2.0.1',
        permissionsRequired: ['READ_ONLY', 'READ_WRITE'],
        author: 'TeamOS Core',
      },
      {
        id: 'market-slack',
        provider: 'SLACK',
        name: 'Slack Alerts',
        description: 'Dispatch custom notification alerts, action updates, and daily summaries to Slack channels',
        rating: 4.7,
        category: 'Communication',
        version: '1.5.0',
        permissionsRequired: ['ADMIN'],
        author: 'TeamOS Core',
      },
    ];
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

    return this.integrationService.installIntegration(workspaceId, userId, {
      provider,
      name: item.name,
      settings: { installedFromMarketplace: true, catalogVersion: item.version },
      permission,
    });
  }
}
