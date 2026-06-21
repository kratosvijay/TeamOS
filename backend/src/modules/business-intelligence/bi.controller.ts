import { Controller, Get, Headers, Query, BadRequestException } from '@nestjs/common';
import { BIService } from './bi.service';

@Controller('bi')
export class BIController {
  constructor(private biService: BIService) {}

  @Get('dashboard')
  async getBIDashboard(
    @Headers('x-workspace-id') workspaceIdHeader: string,
    @Query('workspaceId') workspaceIdQuery?: string,
  ) {
    const workspaceId = workspaceIdQuery || workspaceIdHeader;
    if (!workspaceId) {
      throw new BadRequestException('Workspace ID is required');
    }
    return this.biService.generateBIDashboard(workspaceId);
  }
}
