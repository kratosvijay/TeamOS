import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class QueryPlannerService {
  constructor(private readonly prisma: PrismaService) {}

  async generateQueryPlan(workspaceId: string, queryString: string, sources: string[]) {
    const planJson = JSON.stringify({
      optimizedQuery: queryString,
      executionNodes: sources.map((src, index) => ({
        nodeId: `node_${index}`,
        source: src,
        type: 'SCAN',
        costEstimate: 10 + index * 5,
      })),
      planningTimeMs: 4,
    });

    const plan = await this.prisma.virtualQueryPlan.create({
      data: {
        workspaceId,
        queryString,
        planJson,
      },
    });

    for (let i = 0; i < sources.length; i++) {
      await this.prisma.queryExecutionNode.create({
        data: {
          workspaceId,
          planId: plan.id,
          nodeType: 'SCAN',
          durationMs: 15 + i * 10,
        },
      });
    }

    return plan;
  }
}
