import { Controller, Get, Headers, Query, BadRequestException } from '@nestjs/common';
import { ResourcePlanningService } from './resource-planning.service';

@Controller('resources')
export class ResourcePlanningController {
  constructor(private resourcePlanningService: ResourcePlanningService) {}

  @Get('capacity')
  async getCapacity(
    @Headers('x-workspace-id') workspaceIdHeader: string,
    @Query('workspaceId') workspaceIdQuery?: string,
  ) {
    const workspaceId = workspaceIdQuery || workspaceIdHeader;
    if (!workspaceId) {
      throw new BadRequestException('Workspace ID is required');
    }
    return this.resourcePlanningService.calculateCapacity(workspaceId);
  }

  @Get('utilization')
  async getUtilization(
    @Headers('x-workspace-id') workspaceIdHeader: string,
    @Query('workspaceId') workspaceIdQuery?: string,
  ) {
    const workspaceId = workspaceIdQuery || workspaceIdHeader;
    if (!workspaceId) {
      throw new BadRequestException('Workspace ID is required');
    }
    return this.resourcePlanningService.calculateUtilization(workspaceId);
  }
}
