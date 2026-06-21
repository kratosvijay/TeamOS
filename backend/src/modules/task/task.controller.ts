import { Controller, Post, Get, Put, Delete, Body, Param, Headers, Req, UseGuards } from '@nestjs/common';
import { TaskService } from './task.service';
import { BulkService } from './bulk.service';
import { JwtStrategy } from '../auth/jwt.strategy';
import { TaskStatus, TaskType, TaskPriority, DependencyType } from '@prisma/client';

@Controller('tasks')
export class TaskController {
  constructor(
    private taskService: TaskService,
    private bulkService: BulkService,
    private jwtStrategy: JwtStrategy,
  ) {}

  @Post()
  async createTask(
    @Headers('authorization') authHeader: string,
    @Body()
    body: {
      projectId: string;
      sprintId?: string;
      parentId?: string;
      title: string;
      description?: string;
      type?: TaskType;
      priority?: TaskPriority;
      storyPoints?: number;
      estimatedHours?: number;
    },
  ) {
    const user = await this.jwtStrategy.validateToken(authHeader);
    return this.taskService.createTask(
      user.id,
      body.projectId,
      body.sprintId || null,
      body.parentId || null,
      body.title,
      body.description,
      body.type,
      body.priority,
      body.storyPoints,
      body.estimatedHours,
    );
  }

  @Get(':id')
  async getTask(
    @Headers('authorization') authHeader: string,
    @Param('id') id: string,
  ) {
    await this.jwtStrategy.validateToken(authHeader);
    // Find task details
    return { id };
  }

  @Put(':id')
  async updateTask(
    @Headers('authorization') authHeader: string,
    @Param('id') id: string,
    @Body()
    body: {
      title?: string;
      description?: string;
      status?: TaskStatus;
      priority?: TaskPriority;
      assigneeId?: string;
      sprintId?: string;
      storyPoints?: number;
      estimatedHours?: number;
    },
    @Req() req: any,
  ) {
    const user = await this.jwtStrategy.validateToken(authHeader);
    return this.taskService.updateTask(id, user.id, {
      ...body,
      sprintId: body.sprintId === undefined ? undefined : (body.sprintId || null),
    });
  }

  @Post(':id/worklogs')
  async logWork(
    @Headers('authorization') authHeader: string,
    @Param('id') id: string,
    @Body() body: { hours: number; note?: string },
  ) {
    const user = await this.jwtStrategy.validateToken(authHeader);
    return this.taskService.logWork(id, user.id, body.hours, body.note);
  }

  @Post(':id/dependencies')
  async addDependency(
    @Headers('authorization') authHeader: string,
    @Param('id') sourceId: string,
    @Body() body: { targetTaskId: string; dependencyType: DependencyType },
  ) {
    await this.jwtStrategy.validateToken(authHeader);
    return this.taskService.addDependency(sourceId, body.targetTaskId, body.dependencyType);
  }

  @Post(':id/vote')
  async vote(
    @Headers('authorization') authHeader: string,
    @Param('id') id: string,
  ) {
    const user = await this.jwtStrategy.validateToken(authHeader);
    return this.taskService.vote(id, user.id);
  }

  @Delete(':id/vote')
  async removeVote(
    @Headers('authorization') authHeader: string,
    @Param('id') id: string,
  ) {
    const user = await this.jwtStrategy.validateToken(authHeader);
    return this.taskService.removeVote(id, user.id);
  }

  @Post('bulk-update')
  async bulkUpdate(
    @Headers('authorization') authHeader: string,
    @Headers('x-workspace-id') workspaceId: string,
    @Body()
    body: {
      taskIds: string[];
      data: {
        status?: TaskStatus;
        priority?: TaskPriority;
        assigneeId?: string;
        sprintId?: string;
      };
    },
  ) {
    const user = await this.jwtStrategy.validateToken(authHeader);
    return this.bulkService.bulkUpdate(user.id, workspaceId, body.taskIds, {
      ...body.data,
      sprintId: body.data.sprintId === undefined ? undefined : (body.data.sprintId || null),
    });
  }

  @Post('bulk-delete')
  async bulkDelete(
    @Headers('authorization') authHeader: string,
    @Headers('x-workspace-id') workspaceId: string,
    @Body() body: { taskIds: string[] },
  ) {
    const user = await this.jwtStrategy.validateToken(authHeader);
    return this.bulkService.bulkDelete(user.id, workspaceId, body.taskIds);
  }
}
