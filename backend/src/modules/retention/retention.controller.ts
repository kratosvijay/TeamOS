import { Controller, Get, Post, Body, Headers, BadRequestException } from '@nestjs/common';
import { RetentionService } from './retention.service';

@Controller('retention')
export class RetentionController {
  constructor(private retentionService: RetentionService) {}

  @Post('policies')
  async createOrUpdatePolicy(
    @Headers('x-workspace-id') workspaceIdHeader: string,
    @Body() body: { workspaceId?: string; targetType: string; retentionDays: number },
  ) {
    const workspaceId = body.workspaceId || workspaceIdHeader;
    if (!workspaceId) {
      throw new BadRequestException('Workspace ID is required');
    }
    return this.retentionService.createOrUpdatePolicy(workspaceId, body.targetType, body.retentionDays);
  }

  @Get('policies')
  async getPolicies(
    @Headers('x-workspace-id') workspaceIdHeader: string,
    @Body() body: { workspaceId?: string },
  ) {
    const workspaceId = body.workspaceId || workspaceIdHeader;
    if (!workspaceId) {
      throw new BadRequestException('Workspace ID is required');
    }
    return this.retentionService.getPolicies(workspaceId);
  }

  @Post('legal-holds')
  async createOrUpdateLegalHold(
    @Headers('x-workspace-id') workspaceIdHeader: string,
    @Body() body: { workspaceId?: string; name: string; active: boolean },
  ) {
    const workspaceId = body.workspaceId || workspaceIdHeader;
    if (!workspaceId) {
      throw new BadRequestException('Workspace ID is required');
    }
    return this.retentionService.createOrUpdateLegalHold(workspaceId, body.name, body.active);
  }

  @Get('legal-holds')
  async getLegalHolds(
    @Headers('x-workspace-id') workspaceIdHeader: string,
    @Body() body: { workspaceId?: string },
  ) {
    const workspaceId = body.workspaceId || workspaceIdHeader;
    if (!workspaceId) {
      throw new BadRequestException('Workspace ID is required');
    }
    return this.retentionService.getLegalHolds(workspaceId);
  }
}
