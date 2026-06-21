import { Controller, Get, Post, Delete, Body, Param, Headers, Req, UseGuards } from '@nestjs/common';
import { IntegrationService } from './integration.service';
import { WorkspaceAuthGuard } from '../../common/guards/workspace-auth.guard';
import { IntegrationPermission } from '@prisma/client';

@Controller('integrations')
@UseGuards(WorkspaceAuthGuard)
export class IntegrationController {
  constructor(private readonly integrationService: IntegrationService) {}

  @Get()
  async getIntegrations(@Headers('x-workspace-id') workspaceId: string) {
    return this.integrationService.getIntegrations(workspaceId);
  }

  @Get(':id')
  async getIntegrationById(
    @Headers('x-workspace-id') workspaceId: string,
    @Param('id') id: string,
  ) {
    return this.integrationService.getIntegrationById(workspaceId, id);
  }

  @Post('install')
  async installIntegration(
    @Headers('x-workspace-id') workspaceId: string,
    @Req() req: any,
    @Body() body: { provider: string; name: string; settings?: any; permission?: IntegrationPermission },
  ) {
    const userId = req.user.id;
    return this.integrationService.installIntegration(workspaceId, userId, {
      provider: body.provider,
      name: body.name,
      settings: body.settings || {},
      permission: body.permission || IntegrationPermission.READ_ONLY,
    });
  }

  @Post('uninstall')
  async uninstallIntegration(
    @Headers('x-workspace-id') workspaceId: string,
    @Req() req: any,
    @Body() body: { installationId: string },
  ) {
    const userId = req.user.id;
    return this.integrationService.uninstallIntegration(workspaceId, userId, body.installationId);
  }
}
