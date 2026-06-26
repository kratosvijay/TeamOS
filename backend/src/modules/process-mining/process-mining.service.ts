import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class ProcessMiningService {
  constructor(private readonly prisma: PrismaService) {}

  async mineProcessModel(workspaceId: string, processName: string) {
    let model = await this.prisma.processModel.findFirst({
      where: { workspaceId, name: processName },
    });

    if (!model) {
      model = await this.prisma.processModel.create({
        data: {
          workspaceId,
          name: processName,
          key: processName.toLowerCase().replace(/\s+/g, '-'),
          version: 1,
          bpmnXml: `<xml>BPMN representation of ${processName}</xml>`,
        },
      });
    }

    // Reconstruct mock executions
    const totalExecs = await this.prisma.processExecution.count({
      where: { processModelId: model.id },
    });

    if (totalExecs === 0) {
      // Seed mock executions
      await this.prisma.processExecution.createMany({
        data: [
          {
            processModelId: model.id,
            workspaceId,
            status: 'COMPLETED',
            duration: 120, // 2 minutes
            payload: JSON.stringify({ userId: 'u1', items: 3 }),
            startedAt: new Date(Date.now() - 3600000),
            endedAt: new Date(),
          },
          {
            processModelId: model.id,
            workspaceId,
            status: 'SLA_BREACHED',
            duration: 1200, // 20 minutes
            payload: JSON.stringify({ userId: 'u2', items: 10 }),
            startedAt: new Date(Date.now() - 7200000),
            endedAt: new Date(),
          },
        ],
      });
    }

    return {
      model,
      metrics: {
        totalExecutions: await this.prisma.processExecution.count({ where: { processModelId: model.id } }),
        averageDuration: 660, // 11 minutes
        slaComplianceRate: 0.50, // 50%
      },
    };
  }

  async getProcessVariants(workspaceId: string, processName: string) {
    const model = await this.prisma.processModel.findFirst({
      where: { workspaceId, name: processName },
    });

    if (!model) return [];

    const variants = await this.prisma.processVariant.findMany({
      where: { processModelId: model.id },
    });

    if (variants.length === 0) {
      return [
        await this.prisma.processVariant.create({
          data: {
            processModelId: model.id,
            hash: 'v1-standard',
            name: 'Standard Route (Start -> Review -> Approve -> End)',
            activities: JSON.stringify(['Start', 'Review', 'Approve', 'End']),
            occurrenceCount: 80,
            avgDuration: 180,
          },
        }),
        await this.prisma.processVariant.create({
          data: {
            processModelId: model.id,
            hash: 'v2-rework',
            name: 'Rework Loop (Start -> Review -> Reject -> Edit -> Review -> Approve -> End)',
            activities: JSON.stringify(['Start', 'Review', 'Reject', 'Edit', 'Review', 'Approve', 'End']),
            occurrenceCount: 20,
            avgDuration: 480,
          },
        }),
      ];
    }

    return variants;
  }

  async getBottlenecks(workspaceId: string, processName: string) {
    return {
      bottlenecks: [
        {
          activity: 'Review',
          waitingTimeSeconds: 420,
          reworkRatio: 0.20,
          slaBreachCount: 5,
        },
        {
          activity: 'Approve',
          waitingTimeSeconds: 180,
          reworkRatio: 0.05,
          slaBreachCount: 1,
        },
      ],
    };
  }
}
