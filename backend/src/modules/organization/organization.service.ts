import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class OrganizationService {
  constructor(private prisma: PrismaService) {}

  async createOrganization(name: string, domain?: string) {
    return this.prisma.organization.create({
      data: { name, domain },
    });
  }

  async getOrganization(id: string) {
    const org = await this.prisma.organization.findUnique({
      where: { id },
      include: {
        workspaces: true,
        departments: true,
      },
    });
    if (!org) {
      throw new NotFoundException(`Organization with ID ${id} not found`);
    }
    return org;
  }

  async updateOrganization(id: string, name: string, domain?: string) {
    return this.prisma.organization.update({
      where: { id },
      data: { name, domain },
    });
  }

  async addWorkspaceToOrganization(orgId: string, workspaceId: string) {
    return this.prisma.workspace.update({
      where: { id: workspaceId },
      data: { organizationId: orgId },
    });
  }

  async getWorkspaces(orgId: string) {
    return this.prisma.workspace.findMany({
      where: { organizationId: orgId },
    });
  }

  async createDepartment(orgId: string, name: string, managerId?: string) {
    return this.prisma.department.create({
      data: {
        organizationId: orgId,
        name,
        managerId,
      },
    });
  }

  async getDepartments(orgId: string) {
    return this.prisma.department.findMany({
      where: { organizationId: orgId },
    });
  }

  async updateDepartment(depId: string, name: string, managerId?: string) {
    return this.prisma.department.update({
      where: { id: depId },
      data: { name, managerId },
    });
  }

  async deleteDepartment(depId: string) {
    return this.prisma.department.delete({
      where: { id: depId },
    });
  }
}
