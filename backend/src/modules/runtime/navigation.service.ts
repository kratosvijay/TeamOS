import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class NavigationService {
  constructor(private prisma: PrismaService) {}

  async getNavigationSchema(workspaceId: string, applicationId: string) {
    const nav = await this.prisma.applicationNavigation.findFirst({
      where: { workspaceId, applicationId },
    });
    if (!nav) return { menus: [], sidebars: [], tabs: [] };

    return JSON.parse(nav.structureJson);
  }

  async setNavigationSchema(workspaceId: string, applicationId: string, structureJson: string) {
    const existing = await this.prisma.applicationNavigation.findFirst({
      where: { workspaceId, applicationId },
    });

    if (existing) {
      return this.prisma.applicationNavigation.update({
        where: { id: existing.id },
        data: { structureJson },
      });
    }

    return this.prisma.applicationNavigation.create({
      data: { workspaceId, applicationId, structureJson },
    });
  }
}
