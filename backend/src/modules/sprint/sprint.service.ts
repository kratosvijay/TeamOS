import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { TaskStatus } from '@prisma/client';
import { EventService } from '../event/event.service';
import { AuditService } from '../audit/audit.service';

@Injectable()
export class SprintService {
  constructor(
    private prisma: PrismaService,
    private eventService: EventService,
    private auditService: AuditService,
  ) {}

  async createSprint(projectId: string, name: string, goal?: string, startDate?: Date, endDate?: Date, userId?: string) {
    const start = startDate ? new Date(startDate) : new Date();
    const end = endDate ? new Date(endDate) : new Date();
    if (endDate === undefined) {
      end.setDate(start.getDate() + 14); // Default 2 weeks
    }

    const sprint = await this.prisma.sprint.create({
      data: {
        projectId,
        name,
        goal,
        startDate: start,
        endDate: end,
      },
      include: { project: true },
    });

    if (userId) {
      await this.auditService.logAction(
        sprint.project.workspaceId,
        userId,
        'SPRINT_CREATED',
        'SPRINT',
        sprint.id,
        null,
        sprint,
      );
    }

    await this.eventService.dispatch('search-indexing', 'sprint:index', {
      entityType: 'sprint',
      entityId: sprint.id,
      payload: {
        name: sprint.name,
        goal: sprint.goal,
        projectId: sprint.projectId,
      },
    });

    return sprint;
  }

  async startSprint(sprintId: string, userId?: string) {
    const sprint = await this.prisma.sprint.findUnique({
      where: { id: sprintId },
      include: { project: true },
    });
    if (!sprint) throw new NotFoundException('Sprint not found');
    if (sprint.isActive) throw new BadRequestException('Sprint is already active');
    if (sprint.isCompleted) throw new BadRequestException('Cannot start a completed sprint');

    // Deactivate other active sprints in same project
    await this.prisma.sprint.updateMany({
      where: { projectId: sprint.projectId, isActive: true },
      data: { isActive: false },
    });

    const updated = await this.prisma.sprint.update({
      where: { id: sprintId },
      data: { isActive: true, startDate: new Date() },
    });

    if (userId) {
      await this.auditService.logAction(
        sprint.project.workspaceId,
        userId,
        'SPRINT_STARTED',
        'SPRINT',
        sprint.id,
        { isActive: false },
        { isActive: true },
      );
    }

    await this.eventService.dispatch('search-indexing', 'sprint:index', {
      entityType: 'sprint',
      entityId: sprint.id,
      payload: {
        name: updated.name,
        goal: updated.goal,
        projectId: updated.projectId,
      },
    });

    return updated;
  }

  async completeSprint(
    sprintId: string,
    userId: string,
    data: {
      retrospective?: string;
      retrospectiveActionItems?: any;
      moveToSprintId?: string | null; // target sprint for roll-over tasks
    },
  ) {
    const sprint = await this.prisma.sprint.findUnique({
      where: { id: sprintId },
      include: { project: true },
    });
    if (!sprint) throw new NotFoundException('Sprint not found');
    if (!sprint.isActive) throw new BadRequestException('Only active sprints can be completed');

    const result = await this.prisma.$transaction(async (tx) => {
      // 1. Fetch all sprint tasks
      const tasks = await tx.task.findMany({
        where: { sprintId },
      });

      const completedTasks = tasks.filter((t) => t.status === TaskStatus.DONE);
      const carryOverTasks = tasks.filter((t) => t.status !== TaskStatus.DONE && t.status !== TaskStatus.CANCELLED);

      const completedPoints = completedTasks.reduce((sum, t) => sum + (t.storyPoints || 0), 0);
      const totalPoints = tasks.reduce((sum, t) => sum + (t.storyPoints || 0), 0);

      // 2. Rollover uncompleted tasks
      const targetSprintId = data.moveToSprintId || null; // Null means move to backlog
      if (carryOverTasks.length > 0) {
        await tx.task.updateMany({
          where: { id: { in: carryOverTasks.map((t) => t.id) } },
          data: { sprintId: targetSprintId },
        });
      }

      // 3. Mark sprint complete
      const completedSprint = await tx.sprint.update({
        where: { id: sprintId },
        data: {
          isActive: false,
          isCompleted: true,
          retrospective: data.retrospective,
          retrospectiveActionItems: data.retrospectiveActionItems,
        },
      });

      // Log audit log for sprint completion
      await tx.auditTrail.create({
        data: {
          workspaceId: sprint.project.workspaceId,
          actorId: userId,
          action: 'SPRINT_COMPLETED',
          entityType: 'SPRINT',
          entityId: sprintId,
          oldValue: { name: sprint.name, isActive: true },
          newValue: {
            isCompleted: true,
            completedPoints,
            totalPoints,
            carryOverCount: carryOverTasks.length,
          },
        },
      });

      return {
        sprint: completedSprint,
        analytics: {
          velocity: completedPoints,
          completionRate: totalPoints > 0 ? (completedPoints / totalPoints) * 100 : 0,
          carryOverCount: carryOverTasks.length,
        },
      };
    });

    // Re-index updated sprint
    await this.eventService.dispatch('search-indexing', 'sprint:index', {
      entityType: 'sprint',
      entityId: result.sprint.id,
      payload: {
        name: result.sprint.name,
        goal: result.sprint.goal,
        projectId: result.sprint.projectId,
      },
    });

    return result;
  }
}
