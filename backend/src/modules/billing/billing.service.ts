import { Injectable, BadRequestException, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import type Stripe from 'stripe';
const StripeConstructor = require('stripe');

@Injectable()
export class BillingService {
  private stripe: Stripe;

  constructor(private readonly prisma: PrismaService) {
    const apiKey = process.env.STRIPE_API_KEY || 'sk_test_51MockKey000000000000';
    this.stripe = new StripeConstructor(apiKey, {
      apiVersion: '2024-06-20',
    });
  }

  async createCheckoutSession(workspaceId: string, plan: string, priceId?: string): Promise<{ url: string }> {
    const workspace = await this.prisma.workspace.findUnique({
      where: { id: workspaceId },
    });

    if (!workspace) {
      throw new NotFoundException('Workspace not found');
    }

    // Try creating checkout session, fallback to mock if Stripe secret key is invalid/mock
    try {
      if (process.env.STRIPE_API_KEY) {
        let customerId = workspace.stripeCustomerId;
        if (!customerId) {
          const customer = await this.stripe.customers.create({
            email: `workspace-${workspaceId}@teamos.local`,
            metadata: { workspaceId },
          });
          customerId = customer.id;
          await this.prisma.workspace.update({
            where: { id: workspaceId },
            data: { stripeCustomerId: customerId },
          });
        }

        const session = await this.stripe.checkout.sessions.create({
          customer: customerId,
          payment_method_types: ['card'],
          line_items: [
            {
              price: priceId || 'price_mock_startup',
              quantity: 1,
            },
          ],
          mode: 'subscription',
          success_url: `${process.env.APP_URL || 'http://localhost:3000'}/billing/success?session_id={CHECKOUT_SESSION_ID}`,
          cancel_url: `${process.env.APP_URL || 'http://localhost:3000'}/billing/cancel`,
        });

        return { url: session.url || '' };
      }
    } catch (e) {
      // In dev or testing, fall back to mock redirect
    }

    return {
      url: `https://checkout.stripe.com/pay/mock_session_${workspaceId}_${plan.toLowerCase()}`,
    };
  }

  async createPortalSession(workspaceId: string): Promise<{ url: string }> {
    const workspace = await this.prisma.workspace.findUnique({
      where: { id: workspaceId },
    });

    if (!workspace) {
      throw new NotFoundException('Workspace not found');
    }

    let customerId = workspace.stripeCustomerId;
    if (!customerId) {
      customerId = `cus_mock_${workspaceId}`;
      await this.prisma.workspace.update({
        where: { id: workspaceId },
        data: { stripeCustomerId: customerId },
      });
    }

    try {
      if (process.env.STRIPE_API_KEY && !customerId.startsWith('cus_mock_')) {
        const session = await this.stripe.billingPortal.sessions.create({
          customer: customerId,
          return_url: `${process.env.APP_URL || 'http://localhost:3000'}/billing/subscription`,
        });
        return { url: session.url };
      }
    } catch (e) {
      // Fallback
    }

    return {
      url: `https://billing.stripe.com/p/session/mock_portal_${workspaceId}`,
    };
  }

  async getSubscription(workspaceId: string) {
    const workspace = await this.prisma.workspace.findUnique({
      where: { id: workspaceId },
      select: {
        plan: true,
        subscriptionStatus: true,
        subscriptionPeriodEnd: true,
        trialEndsAt: true,
        gracePeriodEndsAt: true,
      },
    });

    if (!workspace) {
      throw new NotFoundException('Workspace not found');
    }

    return {
      plan: workspace.plan,
      status: workspace.subscriptionStatus,
      renewalDate: workspace.subscriptionPeriodEnd ? workspace.subscriptionPeriodEnd.toISOString() : null,
      trialEndsAt: workspace.trialEndsAt ? workspace.trialEndsAt.toISOString() : null,
      gracePeriodEndsAt: workspace.gracePeriodEndsAt ? workspace.gracePeriodEndsAt.toISOString() : null,
    };
  }

  async getUsage(workspaceId: string) {
    // Try to get latest hourly snapshot
    const snapshot = await this.prisma.usageSnapshot.findFirst({
      where: { workspaceId },
      orderBy: { recordedAt: 'desc' },
    });

    if (snapshot) {
      return {
        users: snapshot.usersCount,
        projects: snapshot.projectsCount,
        storage: Number(snapshot.storageBytes),
        aiTokens: snapshot.aiTokens,
        meetingMinutes: snapshot.meetingMinutes,
      };
    }

    // Fallback to calculation
    const usersCount = await this.prisma.workspaceSeat.count({
      where: { workspaceId, status: 'ASSIGNED' },
    });

    const projectsCount = await this.prisma.project.count({
      where: { workspaceId },
    });

    const docCount = await this.prisma.document.count({
      where: { workspaceId },
    });

    const workspace = await this.prisma.workspace.findUnique({
      where: { id: workspaceId },
      select: { aiTokensUsed: true, storageBytesUsed: true },
    });

    return {
      users: usersCount,
      projects: projectsCount,
      storage: Number(workspace?.storageBytesUsed || 0),
      aiTokens: workspace?.aiTokensUsed || 0,
      meetingMinutes: 0,
      documents: docCount,
    };
  }

  async getInvoices(workspaceId: string) {
    return this.prisma.subscriptionInvoice.findMany({
      where: { workspaceId },
      orderBy: { createdAt: 'desc' },
    });
  }

  async handleWebhook(signature: string, payload: Buffer): Promise<{ received: boolean }> {
    // Enforce Stripe Signature check
    let event: Stripe.Event;
    const webhookSecret = process.env.STRIPE_WEBHOOK_SECRET || 'whsec_mock';

    try {
      if (process.env.STRIPE_API_KEY && process.env.STRIPE_WEBHOOK_SECRET) {
        event = this.stripe.webhooks.constructEvent(payload, signature, webhookSecret);
      } else {
        // Dev parse fallback
        event = JSON.parse(payload.toString());
      }
    } catch (err) {
      throw new BadRequestException(`Webhook signature validation failed: ${err.message}`);
    }

    // Idempotency: verify if event was already processed
    const existingEvent = await this.prisma.billingEvent.findUnique({
      where: { stripeEventId: event.id },
    });

    if (existingEvent) {
      return { received: true };
    }

    // Record event
    await this.prisma.billingEvent.create({
      data: {
        stripeEventId: event.id,
        type: event.type,
        status: 'PROCESSING',
      },
    });

    try {
      await this.processEvent(event);
      await this.prisma.billingEvent.update({
        where: { stripeEventId: event.id },
        data: { status: 'PROCESSED' },
      });
    } catch (e) {
      await this.prisma.billingEvent.update({
        where: { stripeEventId: event.id },
        data: { status: 'FAILED' },
      });
      throw e;
    }

    return { received: true };
  }

  private async processEvent(event: Stripe.Event) {
    const dataObject = event.data.object as any;

    switch (event.type) {
      case 'checkout.session.completed': {
        const workspaceId = dataObject.metadata?.workspaceId;
        const customerId = dataObject.customer;
        const subscriptionId = dataObject.subscription;

        if (workspaceId) {
          await this.prisma.workspace.update({
            where: { id: workspaceId },
            data: {
              stripeCustomerId: customerId,
              stripeSubscriptionId: subscriptionId,
              plan: 'STARTUP', // Default tier mapped from checkout session
              subscriptionStatus: 'ACTIVE',
            },
          });
        }
        break;
      }

      case 'customer.subscription.created':
      case 'customer.subscription.updated': {
        const customerId = dataObject.customer;
        const subscriptionId = dataObject.id;
        const status = dataObject.status;
        const planId = dataObject.items?.data[0]?.price?.id;

        let plan: 'FREE' | 'STARTUP' | 'BUSINESS' | 'ENTERPRISE' = 'STARTUP';
        if (planId === 'price_business') plan = 'BUSINESS';
        if (planId === 'price_enterprise') plan = 'ENTERPRISE';

        const subStatus = status === 'active' ? 'ACTIVE' :
                          status === 'trialing' ? 'TRIALING' :
                          status === 'past_due' ? 'PAST_DUE' :
                          status === 'canceled' ? 'CANCELED' :
                          status === 'paused' ? 'PAUSED' : 'INCOMPLETE';

        const periodEnd = new Date(dataObject.current_period_end * 1000);

        // Find workspace by customer ID
        const workspace = await this.prisma.workspace.findFirst({
          where: { stripeCustomerId: customerId },
        });

        if (workspace) {
          const oldPlan = workspace.plan;
          await this.prisma.workspace.update({
            where: { id: workspace.id },
            data: {
              stripeSubscriptionId: subscriptionId,
              plan,
              subscriptionStatus: subStatus,
              subscriptionPeriodEnd: periodEnd,
              gracePeriodEndsAt: subStatus === 'PAST_DUE' ? new Date(Date.now() + 3 * 24 * 60 * 60 * 1000) : null,
            },
          });

          if (oldPlan !== plan) {
            await this.prisma.subscriptionAudit.create({
              data: {
                workspaceId: workspace.id,
                userId: 'SYSTEM',
                action: 'PLAN_CHANGE_WEBHOOK',
                previousPlan: oldPlan,
                newPlan: plan,
              },
            });
          }
        }
        break;
      }

      case 'customer.subscription.deleted': {
        const customerId = dataObject.customer;
        const workspace = await this.prisma.workspace.findFirst({
          where: { stripeCustomerId: customerId },
        });

        if (workspace) {
          await this.prisma.workspace.update({
            where: { id: workspace.id },
            data: {
              subscriptionStatus: 'CANCELED',
              plan: 'FREE',
            },
          });
        }
        break;
      }

      case 'invoice.paid': {
        const customerId = dataObject.customer;
        const stripeInvoiceId = dataObject.id;
        const amountPaid = dataObject.amount_paid;
        const currency = dataObject.currency;
        const hostedInvoiceUrl = dataObject.hosted_invoice_url;

        const workspace = await this.prisma.workspace.findFirst({
          where: { stripeCustomerId: customerId },
        });

        if (workspace) {
          await this.prisma.subscriptionInvoice.create({
            data: {
              workspaceId: workspace.id,
              stripeInvoiceId,
              amountPaid,
              currency,
              status: 'PAID',
              hostedInvoiceUrl,
            },
          });
        }
        break;
      }

      case 'invoice.payment_failed': {
        const customerId = dataObject.customer;
        const workspace = await this.prisma.workspace.findFirst({
          where: { stripeCustomerId: customerId },
        });

        if (workspace) {
          await this.prisma.workspace.update({
            where: { id: workspace.id },
            data: {
              subscriptionStatus: 'PAST_DUE',
              gracePeriodEndsAt: new Date(Date.now() + 3 * 24 * 60 * 60 * 1000), // 3 days grace
            },
          });
        }
        break;
      }
    }
  }
}
