import { Controller, Get, Post, Body, Headers, BadRequestException } from '@nestjs/common';
import { SSOService } from './sso.service';

@Controller('sso')
export class SSOController {
  constructor(private ssoService: SSOService) {}

  @Post('providers')
  async createSSOProvider(
    @Headers('x-workspace-id') workspaceIdHeader: string,
    @Body() body: { workspaceId?: string; providerType: string; metadataUrl?: string; clientId?: string; issuer?: string },
  ) {
    const workspaceId = body.workspaceId || workspaceIdHeader;
    if (!workspaceId) {
      throw new BadRequestException('Workspace ID is required');
    }
    return this.ssoService.createSSOProvider(
      workspaceId,
      body.providerType,
      body.metadataUrl,
      body.clientId,
      body.issuer,
    );
  }

  @Get('providers')
  async getSSOProviders(
    @Headers('x-workspace-id') workspaceIdHeader: string,
    @Body() body: { workspaceId?: string },
  ) {
    const workspaceId = body.workspaceId || workspaceIdHeader;
    if (!workspaceId) {
      throw new BadRequestException('Workspace ID is required');
    }
    return this.ssoService.getSSOProviders(workspaceId);
  }

  @Post('login')
  async login(
    @Headers('x-workspace-id') workspaceIdHeader: string,
    @Body() body: { email: string; providerType: string; workspaceId?: string },
  ) {
    const workspaceId = body.workspaceId || workspaceIdHeader;
    if (!workspaceId) {
      throw new BadRequestException('Workspace ID is required');
    }
    return this.ssoService.verifySSOLogin(body.email, body.providerType, workspaceId);
  }

  @Post('logout')
  async logout() {
    return { success: true, message: 'SSO logout processed successfully' };
  }

  @Post('test')
  async testConnection(@Body() body: { providerId: string }) {
    if (!body.providerId) {
      throw new BadRequestException('Provider ID is required');
    }
    return this.ssoService.testSSOConnection(body.providerId);
  }
}
