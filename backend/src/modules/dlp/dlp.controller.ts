import { Controller, Get, Post, Body, Headers, BadRequestException } from '@nestjs/common';
import { DLPService } from './dlp.service';

@Controller('dlp')
export class DLPController {
  constructor(private dlpService: DLPService) {}

  @Post('policies')
  async createOrUpdatePolicy(
    @Headers('x-workspace-id') workspaceIdHeader: string,
    @Body() body: { workspaceId?: string; name: string; pattern: string; action: 'Warn' | 'Block' | 'Quarantine' },
  ) {
    const workspaceId = body.workspaceId || workspaceIdHeader;
    if (!workspaceId) {
      throw new BadRequestException('Workspace ID is required');
    }
    return this.dlpService.createOrUpdatePolicy(workspaceId, body.name, body.pattern, body.action);
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
    return this.dlpService.getPolicies(workspaceId);
  }

  @Post('scan')
  async scanContent(
    @Headers('x-workspace-id') workspaceIdHeader: string,
    @Body() body: { workspaceId?: string; text: string },
  ) {
    const workspaceId = body.workspaceId || workspaceIdHeader;
    if (!workspaceId) {
      throw new BadRequestException('Workspace ID is required');
    }
    if (!body.text) {
      throw new BadRequestException('Text content is required');
    }
    return this.dlpService.scanContent(workspaceId, body.text);
  }
}
