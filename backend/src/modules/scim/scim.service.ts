import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class SCIMService {
  constructor(private prisma: PrismaService) {}

  async configureSCIM(workspaceId: string, provider: string, accessToken: string) {
    return this.prisma.sCIMProvisioning.create({
      data: {
        workspaceId,
        provider,
        accessToken,
        enabled: true,
      },
    });
  }

  async createSCIMUser(workspaceId: string, email: string, fullName: string) {
    let user = await this.prisma.user.findUnique({
      where: { email },
    });

    if (!user) {
      user = await this.prisma.user.create({
        data: {
          email,
          fullName,
        },
      });
    }

    // Add user to workspace member registry
    const member = await this.prisma.workspaceMember.findUnique({
      where: {
        workspaceId_userId: {
          workspaceId,
          userId: user.id,
        },
      },
    });

    if (!member) {
      await this.prisma.workspaceMember.create({
        data: {
          workspaceId,
          userId: user.id,
          role: 'DEVELOPER',
          status: 'ACTIVE',
        },
      });
    } else if (member.status !== 'ACTIVE') {
      await this.prisma.workspaceMember.update({
        where: { id: member.id },
        data: { status: 'ACTIVE' },
      });
    }

    return user;
  }

  async updateSCIMUser(userId: string, email?: string, fullName?: string) {
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
    });
    if (!user) {
      throw new NotFoundException(`User with ID ${userId} not found`);
    }

    return this.prisma.user.update({
      where: { id: userId },
      data: {
        email: email || undefined,
        fullName: fullName || undefined,
      },
    });
  }

  async disableSCIMUser(workspaceId: string, userId: string) {
    const member = await this.prisma.workspaceMember.findUnique({
      where: {
        workspaceId_userId: {
          workspaceId,
          userId,
        },
      },
    });

    if (!member) {
      throw new NotFoundException(`User with ID ${userId} is not a member of workspace ${workspaceId}`);
    }

    // Disable workspace membership by setting status to SUSPENDED
    return this.prisma.workspaceMember.update({
      where: { id: member.id },
      data: { status: 'SUSPENDED' },
    });
  }
}
