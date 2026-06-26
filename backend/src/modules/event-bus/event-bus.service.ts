import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

export interface TeamOSEvent {
  id: string;
  name: 'TaskCreated' | 'TaskUpdated' | 'ProjectCreated' | 'MeetingEnded' | 'WorkflowCompleted' | 'InvoicePaid' | 'TicketResolved' | 'EmployeeCreated' | string;
  workspaceId: string;
  payload: any;
  createdAt: Date;
}

@Injectable()
export class EventBusService {
  private eventHistory: TeamOSEvent[] = [];
  private dlq: { event: TeamOSEvent; error: string; failedAt: Date }[] = [];

  constructor(private readonly prisma: PrismaService) {}

  async publish(name: string, workspaceId: string, payload: any) {
    const event: TeamOSEvent = {
      id: Math.random().toString(36).substring(2, 9),
      name,
      workspaceId,
      payload,
      createdAt: new Date(),
    };

    this.eventHistory.push(event);

    const subs = await this.prisma.eventSubscription.findMany({
      where: { workspaceId, eventName: name, active: true },
    });

    for (const sub of subs) {
      try {
        console.log(`[EventBus] Dispatching ${name} event to: ${sub.targetUrl}`);
        if (sub.targetUrl.includes('fail')) {
          throw new Error('Simulated HTTP connection timeout');
        }
      } catch (err) {
        console.error(`[EventBus] Failed to deliver ${name} to ${sub.targetUrl}: ${err.message}. Sent to DLQ.`);
        this.dlq.push({ event, error: err.message, failedAt: new Date() });
      }
    }

    return event;
  }

  async subscribe(workspaceId: string, eventName: string, targetUrl: string) {
    return this.prisma.eventSubscription.create({
      data: {
        workspaceId,
        eventName,
        targetUrl,
        active: true,
      },
    });
  }

  async replay(workspaceId: string, eventName?: string) {
    const filtered = this.eventHistory.filter(
      (e) => e.workspaceId === workspaceId && (!eventName || e.name === eventName),
    );

    for (const event of filtered) {
      await this.publish(event.name, event.workspaceId, event.payload);
    }
    return filtered;
  }

  getHistory(workspaceId: string) {
    return this.eventHistory.filter((e) => e.workspaceId === workspaceId);
  }

  getDlq() {
    return this.dlq;
  }
}
