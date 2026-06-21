import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class CustomDashboardService {
  constructor(private prisma: PrismaService) {}

  async createDashboard(workspaceId: string, name: string, widgets: any) {
    return this.prisma.dashboard.create({
      data: {
        workspaceId,
        name,
        widgets: JSON.parse(JSON.stringify(widgets)),
      },
    });
  }

  async updateDashboard(id: string, name?: string, widgets?: any) {
    return this.prisma.dashboard.update({
      where: { id },
      data: {
        name: name || undefined,
        widgets: widgets ? JSON.parse(JSON.stringify(widgets)) : undefined,
      },
    });
  }

  async getDashboards(workspaceId: string) {
    return this.prisma.dashboard.findMany({
      where: { workspaceId },
      orderBy: { createdAt: 'desc' },
    });
  }

  async deleteDashboard(id: string) {
    return this.prisma.dashboard.delete({
      where: { id },
    });
  }
}
