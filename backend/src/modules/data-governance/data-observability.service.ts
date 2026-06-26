import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class DataObservabilityService {
  constructor(private readonly prisma: PrismaService) {}

  async recordMetric(workspaceId: string, metricType: string, value: number) {
    return this.prisma.dataObservabilityMetric.create({
      data: {
        workspaceId,
        metricType,
        value,
      },
    });
  }

  async detectAnomalies(workspaceId: string, metricType: string) {
    const metrics = await this.prisma.dataObservabilityMetric.findMany({
      where: { workspaceId, metricType },
      orderBy: { recordedAt: 'desc' },
      take: 20,
    });

    if (metrics.length < 5) return { anomaly: false };

    const avg = metrics.reduce((sum, m) => sum + m.value, 0) / metrics.length;
    const latest = metrics[0].value;

    // mock anomaly if latest value differs by more than 50% from average
    const deviation = Math.abs(latest - avg) / avg;
    const anomaly = deviation > 0.5;

    return {
      anomaly,
      latestValue: latest,
      averageValue: avg,
      deviationPercentage: deviation * 100,
    };
  }
}
