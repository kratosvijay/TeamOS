import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class RuntimeDebuggerService {
  constructor(private prisma: PrismaService) {}

  async traceExecution(workspaceId: string, applicationId: string, sessionId: string, stepName: string, durationMs: number, errorMsg?: string) {
    return this.prisma.applicationAnalytics.create({
      data: {
        workspaceId,
        applicationId,
        sessionId,
        latencyMs: durationMs,
        errorCount: errorMsg ? 1 : 0,
        detailsJson: JSON.stringify({
          step: stepName,
          error: errorMsg || null,
          timestamp: new Date().toISOString(),
        }),
      },
    });
  }

  async getTraceLogs(workspaceId: string, applicationId: string, limit = 50) {
    return this.prisma.applicationAnalytics.findMany({
      where: { workspaceId, applicationId },
      orderBy: { createdAt: 'desc' },
      take: limit,
    });
  }
}
