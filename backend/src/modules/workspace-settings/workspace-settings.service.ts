import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { WorkspaceRole } from '@prisma/client';

@Injectable()
export class WorkspaceSettingsService {
  constructor(private prisma: PrismaService) {}

  async getSettings(workspaceId: string) {
    const settings = await this.prisma.workspaceSettings.findUnique({
      where: { workspaceId },
    });
    if (!settings) {
      throw new NotFoundException('Workspace settings not found');
    }
    return settings;
  }

  async updateSettings(
    workspaceId: string,
    data: {
      allowGuestUsers?: boolean;
      allowPublicProjects?: boolean;
      defaultRole?: WorkspaceRole;
      enableMeetings?: boolean;
      enableDocuments?: boolean;
      enableAI?: boolean;
      enableChat?: boolean;
    },
  ) {
    return this.prisma.workspaceSettings.update({
      where: { workspaceId },
      data,
    });
  }
}
