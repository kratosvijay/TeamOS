import { Injectable, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { WorkspaceRole } from '@prisma/client';

@Injectable()
export class WorkspaceService {
  constructor(private prisma: PrismaService) {}

  async createWorkspace(userId: string, name: string, slug: string, logoUrl?: string) {
    const existing = await this.prisma.workspace.findUnique({ where: { slug } });
    if (existing) {
      throw new BadRequestException('Workspace slug already in use');
    }

    return this.prisma.$transaction(async (tx) => {
      // Create workspace
      const workspace = await tx.workspace.create({
        data: {
          name,
          slug,
          logoUrl,
          ownerId: userId,
        },
      });

      // Add owner member
      await tx.workspaceMember.create({
        data: {
          workspaceId: workspace.id,
          userId,
          role: WorkspaceRole.OWNER,
          status: 'ACTIVE',
        },
      });

      // Create default WorkspaceSettings
      await tx.workspaceSettings.create({
        data: {
          workspaceId: workspace.id,
        },
      });

      // Initialize presence record for owner in this workspace
      await tx.userPresence.create({
        data: {
          userId,
          workspaceId: workspace.id,
          status: 'ONLINE',
        },
      });

      return workspace;
    });
  }

  async listUserWorkspaces(userId: string) {
    const memberships = await this.prisma.workspaceMember.findMany({
      where: { userId },
      include: {
        workspace: true,
      },
    });
    return memberships.map((m) => ({
      workspace: m.workspace,
      role: m.role,
      status: m.status,
    }));
  }

  async inviteMember(workspaceId: string, email: string, role: WorkspaceRole) {
    // Generate an invitation token
    const token = Math.random().toString(36).substring(2, 15);
    const expiresAt = new Date();
    expiresAt.setDate(expiresAt.getDate() + 7); // Expires in 7 days

    return this.prisma.invitation.create({
      data: {
        workspaceId,
        email,
        role,
        token,
        expiresAt,
      },
    });
  }

  async listMembers(workspaceId: string) {
    return this.prisma.workspaceMember.findMany({
      where: { workspaceId },
      include: {
        user: {
          select: { id: true, fullName: true, email: true, avatarUrl: true },
        },
      },
    });
  }
}
