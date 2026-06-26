import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class DigitalTwinService {
  constructor(private readonly prisma: PrismaService) {}

  async getLiveTwinState(workspaceId: string) {
    const twin = await this.prisma.digitalTwin.findFirst({
      where: { workspaceId },
      orderBy: { updatedAt: 'desc' },
    });

    if (!twin) {
      return this.prisma.digitalTwin.create({
        data: {
          workspaceId,
          name: 'Primary Enterprise Digital Twin',
          description: 'Live virtual replica of the TeamOS organizational infrastructure',
          status: 'SYNCHRONIZED',
        },
      });
    }
    return twin;
  }

  async createSnapshot(workspaceId: string) {
    const twin = await this.getLiveTwinState(workspaceId);
    
    const mockMetrics = {
      activeUsers: Math.floor(Math.random() * 200) + 50,
      activeProjects: Math.floor(Math.random() * 15) + 5,
      apiLatencyP95: Math.floor(Math.random() * 80) + 20,
      cpuUtilization: Math.floor(Math.random() * 40) + 10,
      queueDelaySeconds: Math.random() * 2.5,
      activeAgents: Math.floor(Math.random() * 10) + 3,
    };

    const mockState = {
      nodes: [
        { id: 'marketing', type: 'Department', status: 'ACTIVE' },
        { id: 'engineering', type: 'Department', status: 'ACTIVE' },
        { id: 'sales', type: 'Department', status: 'ACTIVE' },
        { id: 'primary-erp', type: 'ERP_Module', status: 'ONLINE' },
        { id: 'ai-coordinator', type: 'Agent', status: 'RUNNING' },
      ],
      edges: [
        { source: 'marketing', target: 'primary-erp', label: 'Telemetry' },
        { source: 'engineering', target: 'primary-erp', label: 'Telemetry' },
        { source: 'ai-coordinator', target: 'engineering', label: 'Coordinating' },
      ]
    };

    return this.prisma.digitalTwinSnapshot.create({
      data: {
        twinId: twin.id,
        workspaceId,
        metricsJson: JSON.stringify(mockMetrics),
        stateJson: JSON.stringify(mockState),
      },
    });
  }

  async getSnapshots(workspaceId: string) {
    return this.prisma.digitalTwinSnapshot.findMany({
      where: { workspaceId },
      orderBy: { recordedAt: 'desc' },
      take: 20,
    });
  }

  async playbackHistory(workspaceId: string, start: Date, end: Date) {
    // Enterprise Time Machine playback logic
    const snapshots = await this.prisma.digitalTwinSnapshot.findMany({
      where: {
        workspaceId,
        recordedAt: {
          gte: start,
          lte: end,
        },
      },
      orderBy: { recordedAt: 'asc' },
    });

    const events = await this.prisma.enterpriseEvent.findMany({
      where: {
        workspaceId,
        timestamp: {
          gte: start,
          lte: end,
        },
      },
      orderBy: { timestamp: 'asc' },
    });

    // Create session
    const session = await this.prisma.replaySession.create({
      data: {
        workspaceId,
        status: 'PLAYING',
        startTimestamp: start,
        endTimestamp: end,
        currentTimestamp: start,
      },
    });

    return {
      sessionId: session.id,
      timelinePoints: snapshots.map((s) => ({
        timestamp: s.recordedAt,
        metrics: JSON.parse(s.metricsJson),
        state: JSON.parse(s.stateJson),
      })),
      interleavedEvents: events.map((e) => ({
        id: e.id,
        name: e.name,
        source: e.source,
        payload: JSON.parse(e.payload),
        timestamp: e.timestamp,
      })),
    };
  }
}
