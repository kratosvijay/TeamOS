import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class StudioService {
  constructor(private prisma: PrismaService) {}

  async createEntity(workspaceId: string, applicationId: string, name: string, description?: string) {
    return this.prisma.applicationEntity.create({
      data: { workspaceId, applicationId, name, description },
    });
  }

  async createField(workspaceId: string, entityId: string, name: string, type: string, constraints = '{}') {
    return this.prisma.applicationField.create({
      data: { workspaceId, entityId, name, type, constraints },
    });
  }

  async defineRelationship(workspaceId: string, applicationId: string, fromEntityId: string, toEntityId: string, type: string, configJson = '{}') {
    return this.prisma.applicationRelationship.create({
      data: { workspaceId, applicationId, fromEntityId, toEntityId, type, configJson },
    });
  }

  async addValidationRule(workspaceId: string, entityId: string, fieldName: string, ruleType: string, ruleConfig = '{}') {
    return this.prisma.applicationValidationRule.create({
      data: { workspaceId, entityId, fieldName, ruleType, ruleConfig },
    });
  }

  async saveFormDefinition(workspaceId: string, applicationId: string, name: string, layoutJson = '{}') {
    return this.prisma.formDefinition.create({
      data: { workspaceId, applicationId, name, layoutJson },
    });
  }

  async saveDashboardDefinition(workspaceId: string, applicationId: string, name: string, layoutSchema = '{}') {
    return this.prisma.dashboardDefinition.create({
      data: { workspaceId, applicationId, name, layoutSchema },
    });
  }

  async defineVisualQuery(workspaceId: string, applicationId: string, name: string, projections = '[]') {
    return this.prisma.visualQueryDefinition.create({
      data: { workspaceId, applicationId, name, projections },
    });
  }

  async getStudioDashboard(workspaceId: string, applicationId: string) {
    const [entities, forms, dashboards, queries] = await Promise.all([
      this.prisma.applicationEntity.findMany({ where: { workspaceId, applicationId } }),
      this.prisma.formDefinition.findMany({ where: { workspaceId, applicationId } }),
      this.prisma.dashboardDefinition.findMany({ where: { workspaceId, applicationId } }),
      this.prisma.visualQueryDefinition.findMany({ where: { workspaceId, applicationId } }),
    ]);
    return { entities, forms, dashboards, queries };
  }
}
