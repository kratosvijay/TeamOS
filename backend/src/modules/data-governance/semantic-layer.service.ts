import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class SemanticLayerService {
  constructor(private readonly prisma: PrismaService) {}

  async createSemanticModel(workspaceId: string, name: string, mappingJson: string) {
    return this.prisma.semanticModel.create({
      data: {
        workspaceId,
        name,
        mappingJson,
      },
    });
  }

  async defineMetric(workspaceId: string, name: string, formula: string, dimensionId?: string) {
    return this.prisma.businessMetric.create({
      data: {
        workspaceId,
        name,
        formula,
        dimensionId,
      },
    });
  }

  async defineDimension(workspaceId: string, name: string, columnPath: string) {
    return this.prisma.dimension.create({
      data: {
        workspaceId,
        name,
        columnPath,
      },
    });
  }

  async defineMeasure(workspaceId: string, name: string, formula: string) {
    return this.prisma.measure.create({
      data: {
        workspaceId,
        name,
        formula,
      },
    });
  }
}
