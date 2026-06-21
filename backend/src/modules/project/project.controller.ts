import { Controller, Post, Get, Delete, Body, Req, UseGuards, Param, Headers } from '@nestjs/common';
import { ProjectService } from './project.service';
import { WorkspaceAuthGuard } from '../../common/guards/workspace-auth.guard';
import { PermissionsGuard } from '../../common/guards/permissions.guard';
import { Permissions } from '../../common/decorators/permissions.decorator';

@Controller('projects')
@UseGuards(WorkspaceAuthGuard, PermissionsGuard)
export class ProjectController {
  constructor(private projectService: ProjectService) {}

  @Post()
  @Permissions('can_create_projects')
  async createProject(
    @Headers('x-workspace-id') workspaceId: string,
    @Body() body: { name: string; description?: string },
    @Req() req: any,
  ) {
    return this.projectService.createProject(req.user.id, workspaceId, body.name, body.description);
  }

  @Get()
  async listProjects(@Headers('x-workspace-id') workspaceId: string) {
    return this.projectService.getProjects(workspaceId);
  }

  @Delete(':projectId')
  @Permissions('can_delete_projects')
  async archiveProject(
    @Headers('x-workspace-id') workspaceId: string,
    @Param('projectId') projectId: string,
    @Req() req: any,
  ) {
    return this.projectService.archiveProject(workspaceId, projectId, req.user.id);
  }
}
