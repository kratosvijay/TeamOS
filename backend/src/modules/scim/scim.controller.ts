import { Controller, Post, Put, Delete, Body, Param, Headers, BadRequestException } from '@nestjs/common';
import { SCIMService } from './scim.service';

@Controller('scim')
export class SCIMController {
  constructor(private scimService: SCIMService) {}

  @Post('users')
  async createUser(
    @Headers('x-workspace-id') workspaceIdHeader: string,
    @Body() body: { email: string; fullName: string; workspaceId?: string },
  ) {
    const workspaceId = body.workspaceId || workspaceIdHeader;
    if (!workspaceId) {
      throw new BadRequestException('Workspace ID is required');
    }
    return this.scimService.createSCIMUser(workspaceId, body.email, body.fullName);
  }

  @Put('users/:id')
  async updateUser(
    @Param('id') userId: string,
    @Body() body: { email?: string; fullName?: string },
  ) {
    return this.scimService.updateSCIMUser(userId, body.email, body.fullName);
  }

  @Delete('users/:id')
  async disableUser(
    @Param('id') userId: string,
    @Headers('x-workspace-id') workspaceIdHeader: string,
    @Body() body: { workspaceId?: string },
  ) {
    const workspaceId = body.workspaceId || workspaceIdHeader;
    if (!workspaceId) {
      throw new BadRequestException('Workspace ID is required');
    }
    return this.scimService.disableSCIMUser(workspaceId, userId);
  }
}
