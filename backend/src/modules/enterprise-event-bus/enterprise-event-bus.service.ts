import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class EnterpriseEventBusService {
  constructor(private readonly prisma: PrismaService) {}

  async registerSchema(workspaceId: string, eventName: string, schemaJson: string, version: number) {
    return this.prisma.enterpriseEventSchema.create({
      data: {
        workspaceId,
        eventName,
        schemaJson,
        version,
        isActive: true,
      },
    });
  }

  async publish(workspaceId: string, name: string, payload: any, userId?: string, parentId?: string) {
    // Validate schema if registered
    const schema = await this.prisma.enterpriseEventSchema.findFirst({
      where: { workspaceId, eventName: name, isActive: true },
      orderBy: { version: 'desc' },
    });

    if (schema) {
      console.log(`[EventBus] Validating schema version ${schema.version} for event ${name}`);
      // Simple validation mock
      try {
        const parsedSchema = JSON.parse(schema.schemaJson);
        const keys = Object.keys(parsedSchema);
        for (const key of keys) {
          if (parsedSchema[key].required && payload[key] === undefined) {
            throw new Error(`Missing required field: ${key}`);
          }
        }
      } catch (err) {
        throw new Error(`Schema validation failed for event ${name}: ${err.message}`);
      }
    }

    const payloadStr = JSON.stringify(payload);
    
    // Determine source
    let source = 'AI';
    if (name.startsWith('Task') || name.startsWith('Project')) {
      source = 'DEVOPS';
    } else if (name.startsWith('Invoice') || name.startsWith('Payment')) {
      source = 'FINANCE';
    } else if (name.startsWith('Employee')) {
      source = 'HRMS';
    } else if (name.startsWith('Lead') || name.startsWith('Opportunity')) {
      source = 'CRM';
    }

    const event = await this.prisma.enterpriseEvent.create({
      data: {
        workspaceId,
        name,
        source,
        payload: payloadStr,
        userId,
      },
    });

    // Record Event Lineage if parent exists
    if (parentId) {
      const parentLineage = await this.prisma.eventLineage.findFirst({
        where: { eventId: parentId },
      });

      await this.prisma.eventLineage.create({
        data: {
          workspaceId,
          eventId: event.id,
          parentId,
          rootId: parentLineage ? parentLineage.rootId : parentId,
          depth: parentLineage ? parentLineage.depth + 1 : 1,
        },
      });
    } else {
      await this.prisma.eventLineage.create({
        data: {
          workspaceId,
          eventId: event.id,
          parentId: null,
          rootId: event.id,
          depth: 0,
        },
      });
    }

    // Trigger consumers asynchronously (simulated)
    const consumers = await this.prisma.enterpriseEventConsumer.findMany({
      where: { workspaceId, status: 'ACTIVE' },
    });

    for (const consumer of consumers) {
      console.log(`[EventBus] Triggering consumer ${consumer.name} at: ${consumer.endpoint}`);
    }

    return event;
  }

  async getEventLineage(eventId: string) {
    return this.prisma.eventLineage.findMany({
      where: { eventId },
    });
  }

  async registerConsumer(workspaceId: string, name: string, endpoint: string, version: number) {
    return this.prisma.enterpriseEventConsumer.create({
      data: {
        workspaceId,
        name,
        endpoint,
        version,
        status: 'ACTIVE',
      },
    });
  }

  async getRetentionPolicies(workspaceId: string) {
    return this.prisma.eventRetentionPolicy.findMany({
      where: { workspaceId },
    });
  }

  async configureRetentionPolicy(workspaceId: string, eventName: string, retentionDays: number, action: string) {
    return this.prisma.eventRetentionPolicy.create({
      data: {
        workspaceId,
        eventName,
        retentionDays,
        action,
      },
    });
  }

  async replayEvents(workspaceId: string, start: Date, end: Date, eventName?: string) {
    const events = await this.prisma.enterpriseEvent.findMany({
      where: {
        workspaceId,
        timestamp: {
          gte: start,
          lte: end,
        },
        ...(eventName ? { name: eventName } : {}),
      },
      orderBy: { timestamp: 'asc' },
    });

    for (const e of events) {
      console.log(`[EventBus] Replaying event: ${e.name} (${e.id})`);
      // Simulate republishing to subscribers
    }
    return events;
  }
}
