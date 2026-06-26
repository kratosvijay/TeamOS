import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class IntegrationFabricService {
  constructor(private readonly prisma: PrismaService) {}

  async createIntegration(workspaceId: string, name: string, connectorId: string, connectionId: string) {
    return this.prisma.fabricIntegration.create({
      data: {
        workspaceId,
        name,
        connectorId,
        connectionId,
        status: 'ACTIVE',
      },
    });
  }

  async runSync(integrationId: string) {
    const integration = await this.prisma.fabricIntegration.findUnique({
      where: { id: integrationId },
    });
    if (!integration) throw new Error('Integration not found');

    await this.prisma.integrationLog.create({
      data: {
        workspaceId: integration.workspaceId,
        integrationId: integration.id,
        level: 'INFO',
        message: `Starting async sync sync execution for integration ${integration.name}`,
      },
    });

    return { integrationId, status: 'SYNCING' };
  }

  async handleQueueRetry(executionId: string, attempt: number) {
    const execution = await this.prisma.integrationExecution.findUnique({
      where: { id: executionId },
    });
    if (!execution) throw new Error('Execution not found');

    if (attempt > 3) {
      await this.prisma.integrationExecution.update({
        where: { id: executionId },
        data: { status: 'FAILED' },
      });
      return { executionId, status: 'DLQ' };
    }

    return { executionId, attempt, status: 'RETRYING' };
  }
}
