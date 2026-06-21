import { Controller, Get, Post, Body, Headers, Query, BadRequestException } from '@nestjs/common';
import { OKRService } from './okr.service';

@Controller('okr')
export class OKRController {
  constructor(private okrService: OKRService) {}

  @Post('objectives')
  async createObjective(
    @Headers('x-workspace-id') workspaceIdHeader: string,
    @Body() body: { workspaceId?: string; title: string; description?: string },
  ) {
    const workspaceId = body.workspaceId || workspaceIdHeader;
    if (!workspaceId || !body.title) {
      throw new BadRequestException('Workspace ID and Objective title are required');
    }
    return this.okrService.createObjective(workspaceId, body.title, body.description);
  }

  @Post('key-results')
  async createKeyResult(
    @Body() body: { objectiveId: string; title: string; currentValue: number; targetValue: number },
  ) {
    if (!body.objectiveId || !body.title || body.targetValue === undefined || body.currentValue === undefined) {
      throw new BadRequestException('Objective ID, Title, targetValue, and currentValue are required');
    }
    return this.okrService.createKeyResult(
      body.objectiveId,
      body.title,
      body.currentValue,
      body.targetValue,
    );
  }

  @Get('dashboard')
  async getOkrDashboard(
    @Headers('x-workspace-id') workspaceIdHeader: string,
    @Query('workspaceId') workspaceIdQuery?: string,
  ) {
    const workspaceId = workspaceIdQuery || workspaceIdHeader;
    if (!workspaceId) {
      throw new BadRequestException('Workspace ID is required');
    }
    return this.okrService.getOkrDashboard(workspaceId);
  }
}
