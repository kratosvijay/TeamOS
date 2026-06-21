import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class TrialService {
  constructor(private readonly prisma: PrismaService) {}

  async startTrial(workspaceId: string, durationDays = 14): Promise<void> {
    const workspace = await this.prisma.workspace.findUnique({
      where: { id: workspaceId },
    });

    if (!workspace) {
      throw new NotFoundException('Workspace not found');
    }

    const trialEndsAt = new Date();
    trialEndsAt.setDate(trialEndsAt.getDate() + durationDays);

    await this.prisma.workspace.update({
      where: { id: workspaceId },
      data: {
        plan: 'STARTUP',
        subscriptionStatus: 'TRIALING',
        trialEndsAt,
      },
    });
  }

  async extendTrial(workspaceId: string, extensionDays: number): Promise<Date> {
    const workspace = await this.prisma.workspace.findUnique({
      where: { id: workspaceId },
    });

    if (!workspace) {
      throw new NotFoundException('Workspace not found');
    }

    const currentTrialEnd = workspace.trialEndsAt || new Date();
    const newTrialEnd = new Date(currentTrialEnd.getTime());
    newTrialEnd.setDate(newTrialEnd.getDate() + extensionDays);

    await this.prisma.workspace.update({
      where: { id: workspaceId },
      data: {
        trialEndsAt: newTrialEnd,
        subscriptionStatus: 'TRIALING',
      },
    });

    return newTrialEnd;
  }

  async checkTrialExpirations(): Promise<void> {
    const expiredWorkspaces = await this.prisma.workspace.findMany({
      where: {
        subscriptionStatus: 'TRIALING',
        trialEndsAt: { lt: new Date() },
      },
    });

    for (const workspace of expiredWorkspaces) {
      await this.prisma.workspace.update({
        where: { id: workspace.id },
        data: {
          plan: 'FREE',
          subscriptionStatus: 'CANCELED',
        },
      });

      // Audit transition
      await this.prisma.subscriptionAudit.create({
        data: {
          workspaceId: workspace.id,
          userId: 'SYSTEM',
          action: 'TRIAL_EXPIRED',
          previousPlan: workspace.plan,
          newPlan: 'FREE',
        },
      });
    }
  }

  async getTrialAnalytics() {
    const totalTrials = await this.prisma.workspace.count({
      where: { trialEndsAt: { not: null } },
    });

    const activeTrials = await this.prisma.workspace.count({
      where: { subscriptionStatus: 'TRIALING' },
    });

    const convertedTrials = await this.prisma.workspace.count({
      where: {
        trialEndsAt: { not: null },
        plan: { in: ['STARTUP', 'BUSINESS', 'ENTERPRISE'] },
        subscriptionStatus: 'ACTIVE',
      },
    });

    const expiredTrials = await this.prisma.workspace.count({
      where: {
        trialEndsAt: { lt: new Date() },
        plan: 'FREE',
      },
    });

    const conversionRate = totalTrials > 0 ? (convertedTrials / totalTrials) * 100 : 0;

    return {
      totalTrials,
      activeTrials,
      convertedTrials,
      expiredTrials,
      conversionRate: parseFloat(conversionRate.toFixed(2)),
    };
  }
}
