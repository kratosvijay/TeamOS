import { Controller, Post, Get, Put, Delete, Body, Param, UseGuards, Headers, Req } from '@nestjs/common';
import { TaskTemplateService } from './task-template.service';
import { WorkspaceAuthGuard } from '../../common/guards/workspace-auth.guard';

@Controller('task-templates')
@UseGuards(WorkspaceAuthGuard)
export class TaskTemplateController {
  constructor(private taskTemplateService: TaskTemplateService) {}

  @Post()
  async createTemplate(
    @Headers('x-workspace-id') workspaceId: string,
    @Body() body: { name: string; description?: string; templateJson: any },
  ) {
    return this.taskTemplateService.createTemplate(workspaceId, body.name, body.description || null, body.templateJson);
  }

  @Get()
  async getTemplates(@Headers('x-workspace-id') workspaceId: string) {
    return this.taskTemplateService.getTemplates(workspaceId);
  }

  @Put(':id')
  async updateTemplate(
    @Headers('x-workspace-id') workspaceId: string,
    @Param('id') id: string,
    @Body() body: { name?: string; description?: string; templateJson?: any },
  ) {
    return this.taskTemplateService.updateTemplate(id, workspaceId, body);
  }

  @Delete(':id')
  async deleteTemplate(
    @Headers('x-workspace-id') workspaceId: string,
    @Param('id') id: string,
  ) {
    return this.taskTemplateService.deleteTemplate(id, workspaceId);
  }

  @Post(':id/instantiate')
  async instantiateTemplate(
    @Req() req: any,
    @Headers('x-workspace-id') workspaceId: string,
    @Param('id') id: string,
    @Body()
    body: {
      projectId: string;
      sprintId?: string;
      parentId?: string;
      title?: string;
      description?: string;
    },
  ) {
    const userId = req.user.id;
    return this.taskTemplateService.instantiateTemplate(
      id,
      workspaceId,
      userId,
      body.projectId,
      body.sprintId || null,
      body.parentId || null,
      body,
    );
  }
}
