import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class DataGovernanceService {
  constructor(private readonly prisma: PrismaService) {}

  async createDomain(workspaceId: string, name: string, description?: string) {
    return this.prisma.dataDomain.create({
      data: {
        workspaceId,
        name,
        description,
      },
    });
  }

  async catalogTable(workspaceId: string, tableName: string, schemaJson: string) {
    return this.prisma.dataCatalog.create({
      data: {
        workspaceId,
        tableName,
        schemaJson,
      },
    });
  }

  async addClassification(workspaceId: string, targetPath: string, sensitivity: string) {
    return this.prisma.dataClassification.create({
      data: {
        workspaceId,
        targetPath,
        sensitivity,
      },
    });
  }

  async addGlossaryTerm(workspaceId: string, term: string, definition: string) {
    return this.prisma.businessGlossary.create({
      data: {
        workspaceId,
        term,
        definition,
      },
    });
  }

  async recordLineage(workspaceId: string, sourcePath: string, targetPath: string, transformRule?: string) {
    return this.prisma.dataLineage.create({
      data: {
        workspaceId,
        sourcePath,
        targetPath,
        transformRule,
      },
    });
  }

  async createSteward(workspaceId: string, userId: string, roleName: string) {
    return this.prisma.dataSteward.create({
      data: {
        workspaceId,
        userId,
        roleName,
      },
    });
  }
}
