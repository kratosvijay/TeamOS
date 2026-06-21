import { Controller, Get, Headers, Query, BadRequestException } from '@nestjs/common';
import { ExecutiveService } from './executive.service';

@Controller('executive')
export class ExecutiveController {
  constructor(private executiveService: ExecutiveService) {}

  @Get('dashboard')
  async getExecutiveDashboard(
    @Headers('x-workspace-id') workspaceIdHeader: string,
    @Query('workspaceId') workspaceIdQuery?: string,
  ) {
    const workspaceId = workspaceIdQuery || workspaceIdHeader;
    if (!workspaceId) {
      throw new BadRequestException('Workspace ID is required');
    }
    return this.executiveService.getExecutiveDashboard(workspaceId);
  }
}
