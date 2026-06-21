import { Controller, Get, Post, Put, Delete, Body, Param, Headers, BadRequestException, UseGuards, Req } from '@nestjs/common';
import { SecurityService } from './security.service';
import { SessionService } from './session.service';

@Controller('security')
export class SecurityController {
  constructor(
    private securityService: SecurityService,
    private sessionService: SessionService,
  ) {}

  @Post('policy')
  async createOrUpdatePolicy(
    @Headers('x-workspace-id') workspaceIdHeader: string,
    @Body() body: { workspaceId?: string; requireMFA: boolean; sessionTimeout: number; allowPasswordLogin: boolean; ipAllowlist?: string[] },
  ) {
    const workspaceId = body.workspaceId || workspaceIdHeader;
    if (!workspaceId) {
      throw new BadRequestException('Workspace ID is required');
    }
    return this.securityService.createOrUpdatePolicy(
      workspaceId,
      body.requireMFA,
      body.sessionTimeout,
      body.allowPasswordLogin,
      body.ipAllowlist || [],
    );
  }

  @Get('policy')
  async getPolicy(
    @Headers('x-workspace-id') workspaceIdHeader: string,
    @Req() request: any,
  ) {
    const workspaceId = workspaceIdHeader || request.query.workspaceId;
    if (!workspaceId) {
      throw new BadRequestException('Workspace ID is required');
    }
    return this.securityService.getPolicy(workspaceId);
  }

  @Get('incidents')
  async getSecurityIncidents(
    @Headers('x-workspace-id') workspaceIdHeader: string,
    @Req() request: any,
  ) {
    const workspaceId = workspaceIdHeader || request.query.workspaceId;
    if (!workspaceId) {
      throw new BadRequestException('Workspace ID is required');
    }
    return this.securityService.getSecurityIncidents(workspaceId);
  }

  @Post('mfa/recovery-codes')
  async generateRecoveryCodes(@Body() body: { userId: string }) {
    if (!body.userId) {
      throw new BadRequestException('User ID is required');
    }
    const codes = await this.securityService.generateRecoveryCodes(body.userId);
    return { codes };
  }

  @Post('mfa/verify')
  async verifyRecoveryCode(@Body() body: { userId: string; code: string }) {
    if (!body.userId || !body.code) {
      throw new BadRequestException('User ID and Code are required');
    }
    const isValid = await this.securityService.verifyRecoveryCode(body.userId, body.code);
    return { success: isValid };
  }

  @Get('sessions')
  async getSessions(@Headers('x-user-id') userIdHeader: string, @Req() request: any) {
    const userId = userIdHeader || request.query.userId;
    if (!userId) {
      throw new BadRequestException('User ID is required');
    }
    return this.sessionService.getSessions(userId);
  }

  @Delete('sessions/:id')
  async terminateSession(@Param('id') id: string) {
    await this.sessionService.terminateSession(id);
    return { success: true, message: 'Session terminated' };
  }

  @Delete('sessions')
  async terminateAllSessions(@Headers('x-user-id') userIdHeader: string, @Req() request: any) {
    const userId = userIdHeader || request.query.userId;
    if (!userId) {
      throw new BadRequestException('User ID is required');
    }
    await this.sessionService.terminateAllSessions(userId);
    return { success: true, message: 'All sessions terminated' };
  }
}
