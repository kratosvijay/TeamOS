import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class CanonicalMappingService {
  constructor(private readonly prisma: PrismaService) {}

  async createCanonicalEntity(workspaceId: string, entityName: string, definition: string) {
    return this.prisma.canonicalEntity.create({
      data: {
        workspaceId,
        entityName,
        definition,
      },
    });
  }

  async createMapping(workspaceId: string, canonicalId: string, externalSource: string, mappingJson: string) {
    return this.prisma.canonicalMapping.create({
      data: {
        workspaceId,
        canonicalId,
        externalSource,
        mappingJson,
      },
    });
  }

  async addTransformationRule(workspaceId: string, name: string, formula: string) {
    return this.prisma.transformationRule.create({
      data: {
        workspaceId,
        name,
        formula,
      },
    });
  }

  async registerSchema(workspaceId: string, name: string) {
    return this.prisma.schemaRegistry.create({
      data: {
        workspaceId,
        name,
        status: 'ACTIVE',
      },
    });
  }

  async addSchemaVersion(workspaceId: string, registryId: string, version: string, schemaJson: string) {
    return this.prisma.schemaVersion.create({
      data: {
        workspaceId,
        registryId,
        version,
        schemaJson,
      },
    });
  }
}
