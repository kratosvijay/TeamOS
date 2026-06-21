import { Controller, Post, Get, Body, Headers, Query } from '@nestjs/common';
import { WorkflowMarketplaceService } from './workflow-marketplace.service';

@Controller('workflow-marketplace')
export class WorkflowMarketplaceController {
  constructor(private readonly marketplaceService: WorkflowMarketplaceService) {}

  @Get()
  async listTemplates() {
    return this.marketplaceService.listTemplates();
  }

  @Post('install')
  async installTemplate(
    @Headers('x-workspace-id') workspaceId: string,
    @Headers('x-user-id') userId: string,
    @Body() body: { templateName: string },
  ) {
    const creator = userId || 'user-1';
    return this.marketplaceService.installTemplate(workspaceId || 'ws-1', creator, body.templateName);
  }
}
