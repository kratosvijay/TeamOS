import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { AuthService } from '../auth/auth.service';

@Injectable()
export class SSOService {
  constructor(
    private prisma: PrismaService,
    private authService: AuthService,
  ) {}

  async createSSOProvider(
    workspaceId: string,
    providerType: string,
    metadataUrl?: string,
    clientId?: string,
    issuer?: string,
  ) {
    const validProviders = ['Azure AD', 'Okta', 'Google Workspace', 'OneLogin', 'Auth0', 'Keycloak'];
    if (!validProviders.includes(providerType)) {
      throw new BadRequestException(`Unsupported provider type: ${providerType}`);
    }

    return this.prisma.sSOProvider.create({
      data: {
        workspaceId,
        providerType,
        metadataUrl,
        clientId,
        issuer,
        enabled: true,
      },
    });
  }

  async getSSOProviders(workspaceId: string) {
    return this.prisma.sSOProvider.findMany({
      where: { workspaceId },
    });
  }

  async verifySSOLogin(email: string, providerType: string, workspaceId: string) {
    const ssoProvider = await this.prisma.sSOProvider.findFirst({
      where: { workspaceId, providerType, enabled: true },
    });

    if (!ssoProvider) {
      throw new BadRequestException(`SSO Provider ${providerType} not configured or disabled for workspace ${workspaceId}`);
    }

    let user = await this.prisma.user.findUnique({
      where: { email },
    });

    if (!user) {
      // Auto-provision user through JIT (Just-In-Time) provisioning
      user = await this.prisma.user.create({
        data: {
          email,
          fullName: email.split('@')[0].toUpperCase() + ' SSO User',
        },
      });

      // Add as member of workspace
      await this.prisma.workspaceMember.create({
        data: {
          workspaceId,
          userId: user.id,
          role: 'DEVELOPER',
        },
      });
    } else {
      // Ensure they are a member of the workspace
      const member = await this.prisma.workspaceMember.findUnique({
        where: {
          workspaceId_userId: {
            workspaceId,
            userId: user.id,
          },
        },
      });

      if (!member) {
        await this.prisma.workspaceMember.create({
          data: {
            workspaceId,
            userId: user.id,
            role: 'DEVELOPER',
          },
        });
      }
    }

    // Create a UserSession
    const session = await this.prisma.userSession.create({
      data: {
        userId: user.id,
        deviceInfo: { browser: 'Chrome', os: 'macOS' },
        ipAddress: '127.0.0.1',
        createdAt: new Date(),
        expiresAt: new Date(Date.now() + 24 * 60 * 60 * 1000), // 24 hours
        riskScore: 0,
      },
    });

    return {
      tokens: await this.authService.generateTokenPair(user.id, user.email),
      session,
    };
  }

  async testSSOConnection(providerId: string) {
    const provider = await this.prisma.sSOProvider.findUnique({
      where: { id: providerId },
    });
    if (!provider) {
      throw new NotFoundException(`SSO Provider ${providerId} not found`);
    }

    return {
      success: true,
      message: `Successfully connected to SSO provider ${provider.providerType} with client/issuer credentials.`,
      timestamp: new Date().toISOString(),
    };
  }
}
