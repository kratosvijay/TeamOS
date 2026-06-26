import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class IntegrationAnalyticsService {
  constructor(private readonly prisma: PrismaService) {}

  async logMetric(workspaceId: string, connectorId: string, latencyMs: number, throughput: number, errorRate: number) {
    return this.prisma.connectorMetric.create({
      data: {
        workspaceId,
        connectorId,
        latencyMs,
        throughput,
        errorRate,
      },
    });
  }

  async configureSla(workspaceId: string, name: string, latencyMs: number, throughput: number) {
    return this.prisma.integrationSla.create({
      data: {
        workspaceId,
        name,
        latencyMs,
        throughput,
      },
    });
  }

  async checkSlaCompliance(workspaceId: string, connectorId: string, slaId: string) {
    const sla = await this.prisma.integrationSla.findUnique({
      where: { id: slaId },
    });
    const latestMetrics = await this.prisma.connectorMetric.findMany({
      where: { workspaceId, connectorId },
      orderBy: { recordedAt: 'desc' },
      take: 10,
    });

    if (!sla || latestMetrics.length === 0) return { compliant: true };

    const avgLatency = latestMetrics.reduce((sum, m) => sum + m.latencyMs, 0) / latestMetrics.length;
    const avgThroughput = latestMetrics.reduce((sum, m) => sum + m.throughput, 0) / latestMetrics.length;

    const compliant = avgLatency <= sla.latencyMs && avgThroughput >= sla.throughput;

    return {
      compliant,
      avgLatency,
      avgThroughput,
      slaLatencyLimit: sla.latencyMs,
      slaThroughputLimit: sla.throughput,
    };
  }
}
