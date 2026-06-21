import { Injectable, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { TaskStatus, TaskPriority } from '@prisma/client';
import { EventService } from '../event/event.service';

@Injectable()
export class BulkService {
  constructor(
    private prisma: PrismaService,
    private eventService: EventService,
  ) {}

  async bulkUpdate(
    userId: string,
    workspaceId: string,
    taskIds: string[],
    data: {
      status?: TaskStatus;
      priority?: TaskPriority;
      assigneeId?: string;
      sprintId?: string | null;
    },
  ) {
    if (!taskIds || taskIds.length === 0) {
      throw new BadRequestException('Task IDs must be provided');
    }

    const result = await this.prisma.$transaction(async (tx) => {
      // Fetch current tasks for audit logs
      const currentTasks = await tx.task.findMany({
        where: { id: { in: taskIds }, project: { workspaceId } },
      });

      if (currentTasks.length !== taskIds.length) {
        throw new BadRequestException('Some task IDs are invalid or belong to other workspaces');
      }

      // Update tasks
      const updated = await tx.task.updateMany({
        where: { id: { in: taskIds } },
        data,
      });

      // Write Audit Trails
      for (const task of currentTasks) {
        await tx.auditTrail.create({
          data: {
            workspaceId,
            actorId: userId,
            action: 'BULK_UPDATE',
            entityType: 'TASK',
            entityId: task.id,
            oldValue: { status: task.status, priority: task.priority, assigneeId: task.assigneeId, sprintId: task.sprintId },
            newValue: data,
          },
        });
      }

      // Log bulk activity
      await tx.activityLog.create({
        data: {
          workspaceId,
          userId,
          entityType: 'TASK',
          entityId: taskIds[0], // Reference issue
          action: 'UPDATED',
          metadata: { bulkCount: taskIds.length, changes: data },
        },
      });

      return { status: 'success', count: updated.count };
    });

    // Dispatch indexing events for all updated tasks
    try {
      const updatedTasks = await this.prisma.task.findMany({
        where: { id: { in: taskIds } },
      });
      for (const task of updatedTasks) {
        await this.eventService.dispatch('search-indexing', 'task:index', {
          entityType: 'task',
          entityId: task.id,
          payload: {
            title: task.title,
            description: task.description,
            status: task.status,
            priority: task.priority,
            key: task.key,
          },
        });
      }
    } catch (e) {
      console.error('Bulk update OpenSearch indexing failed', e);
    }

    return result;
  }

  async bulkDelete(userId: string, workspaceId: string, taskIds: string[]) {
    if (!taskIds || taskIds.length === 0) {
      throw new BadRequestException('Task IDs must be provided');
    }

    const result = await this.prisma.$transaction(async (tx) => {
      const currentTasks = await tx.task.findMany({
        where: { id: { in: taskIds }, project: { workspaceId } },
      });

      if (currentTasks.length !== taskIds.length) {
        throw new BadRequestException('Some task IDs are invalid or belong to other workspaces');
      }

      const deleted = await tx.task.deleteMany({
        where: { id: { in: taskIds } },
      });

      for (const task of currentTasks) {
        await tx.auditTrail.create({
          data: {
            workspaceId,
            actorId: userId,
            action: 'BULK_DELETE',
            entityType: 'TASK',
            entityId: task.id,
            oldValue: { key: task.key, title: task.title },
            newValue: null,
          },
        });
      }

      return { status: 'success', count: deleted.count };
    });

    // Dispatch delete events to search indexer
    try {
      for (const taskId of taskIds) {
        await this.eventService.dispatch('search-indexing', 'search:delete', {
          entityType: 'task',
          entityId: taskId,
        });
      }
    } catch (e) {
      console.error('Bulk delete OpenSearch de-indexing failed', e);
    }

    return result;
  }
}
