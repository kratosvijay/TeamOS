import { Injectable, BadRequestException, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { TaskStatus, TaskType, TaskPriority, DependencyType } from '@prisma/client';
import { WatcherService } from '../watcher/watcher.service';
import { EventService } from '../event/event.service';
import { AuditService } from '../audit/audit.service';

@Injectable()
export class TaskService {
  constructor(
    private prisma: PrismaService,
    private watcherService: WatcherService,
    private eventService: EventService,
    private auditService: AuditService,
  ) {}

  async createTask(
    userId: string,
    projectId: string,
    sprintId: string | null,
    parentId: string | null,
    title: string,
    description?: string,
    type: TaskType = TaskType.TASK,
    priority: TaskPriority = TaskPriority.MEDIUM,
    storyPoints?: number,
    estimatedHours?: number,
  ) {
    const task = await this.prisma.$transaction(async (tx) => {
      // 1. Fetch project to get ticket key and next number
      const project = await tx.project.findUnique({
        where: { id: projectId },
      });
      if (!project) throw new NotFoundException('Project not found');

      const ticketKey = `${project.key}-${project.nextTicketNumber}`;

      // Increment ticket number
      await tx.project.update({
        where: { id: projectId },
        data: { nextTicketNumber: { increment: 1 } },
      });

      // Find the last card in TODO/BACKLOG to position the new card
      const lastTask = await tx.task.findFirst({
        where: { projectId, status: TaskStatus.TODO },
        orderBy: { position: 'desc' },
      });
      const position = lastTask ? lastTask.position + 100.0 : 100.0;

      // 2. Create the Task
      const newTask = await tx.task.create({
        data: {
          projectId,
          sprintId,
          parentId,
          key: ticketKey,
          title,
          description,
          type,
          status: TaskStatus.TODO,
          priority,
          storyPoints,
          position,
          reporterId: userId,
          estimatedHours,
        },
      });

      // Automatically add reporter as watcher
      await tx.taskWatcher.create({
        data: { taskId: newTask.id, userId },
      });

      // Log Activity
      await tx.activityLog.create({
        data: {
          workspaceId: project.workspaceId,
          userId,
          entityType: 'TASK',
          entityId: newTask.id,
          action: 'CREATED',
          metadata: { key: ticketKey, title },
        },
      });

      // Log Audit Trail
      await tx.auditTrail.create({
        data: {
          workspaceId: project.workspaceId,
          actorId: userId,
          action: 'TASK_CREATED',
          entityType: 'TASK',
          entityId: newTask.id,
          oldValue: null,
          newValue: JSON.parse(JSON.stringify(newTask)),
        },
      });

      return newTask;
    });

    // Dispatch Search Indexing Event
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

    return task;
  }

  async updateTask(
    taskId: string,
    userId: string,
    data: {
      title?: string;
      description?: string;
      status?: TaskStatus;
      priority?: TaskPriority;
      assigneeId?: string;
      sprintId?: string | null;
      storyPoints?: number;
      estimatedHours?: number;
    },
  ) {
    const updatedTask = await this.prisma.$transaction(async (tx) => {
      const task = await tx.task.findUnique({
        where: { id: taskId },
        include: { project: true },
      });
      if (!task) throw new NotFoundException('Task not found');

      // 3. Blocker completion validation
      if (data.status && (data.status === TaskStatus.DONE || data.status === TaskStatus.TESTING)) {
        const activeBlockers = await tx.taskDependency.findMany({
          where: {
            targetTaskId: taskId,
            dependencyType: DependencyType.BLOCKS,
            sourceTask: {
              status: { notIn: [TaskStatus.DONE, TaskStatus.CANCELLED] },
            },
          },
          include: { sourceTask: true },
        });

        if (activeBlockers.length > 0) {
          const blockerKeys = activeBlockers.map((b) => b.sourceTask.key).join(', ');
          throw new BadRequestException(`Cannot complete task. Blocked by: ${blockerKeys}`);
        }
      }

      // Check change actions to trigger watcher notifications
      const oldStatus = task.status;
      const oldAssignee = task.assigneeId;

      const updated = await tx.task.update({
        where: { id: taskId },
        data,
      });

      // Log updates
      if (data.status && data.status !== oldStatus) {
        await tx.taskActivity.create({
          data: { taskId, userId, action: 'STATUS_CHANGE', oldValue: oldStatus, newValue: data.status },
        });
        await this.watcherService.notifyWatchers(taskId, userId, 'STATUS_CHANGE', `changed from ${oldStatus} to ${data.status}`);
      }

      if (data.assigneeId !== undefined && data.assigneeId !== oldAssignee) {
        await tx.taskActivity.create({
          data: { taskId, userId, action: 'ASSIGNEE_CHANGE', oldValue: oldAssignee, newValue: data.assigneeId },
        });
        await this.watcherService.notifyWatchers(taskId, userId, 'ASSIGNEE_CHANGE', `assigned user ID: ${data.assigneeId}`);
      }

      // Log Audit Trail
      await tx.auditTrail.create({
        data: {
          workspaceId: task.project.workspaceId,
          actorId: userId,
          action: 'TASK_UPDATED',
          entityType: 'TASK',
          entityId: taskId,
          oldValue: {
            title: task.title,
            description: task.description,
            status: task.status,
            priority: task.priority,
            assigneeId: task.assigneeId,
            sprintId: task.sprintId,
            storyPoints: task.storyPoints,
            estimatedHours: task.estimatedHours,
          },
          newValue: {
            title: updated.title,
            description: updated.description,
            status: updated.status,
            priority: updated.priority,
            assigneeId: updated.assigneeId,
            sprintId: updated.sprintId,
            storyPoints: updated.storyPoints,
            estimatedHours: updated.estimatedHours,
          },
        },
      });

      return updated;
    });

    // Dispatch Search Indexing Event
    await this.eventService.dispatch('search-indexing', 'task:index', {
      entityType: 'task',
      entityId: updatedTask.id,
      payload: {
        title: updatedTask.title,
        description: updatedTask.description,
        status: updatedTask.status,
        priority: updatedTask.priority,
        key: updatedTask.key,
      },
    });

    return updatedTask;
  }

  async logWork(taskId: string, userId: string, hours: number, note?: string) {
    return this.prisma.$transaction(async (tx) => {
      const task = await tx.task.findUnique({ where: { id: taskId } });
      if (!task) throw new NotFoundException('Task not found');

      const log = await tx.workLog.create({
        data: { taskId, userId, hours, note },
      });

      await tx.task.update({
        where: { id: taskId },
        data: { loggedHours: { increment: hours } },
      });

      // Trigger watcher alerts
      await this.watcherService.notifyWatchers(taskId, userId, 'NEW_COMMENT', `logged ${hours} hours of work`);

      return log;
    });
  }

  async addDependency(sourceId: string, targetId: string, type: DependencyType) {
    if (sourceId === targetId) {
      throw new BadRequestException('A task cannot depend on itself');
    }

    // Cyclical Check
    const isCyclic = await this.checkCycle(targetId, sourceId);
    if (isCyclic) {
      throw new BadRequestException('Adding this dependency would cause a cycle');
    }

    return this.prisma.taskDependency.create({
      data: {
        sourceTaskId: sourceId,
        targetTaskId: targetId,
        dependencyType: type,
      },
    });
  }

  private async checkCycle(currentId: string, targetId: string, visited = new Set<string>()): Promise<boolean> {
    if (currentId === targetId) return true;
    if (visited.has(currentId)) return false;
    visited.add(currentId);

    const dependencies = await this.prisma.taskDependency.findMany({
      where: { sourceTaskId: currentId },
    });

    for (const dep of dependencies) {
      const cyclic = await this.checkCycle(dep.targetTaskId, targetId, visited);
      if (cyclic) return true;
    }

    return false;
  }

  async vote(taskId: string, userId: string) {
    return this.prisma.taskVote.upsert({
      where: { taskId_userId: { taskId, userId } },
      update: {},
      create: { taskId, userId },
    });
  }

  async removeVote(taskId: string, userId: string) {
    return this.prisma.taskVote.deleteMany({
      where: { taskId, userId },
    });
  }
}
