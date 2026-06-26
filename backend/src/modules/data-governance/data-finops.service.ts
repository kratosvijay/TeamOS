import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class DataFinopsService {
  constructor(private readonly prisma: PrismaService) {}

  async logStorageCost(workspaceId: string, domainName: string, cost: number) {
    return this.prisma.storageCost.create({
      data: {
        workspaceId,
        domainName,
        cost,
      },
    });
  }

  async logComputeCost(workspaceId: string, jobName: string, cost: number) {
    return this.prisma.computeCost.create({
      data: {
        workspaceId,
        jobName,
        cost,
      },
    });
  }

  async logPipelineCost(workspaceId: string, pipelineId: string, cost: number) {
    return this.prisma.pipelineCost.create({
      data: {
        workspaceId,
        pipelineId,
        cost,
      },
    });
  }

  async getDomainCostReport(workspaceId: string, domainName: string) {
    const storageCosts = await this.prisma.storageCost.findMany({
      where: { workspaceId, domainName },
    });
    const computeCosts = await this.prisma.computeCost.findMany({
      where: { workspaceId, jobName: { contains: domainName } },
    });

    const totalStorage = storageCosts.reduce((sum, item) => sum + item.cost, 0);
    const totalCompute = computeCosts.reduce((sum, item) => sum + item.cost, 0);

    return {
      domainName,
      totalStorageCost: totalStorage,
      totalComputeCost: totalCompute,
      totalCombinedCost: totalStorage + totalCompute,
    };
  }
}
