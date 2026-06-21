import { Controller, Get, UseGuards, Headers, Req } from '@nestjs/common';
import { DashboardService } from './dashboard.service';
import { WorkspaceAuthGuard } from '../../common/guards/workspace-auth.guard';

@Controller('dashboard')
@UseGuards(WorkspaceAuthGuard)
export class DashboardController {
  constructor(private dashboardService: DashboardService) {}

  @Get('overview')
  async getOverview(@Headers('x-workspace-id') workspaceId: string, @Req() req: any) {
    return this.dashboardService.getOverview(workspaceId, req.user.id);
  }

  @Get('tasks')
  async getTasks(@Headers('x-workspace-id') workspaceId: string, @Req() req: any) {
    return this.dashboardService.getTasks(workspaceId, req.user.id);
  }

  @Get('projects')
  async getProjects(@Headers('x-workspace-id') workspaceId: string) {
    return this.dashboardService.getProjects(workspaceId);
  }

  @Get('meetings')
  async getMeetings(@Headers('x-workspace-id') workspaceId: string, @Req() req: any) {
    return this.dashboardService.getMeetings(workspaceId, req.user.id);
  }

  @Get('activity')
  async getActivity(@Headers('x-workspace-id') workspaceId: string) {
    return this.dashboardService.getActivityFeed(workspaceId);
  }

  @Get('notifications')
  async getDashboardNotifications(@Headers('x-workspace-id') workspaceId: string, @Req() req: any) {
    return this.dashboardService.getRecentMentions(workspaceId, req.user.id);
  }
}
