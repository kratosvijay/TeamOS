import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { NotificationService } from '../notification/notification.service';
import { NotificationType } from '@prisma/client';

@Injectable()
export class BillingNotificationService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly notificationService: NotificationService,
  ) {}

  private async notifyAdmins(workspaceId: string, title: string, message: string) {
    const workspace = await this.prisma.workspace.findUnique({
      where: { id: workspaceId },
      select: { ownerId: true, members: { select: { userId: true, role: true } } },
    });

    if (!workspace) return;

    // Collect owner and all admin user IDs
    const userIds = new Set<string>();
    userIds.add(workspace.ownerId);

    for (const member of workspace.members) {
      if (member.role === 'ADMIN') {
        userIds.add(member.userId);
      }
    }

    for (const userId of userIds) {
      await this.notificationService.createNotification(
        userId,
        NotificationType.BILLING_ALERT,
        title,
        message,
        'WORKSPACE_BILLING',
        workspaceId,
      );
    }
  }

  async notifyTrialEnding(workspaceId: string, daysRemaining: number) {
    await this.notifyAdmins(
      workspaceId,
      'Trial Ending Soon',
      `Your workspace 14-day trial will end in ${daysRemaining} day(s). Add a payment method to prevent service interruption.`,
    );
  }

  async notifyPaymentFailed(workspaceId: string) {
    await this.notifyAdmins(
      workspaceId,
      'Payment Failure',
      'We were unable to charge your card on file. Your subscription status is now past due.',
    );
  }

  async notifySubscriptionRenewed(workspaceId: string) {
    await this.notifyAdmins(
      workspaceId,
      'Subscription Renewed',
      'Your TeamOS plan subscription has been successfully renewed. Thank you for your payment!',
    );
  }

  async notifyUsageWarning(workspaceId: string, resourceType: string, percentage: number) {
    await this.notifyAdmins(
      workspaceId,
      'Usage Limit Warning',
      `Your workspace has consumed ${percentage}% of its allocated monthly ${resourceType} limit.`,
    );
  }

  async notifyGracePeriodStarted(workspaceId: string, daysRemaining: number) {
    await this.notifyAdmins(
      workspaceId,
      'Grace Period Active',
      `Your payment failed. A ${daysRemaining}-day grace period has started. Add a card to prevent write-blockage.`,
    );
  }

  async notifyGracePeriodExpiring(workspaceId: string) {
    await this.notifyAdmins(
      workspaceId,
      'Grace Period Expiring Today',
      'Your grace period expires today. Mutations will be blocked immediately if payment is not received.',
    );
  }
}
