import { Injectable, NotFoundException, ForbiddenException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { IntegrationPermission, IntegrationSyncStatus } from '@prisma/client';

@Injectable()
export class IntegrationService {
  constructor(private readonly prisma: PrismaService) {}

  async getIntegrations(workspaceId: string) {
    return this.prisma.integration.findMany({
      where: { workspaceId },
      include: { installations: true },
    });
  }

  async getIntegrationById(workspaceId: string, id: string) {
    const integration = await this.prisma.integration.findFirst({
      where: { id, workspaceId },
      include: { installations: true },
    });
    if (!integration) {
      throw new NotFoundException('Integration not found');
    }
    return integration;
  }

  async installIntegration(
    workspaceId: string,
    userId: string,
    body: { provider: string; name: string; settings: any; permission: IntegrationPermission },
  ) {
    const { provider, name, settings, permission } = body;

    // First find or create the core Integration entry
    let integration = await this.prisma.integration.findFirst({
      where: { workspaceId, provider: provider.toUpperCase() },
    });

    if (!integration) {
      integration = await this.prisma.integration.create({
        data: {
          workspaceId,
          provider: provider.toUpperCase(),
          name,
          description: `Connect workspace with ${provider}`,
          status: 'ACTIVE',
        },
      });
    }

    // Create the installation
    const installation = await this.prisma.integrationInstallation.create({
      data: {
        workspaceId,
        integrationId: integration.id,
        installedBy: userId,
        settings: settings || {},
        status: 'ACTIVE',
        permission: permission || IntegrationPermission.READ_ONLY,
        syncStatus: IntegrationSyncStatus.SYNC_PENDING,
      },
    });

    // Audit Log
    await this.prisma.auditTrail.create({
      data: {
        workspaceId,
        actorId: userId,
        action: 'INTEGRATION_INSTALL',
        entityType: 'IntegrationInstallation',
        entityId: installation.id,
        newValue: { provider, permission },
      },
    });

    return installation;
  }

  async uninstallIntegration(workspaceId: string, userId: string, installationId: string) {
    const installation = await this.prisma.integrationInstallation.findFirst({
      where: { id: installationId, workspaceId },
    });

    if (!installation) {
      throw new NotFoundException('Installation not found');
    }

    // Verify Admin rights or role to uninstall
    const member = await this.prisma.workspaceMember.findFirst({
      where: { workspaceId, userId },
    });

    if (!member || member.role !== 'ADMIN') {
      throw new ForbiddenException('Only workspace administrators can uninstall integrations');
    }

    await this.prisma.integrationInstallation.delete({
      where: { id: installationId },
    });

    // Audit Log
    await this.prisma.auditTrail.create({
      data: {
        workspaceId,
        actorId: userId,
        action: 'INTEGRATION_UNINSTALL',
        entityType: 'IntegrationInstallation',
        entityId: installationId,
        newValue: { integrationId: installation.integrationId },
      },
    });

    return { success: true };
  }
}
