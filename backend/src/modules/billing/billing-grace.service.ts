import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class BillingGraceService {
  constructor(private readonly prisma: PrismaService) {}

  async checkGracePeriod(workspaceId: string): Promise<{
    allowed: boolean;
    inGrace: boolean;
    daysRemaining: number;
  }> {
    const workspace = await this.prisma.workspace.findUnique({
      where: { id: workspaceId },
      select: {
        subscriptionStatus: true,
        gracePeriodEndsAt: true,
      },
    });

    if (!workspace) {
      throw new NotFoundException('Workspace not found');
    }

    if (workspace.subscriptionStatus !== 'PAST_DUE') {
      return {
        allowed: workspace.subscriptionStatus !== 'CANCELED',
        inGrace: false,
        daysRemaining: 0,
      };
    }

    const graceEnd = workspace.gracePeriodEndsAt;
    if (!graceEnd) {
      return {
        allowed: false,
        inGrace: false,
        daysRemaining: 0,
      };
    }

    const now = new Date();
    if (graceEnd.getTime() > now.getTime()) {
      const diffMs = graceEnd.getTime() - now.getTime();
      const daysRemaining = Math.max(0, Math.ceil(diffMs / (1000 * 60 * 60 * 24)));
      return {
        allowed: true,
        inGrace: true,
        daysRemaining,
      };
    }

    // Grace period expired
    return {
      allowed: false,
      inGrace: false,
      daysRemaining: 0,
    };
  }
}
