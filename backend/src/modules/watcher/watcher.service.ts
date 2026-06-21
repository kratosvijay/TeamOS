import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { NotificationService } from '../notification/notification.service';
import { NotificationType } from '@prisma/client';

@Injectable()
export class WatcherService {
  constructor(
    private prisma: PrismaService,
    private notificationService: NotificationService,
  ) {}

  async watchTask(taskId: string, userId: string) {
    return this.prisma.taskWatcher.upsert({
      where: {
        taskId_userId: { taskId, userId },
      },
      update: {},
      create: { taskId, userId },
    });
  }

  async unwatchTask(taskId: string, userId: string) {
    return this.prisma.taskWatcher.deleteMany({
      where: { taskId, userId },
    });
  }

  async notifyWatchers(
    taskId: string,
    actorId: string,
    actionType: 'STATUS_CHANGE' | 'ASSIGNEE_CHANGE' | 'NEW_COMMENT' | 'ATTACHMENT_UPLOAD' | 'SPRINT_ASSIGNMENT',
    details: string,
  ) {
    const watchers = await this.prisma.taskWatcher.findMany({
      where: { taskId },
      include: {
        user: { select: { id: true, fullName: true } },
      },
    });

    const task = await this.prisma.task.findUnique({ where: { id: taskId } });
    if (!task) return;

    const actor = await this.prisma.user.findUnique({ where: { id: actorId } });
    const actorName = actor ? actor.fullName : 'Someone';

    for (const watcher of watchers) {
      // Don't notify the person who performed the action
      if (watcher.userId !== actorId) {
        await this.notificationService.createNotification(
          watcher.userId,
          NotificationType.TASK_UPDATED,
          `Task Updated: ${task.key}`,
          `${actorName} triggered a ${actionType.toLowerCase().replace('_', ' ')}: ${details}`,
          'TASK',
          taskId,
        );
      }
    }
  }
}
