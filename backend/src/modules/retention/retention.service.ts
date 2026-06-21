import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class RetentionService {
  constructor(private prisma: PrismaService) {}

  async createOrUpdatePolicy(workspaceId: string, targetType: string, retentionDays: number) {
    const existing = await this.prisma.retentionPolicy.findFirst({
      where: { workspaceId, targetType },
    });

    if (existing) {
      return this.prisma.retentionPolicy.update({
        where: { id: existing.id },
        data: { retentionDays },
      });
    }

    return this.prisma.retentionPolicy.create({
      data: {
        workspaceId,
        targetType,
        retentionDays,
      },
    });
  }

  async getPolicies(workspaceId: string) {
    return this.prisma.retentionPolicy.findMany({
      where: { workspaceId },
    });
  }

  async createOrUpdateLegalHold(workspaceId: string, name: string, active: boolean) {
    const existing = await this.prisma.legalHold.findFirst({
      where: { workspaceId, name },
    });

    if (existing) {
      return this.prisma.legalHold.update({
        where: { id: existing.id },
        data: { active },
      });
    }

    return this.prisma.legalHold.create({
      data: {
        workspaceId,
        name,
        active,
      },
    });
  }

  async getLegalHolds(workspaceId: string) {
    return this.prisma.legalHold.findMany({
      where: { workspaceId },
    });
  }

  async isWorkspaceUnderHold(workspaceId: string): Promise<boolean> {
    const activeHold = await this.prisma.legalHold.findFirst({
      where: { workspaceId, active: true },
    });
    return !!activeHold;
  }

  async runRetentionCleanup(workspaceId: string) {
    const isUnderHold = await this.isWorkspaceUnderHold(workspaceId);
    if (isUnderHold) {
      console.log(`Workspace ${workspaceId} is under active Legal Hold. Skipping retention cleanup.`);
      return { skipped: true, reason: 'Legal Hold Active' };
    }

    const policies = await this.getPolicies(workspaceId);
    const results: any = {};

    for (const policy of policies) {
      const cutOffDate = new Date(Date.now() - policy.retentionDays * 24 * 60 * 60 * 1000);

      if (policy.targetType === 'Messages') {
        const res = await this.prisma.message.deleteMany({
          where: {
            channel: { workspaceId },
            createdAt: { lt: cutOffDate },
          },
        });
        results['Messages'] = res.count;
      } else if (policy.targetType === 'Meetings') {
        const res = await this.prisma.meeting.deleteMany({
          where: {
            workspaceId,
            createdAt: { lt: cutOffDate },
          },
        });
        results['Meetings'] = res.count;
      } else if (policy.targetType === 'Documents') {
        const res = await this.prisma.document.deleteMany({
          where: {
            workspaceId,
            createdAt: { lt: cutOffDate },
          },
        });
        results['Documents'] = res.count;
      } else if (policy.targetType === 'Audit Logs') {
        const res = await this.prisma.auditTrail.deleteMany({
          where: {
            workspaceId,
            createdAt: { lt: cutOffDate },
          },
        });
        results['Audit Logs'] = res.count;
      } else if (policy.targetType === 'AI Conversations') {
        const res = await this.prisma.aIConversation.deleteMany({
          where: {
            workspaceId,
            createdAt: { lt: cutOffDate },
          },
        });
        results['AI Conversations'] = res.count;
      }
    }

    return { skipped: false, results };
  }
}
