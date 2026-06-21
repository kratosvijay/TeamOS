import { Controller, Get, Post, Put, Delete, Body, Param, Headers, Query, BadRequestException } from '@nestjs/common';
import { CustomDashboardService } from './custom-dashboard.service';

@Controller('dashboard')
export class CustomDashboardController {
  constructor(private dashboardService: CustomDashboardService) {}

  @Post()
  async createDashboard(
    @Headers('x-workspace-id') workspaceIdHeader: string,
    @Body() body: { workspaceId?: string; name: string; widgets: any },
  ) {
    const workspaceId = body.workspaceId || workspaceIdHeader;
    if (!workspaceId || !body.name || !body.widgets) {
      throw new BadRequestException('Workspace ID, Name, and Widgets are required');
    }
    return this.dashboardService.createDashboard(workspaceId, body.name, body.widgets);
  }

  @Put(':id')
  async updateDashboard(
    @Param('id') id: string,
    @Body() body: { name?: string; widgets?: any },
  ) {
    return this.dashboardService.updateDashboard(id, body.name, body.widgets);
  }

  @Get()
  async getDashboards(
    @Headers('x-workspace-id') workspaceIdHeader: string,
    @Query('workspaceId') workspaceIdQuery?: string,
  ) {
    const workspaceId = workspaceIdQuery || workspaceIdHeader;
    if (!workspaceId) {
      throw new BadRequestException('Workspace ID is required');
    }
    return this.dashboardService.getDashboards(workspaceId);
  }

  @Delete(':id')
  async deleteDashboard(@Param('id') id: string) {
    await this.dashboardService.deleteDashboard(id);
    return { success: true, message: 'Dashboard deleted' };
  }
}
