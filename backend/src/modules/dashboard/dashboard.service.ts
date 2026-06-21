import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { PresenceStatus } from '@prisma/client';

@Injectable()
export class DashboardService {
  constructor(private prisma: PrismaService) {}

  async getOverview(workspaceId: string, userId: string) {
    const activeProjects = await this.prisma.project.count({
      where: { workspaceId, status: 'ACTIVE' },
    });

    const myAssignedTasks = await this.prisma.task.count({
      where: {
        projectId: {
          in: (await this.prisma.project.findMany({
            where: { workspaceId },
            select: { id: true },
          })).map((p) => p.id),
        },
        assigneeId: userId,
        status: { not: 'DONE' },
      },
    });

    const onlineMembers = await this.prisma.userPresence.count({
      where: { workspaceId, status: PresenceStatus.ONLINE },
    });

    const unreadNotifications = await this.prisma.notification.count({
      where: { userId, isRead: false },
    });

    return {
      activeProjectsCount: activeProjects,
      assignedTasksCount: myAssignedTasks,
      onlineMembersCount: onlineMembers,
      unreadNotificationsCount: unreadNotifications,
      projectHealth: 'GOOD', // Enterprise analytic placeholder
    };
  }

  async getTasks(workspaceId: string, userId: string) {
    return this.prisma.task.findMany({
      where: {
        project: { workspaceId },
        assigneeId: userId,
        status: { not: 'DONE' },
      },
      orderBy: { priority: 'desc' },
      take: 10,
    });
  }

  async getProjects(workspaceId: string) {
    return this.prisma.project.findMany({
      where: { workspaceId, status: 'ACTIVE' },
      orderBy: { createdAt: 'desc' },
      take: 5,
    });
  }

  async getMeetings(workspaceId: string, userId: string) {
    return this.prisma.meeting.findMany({
      where: {
        workspaceId,
        participants: {
          some: { userId },
        },
      },
      orderBy: { createdAt: 'desc' },
      take: 5,
    });
  }

  async getActivityFeed(workspaceId: string) {
    return this.prisma.activityLog.findMany({
      where: { workspaceId },
      include: {
        user: { select: { id: true, fullName: true, avatarUrl: true } },
      },
      orderBy: { createdAt: 'desc' },
      take: 15,
    });
  }

  async getRecentMentions(workspaceId: string, userId: string) {
    return this.prisma.mention.findMany({
      where: {
        userId,
      },
      orderBy: { createdAt: 'desc' },
      take: 5,
    });
  }
}
