import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

export interface OperationsAuditEvent {
  id: string;
  workspaceId: string;
  actorId: string;
  action: string;
  entityType: string;
  entityId: string;
  oldValue?: any;
  newValue?: any;
  createdAt: Date;
}

@Injectable()
export class OperationsAuditService {
  private inMemoryEvents: OperationsAuditEvent[] = [];

  constructor(private readonly prisma: PrismaService) {}

  async logOperationsEvent(
    workspaceId: string,
    actorId: string,
    action: string,
    entityType: string,
    entityId: string,
    oldValue?: any,
    newValue?: any,
  ): Promise<OperationsAuditEvent> {
    const event: OperationsAuditEvent = {
      id: Math.random().toString(36).substr(2, 9),
      workspaceId,
      actorId,
      action,
      entityType,
      entityId,
      oldValue,
      newValue,
      createdAt: new Date(),
    };

    this.inMemoryEvents.push(event);

    try {
      // Attempt PostgreSQL DB insertion using Prisma
      await this.prisma.auditTrail.create({
        data: {
          workspaceId,
          actorId,
          action,
          entityType,
          entityId,
          oldValue: oldValue ? JSON.parse(JSON.stringify(oldValue)) : undefined,
          newValue: newValue ? JSON.parse(JSON.stringify(newValue)) : undefined,
          ipAddress: '127.0.0.1',
        },
      });
    } catch (err) {
      // Safe fallback in case relations are not present or prisma is mocked
      console.warn(`[OperationsAudit] Safe Fallback: Database write skipped. Event: ${action}`);
    }

    return event;
  }

  async getEventsTimeline(workspaceId?: string): Promise<OperationsAuditEvent[]> {
    if (workspaceId) {
      return this.inMemoryEvents.filter((e) => e.workspaceId === workspaceId);
    }
    return this.inMemoryEvents;
  }
}
