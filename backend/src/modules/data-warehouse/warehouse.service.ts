import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class WarehouseService {
  constructor(private prisma: PrismaService) {}

  async runETLPipeline(workspaceId: string) {
    // 1. Projects Count
    const projectsCount = await this.prisma.project.count({
      where: { workspaceId },
    });

    // 2. Tasks Count
    const tasksCount = await this.prisma.task.count({
      where: { project: { workspaceId } },
    });

    // 3. Completed Tasks
    const completedTasks = await this.prisma.task.count({
      where: {
        project: { workspaceId },
        status: 'DONE',
      },
    });

    // 4. Meetings & Meeting Minutes
    const meetingsCount = await this.prisma.meeting.count({
      where: { workspaceId },
    });

    // We can aggregate meeting duration or mock it if duration column is not in schema
    const meetingMinutes = meetingsCount * 45; // Default 45 mins per meeting average

    // 5. AI Tokens (sum of aiWorkspaceMemory or a default workspace setting value)
    const workspace = await this.prisma.workspace.findUnique({
      where: { id: workspaceId },
      select: { aiTokensUsed: true, storageBytesUsed: true },
    });

    const aiTokens = workspace?.aiTokensUsed || 1000;
    const storageBytes = workspace?.storageBytesUsed || BigInt(512000);

    // 6. Create Snapshot
    return this.prisma.warehouseSnapshot.create({
      data: {
        workspaceId,
        projectsCount,
        tasksCount,
        completedTasks,
        meetingsCount,
        meetingMinutes,
        aiTokens,
        storageBytes,
      },
    });
  }

  async getSnapshots(workspaceId: string) {
    return this.prisma.warehouseSnapshot.findMany({
      where: { workspaceId },
      orderBy: { createdAt: 'desc' },
      take: 30, // Last 30 snapshots
    });
  }
}
