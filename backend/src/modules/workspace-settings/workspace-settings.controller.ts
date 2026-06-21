import { Controller, Get, Put, Body, UseGuards, Headers } from '@nestjs/common';
import { WorkspaceSettingsService } from './workspace-settings.service';
import { WorkspaceAuthGuard } from '../../common/guards/workspace-auth.guard';
import { PermissionsGuard } from '../../common/guards/permissions.guard';
import { Permissions } from '../../common/decorators/permissions.decorator';
import { WorkspaceRole } from '@prisma/client';

@Controller('workspace-settings')
@UseGuards(WorkspaceAuthGuard, PermissionsGuard)
export class WorkspaceSettingsController {
  constructor(private settingsService: WorkspaceSettingsService) {}

  @Get()
  async getSettings(@Headers('x-workspace-id') workspaceId: string) {
    return this.settingsService.getSettings(workspaceId);
  }

  @Put()
  @Permissions('can_manage_workspace')
  async updateSettings(
    @Headers('x-workspace-id') workspaceId: string,
    @Body()
    body: {
      allowGuestUsers?: boolean;
      allowPublicProjects?: boolean;
      defaultRole?: WorkspaceRole;
      enableMeetings?: boolean;
      enableDocuments?: boolean;
      enableAI?: boolean;
      enableChat?: boolean;
    },
  ) {
    return this.settingsService.updateSettings(workspaceId, body);
  }
}
