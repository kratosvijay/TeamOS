import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { TaskService } from '../task/task.service';

@Injectable()
export class TaskTemplateService {
  constructor(
    private prisma: PrismaService,
    private taskService: TaskService,
  ) {}

  async createTemplate(workspaceId: string, name: string, description: string | null, templateJson: any) {
    try {
      return await this.prisma.taskTemplate.create({
        data: {
          workspaceId,
          name,
          description,
          templateJson,
        },
      });
    } catch (error) {
      if (error.code === 'P2002') {
        throw new BadRequestException('A template with this name already exists in this workspace');
      }
      throw error;
    }
  }

  async getTemplates(workspaceId: string) {
    return this.prisma.taskTemplate.findMany({
      where: { workspaceId },
      orderBy: { createdAt: 'desc' },
    });
  }

  async updateTemplate(id: string, workspaceId: string, data: { name?: string; description?: string | null; templateJson?: any }) {
    const template = await this.prisma.taskTemplate.findFirst({
      where: { id, workspaceId },
    });

    if (!template) {
      throw new NotFoundException('Task template not found');
    }

    try {
      return await this.prisma.taskTemplate.update({
        where: { id },
        data,
      });
    } catch (error) {
      if (error.code === 'P2002') {
        throw new BadRequestException('A template with this name already exists in this workspace');
      }
      throw error;
    }
  }

  async deleteTemplate(id: string, workspaceId: string) {
    const template = await this.prisma.taskTemplate.findFirst({
      where: { id, workspaceId },
    });

    if (!template) {
      throw new NotFoundException('Task template not found');
    }

    await this.prisma.taskTemplate.delete({
      where: { id },
    });

    return { success: true };
  }

  async instantiateTemplate(
    id: string,
    workspaceId: string,
    userId: string,
    projectId: string,
    sprintId: string | null,
    parentId: string | null,
    overrides?: { title?: string; description?: string },
  ) {
    const template = await this.prisma.taskTemplate.findFirst({
      where: { id, workspaceId },
    });

    if (!template) {
      throw new NotFoundException('Task template not found');
    }

    const tplData = template.templateJson as any;
    const title = overrides?.title || tplData.title || `Task from ${template.name}`;
    const description = overrides?.description || tplData.description || '';
    const type = tplData.type || 'TASK';
    const priority = tplData.priority || 'MEDIUM';
    const storyPoints = tplData.storyPoints || null;
    const estimatedHours = tplData.estimatedHours || null;

    // Use TaskService to create the task properly with all hooks, notifications, key increments, etc.
    return this.taskService.createTask(
      userId,
      projectId,
      sprintId,
      parentId,
      title,
      description,
      type,
      priority,
      storyPoints,
      estimatedHours,
    );
  }
}
