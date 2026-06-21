import { Controller, Post, Get, Body, Req, UseGuards, Param, Query } from '@nestjs/common';
import { WorkspaceService } from './workspace.service';
import { JwtStrategy } from '../auth/jwt.strategy';
import { WorkspaceAuthGuard } from '../../common/guards/workspace-auth.guard';
import { PermissionsGuard } from '../../common/guards/permissions.guard';
import { Permissions } from '../../common/decorators/permissions.decorator';
import { WorkspaceRole } from '@prisma/client';

@Controller('workspaces')
export class WorkspaceController {
  constructor(
    private workspaceService: WorkspaceService,
    private jwtStrategy: JwtStrategy,
  ) {}

  @Post()
  async createWorkspace(
    @Body() body: { name: string; slug: string; logoUrl?: string },
    @Req() req: any,
  ) {
    // Resolve JWT access token manually
    const user = await this.jwtStrategy.validateToken(req.headers['authorization']);
    return this.workspaceService.createWorkspace(user.id, body.name, body.slug, body.logoUrl);
  }

  @Get()
  async listMyWorkspaces(@Req() req: any) {
    const user = await this.jwtStrategy.validateToken(req.headers['authorization']);
    return this.workspaceService.listUserWorkspaces(user.id);
  }

  @Post(':workspaceId/invite')
  @UseGuards(WorkspaceAuthGuard, PermissionsGuard)
  @Permissions('can_manage_users')
  async inviteUser(
    @Param('workspaceId') workspaceId: string,
    @Body() body: { email: string; role: WorkspaceRole },
  ) {
    return this.workspaceService.inviteMember(workspaceId, body.email, body.role);
  }

  @Get(':workspaceId/members')
  @UseGuards(WorkspaceAuthGuard)
  async listMembers(@Param('workspaceId') workspaceId: string) {
    return this.workspaceService.listMembers(workspaceId);
  }
}
