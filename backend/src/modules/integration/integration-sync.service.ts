import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { IntegrationSyncStatus } from '@prisma/client';

@Injectable()
export class IntegrationSyncService {
  constructor(private readonly prisma: PrismaService) {}

  async updateSyncStatus(installationId: string, status: IntegrationSyncStatus) {
    return this.prisma.integrationInstallation.update({
      where: { id: installationId },
      data: { syncStatus: status },
    });
  }

  async triggerSync(installationId: string) {
    await this.updateSyncStatus(installationId, IntegrationSyncStatus.SYNCING);

    try {
      const installation = await this.prisma.integrationInstallation.findUnique({
        where: { id: installationId },
        include: { integration: true },
      });

      if (!installation || installation.status !== 'ACTIVE') {
        await this.updateSyncStatus(installationId, IntegrationSyncStatus.PAUSED);
        return;
      }

      // Simulate provider specific syncing logic
      console.log(`SyncEngine: Running synchronization for ${installation.integration.provider}`);
      await new Promise((resolve) => setTimeout(resolve, 200)); // simulate work

      await this.updateSyncStatus(installationId, IntegrationSyncStatus.SYNCED);
    } catch (error) {
      console.error(`SyncEngine: Sync failed for installation ${installationId}`, error);
      await this.updateSyncStatus(installationId, IntegrationSyncStatus.FAILED);
      throw error;
    }
  }

  async scheduleSync(installationId: string) {
    await this.updateSyncStatus(installationId, IntegrationSyncStatus.SYNC_PENDING);
    console.log(`SyncEngine: Scheduled sync for installation ${installationId}`);
  }

  async runHealthCheck(installationId: string) {
    const installation = await this.prisma.integrationInstallation.findUnique({
      where: { id: installationId },
    });

    if (!installation) return;

    if (installation.syncStatus === IntegrationSyncStatus.FAILED) {
      console.log(`SyncEngine Health Check: Attempting error recovery for ${installationId}`);
      try {
        await this.triggerSync(installationId);
      } catch (e) {
        console.warn(`SyncEngine Health Check: Recovery failed for ${installationId}`);
      }
    }
  }
}
