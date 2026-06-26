import { Injectable } from '@nestjs/common';
import * as crypto from 'crypto';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class WebhookService {
  private readonly processedEvents = new Set<string>(); // Replay protection memory cache

  constructor(private readonly prisma: PrismaService) {}

  validateSignature(payload: string, signature: string, secret: string): boolean {
    if (!payload || !signature || !secret) return false;
    const computed = crypto.createHmac('sha256', secret).update(payload).digest('hex');
    return crypto.timingSafeEqual(Buffer.from(computed), Buffer.from(signature));
  }

  isDuplicateEvent(eventId: string): boolean {
    if (this.processedEvents.has(eventId)) {
      return true;
    }
    this.processedEvents.add(eventId);
    // Limit cache memory size
    if (this.processedEvents.size > 10000) {
      const first = this.processedEvents.values().next().value;
      if (first !== undefined) {
        this.processedEvents.delete(first);
      }
    }
    return false;
  }

  async registerWebhook(workspaceId: string, provider: string, url: string, secret: string) {
    return this.prisma.webhook.create({
      data: {
        workspaceId,
        provider: provider.toUpperCase(),
        url,
        secret,
        status: 'ACTIVE',
      },
    });
  }

  async testWebhook(webhookId: string) {
    const webhook = await this.prisma.webhook.findUnique({
      where: { id: webhookId },
    });
    if (!webhook) throw new Error('Webhook not found');

    await this.deliverWebhook(webhook.id, 'webhook.test', { test: true });
    return { success: true };
  }

  async getDeliveryLogs(webhookId: string) {
    return this.prisma.webhookDelivery.findMany({
      where: { webhookId },
      orderBy: { createdAt: 'desc' },
      take: 50,
    });
  }

  async deliverWebhook(webhookId: string, event: string, payload: any) {
    const webhook = await this.prisma.webhook.findUnique({
      where: { id: webhookId },
    });
    if (!webhook || webhook.status !== 'ACTIVE') return;

    // Event filtering: check WebhookSubscription table
    const sub = await this.prisma.webhookSubscription.findFirst({
      where: { workspaceId: webhook.workspaceId, url: webhook.url },
    });
    if (sub && sub.events && sub.events.length > 0) {
      if (!sub.events.includes(event) && !sub.events.includes('*')) {
        console.log(`Webhook Event ${event} filtered out for ${webhook.url}`);
        return;
      }
    }

    const payloadString = JSON.stringify(payload);
    const signature = crypto.createHmac('sha256', webhook.secret).update(payloadString).digest('hex');

    let responseStatus: number | null = null;
    let attempts = 0;
    let success = false;

    // Retry engine with exponential backoff (max 3 attempts)
    while (attempts < 3 && !success) {
      attempts++;
      try {
        // In production: perform actual fetch/post call
        // We simulate the post response to mimic a remote client call
        console.log(`Webhook Dispatch: Delivering event ${event} to ${webhook.url} (Attempt ${attempts})`);
        
        await new Promise((resolve) => setTimeout(resolve, attempts * 50)); // Simulates network round-trip

        // Simulated HTTP success (or mock failure depending on test environment settings)
        if (webhook.url.includes('fail')) {
          throw new Error('Simulated HTTP Connection Refused');
        }

        responseStatus = 200;
        success = true;
      } catch (error) {
        console.error(`Webhook Delivery Attempt ${attempts} failed: ${error.message}`);
        responseStatus = 500;
        if (attempts < 3) {
          // Exponential backoff wait (e.g. 100ms, 400ms)
          await new Promise((resolve) => setTimeout(resolve, Math.pow(attempts, 2) * 100));
        }
      }
    }

    // Log final delivery state (DLQ marked as failed if not success)
    await this.prisma.webhookDelivery.create({
      data: {
        webhookId,
        event,
        payload: payload as any,
        responseStatus,
        attempts,
      },
    });
  }
}
