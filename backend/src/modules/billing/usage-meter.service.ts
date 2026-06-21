import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class UsageMeterService {
  constructor(private readonly prisma: PrismaService) {}

  async incrementAITokens(workspaceId: string, tokens: number): Promise<void> {
    await this.prisma.workspace.update({
      where: { id: workspaceId },
      data: {
        aiTokensUsed: { increment: tokens },
      },
    });
  }

  async incrementStorage(workspaceId: string, bytes: number): Promise<void> {
    await this.prisma.workspace.update({
      where: { id: workspaceId },
      data: {
        storageBytesUsed: { increment: bytes },
      },
    });
  }

  async decrementStorage(workspaceId: string, bytes: number): Promise<void> {
    const workspace = await this.prisma.workspace.findUnique({
      where: { id: workspaceId },
      select: { storageBytesUsed: true },
    });

    const current = Number(workspace?.storageBytesUsed || 0);
    const target = Math.max(0, current - bytes);

    await this.prisma.workspace.update({
      where: { id: workspaceId },
      data: {
        storageBytesUsed: BigInt(target),
      },
    });
  }

  async createHourlySnapshots(): Promise<void> {
    const workspaces = await this.prisma.workspace.findMany({
      select: { id: true, aiTokensUsed: true, storageBytesUsed: true },
    });

    for (const workspace of workspaces) {
      const usersCount = await this.prisma.workspaceSeat.count({
        where: { workspaceId: workspace.id, status: 'ASSIGNED' },
      });

      const projectsCount = await this.prisma.project.count({
        where: { workspaceId: workspace.id },
      });

      const documentsCount = await this.prisma.document.count({
        where: { workspaceId: workspace.id },
      });

      // Sum meeting durations (mocking meeting minutes to fetch from meetings table if exists)
      const meetingsCount = await this.prisma.meeting.count({
        where: { workspaceId: workspace.id },
      });
      const meetingMinutes = meetingsCount * 45; // Assumed average 45 mins

      await this.prisma.usageSnapshot.create({
        data: {
          workspaceId: workspace.id,
          usersCount,
          projectsCount,
          storageBytes: workspace.storageBytesUsed,
          aiTokens: workspace.aiTokensUsed,
          meetingMinutes,
        },
      });
    }
  }
}
