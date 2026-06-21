import { Injectable, OnModuleInit, OnModuleDestroy, UnauthorizedException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { SecretVaultService } from '../secret-vault/secret-vault.service';
import { Worker, Job } from 'bullmq';

@Injectable()
export class OAuthService implements OnModuleInit, OnModuleDestroy {
  private tokenRefreshWorker: Worker;

  constructor(
    private readonly prisma: PrismaService,
    private readonly secretVault: SecretVaultService,
  ) {}

  async onModuleInit() {
    const redisConfig = {
      host: process.env.REDIS_HOST || 'localhost',
      port: parseInt(process.env.REDIS_PORT || '6379', 10),
    };

    // BullMQ Worker to handle token refreshing tasks
    this.tokenRefreshWorker = new Worker(
      'integration-token-refresh',
      async (job: Job) => {
        console.log(`Processing Token Refresh Job: ${job.id}`);
        const { workspaceId, provider } = job.data;

        try {
          await this.refreshAccessToken(workspaceId, provider);
          console.log(`Successfully rotated OAuth token for ${provider} in workspace ${workspaceId}`);
        } catch (error) {
          console.error(`Token rotation failed for ${provider} in workspace ${workspaceId}: ${error.message}`);
          
          // Update installation and sync status to FAILED / SUSPENDED
          const installation = await this.prisma.integrationInstallation.findFirst({
            where: {
              workspaceId,
              integration: {
                provider: provider.toUpperCase(),
              },
            },
          });

          if (installation) {
            await this.prisma.integrationInstallation.update({
              where: { id: installation.id },
              data: {
                status: 'SUSPENDED',
                syncStatus: 'FAILED',
              },
            });
          }

          // Notify admins in the workspace
          const admins = await this.prisma.workspaceMember.findMany({
            where: {
              workspaceId,
              role: 'ADMIN',
            },
          });

          for (const admin of admins) {
            await this.prisma.notification.create({
              data: {
                userId: admin.userId,
                title: 'Integration Suspended',
                message: `Your connection to ${provider} was suspended due to token refresh failure. Please reconnect.`,
                type: 'INTEGRATION_SUSPENDED',
                entityType: 'INTEGRATION',
                entityId: provider.toUpperCase(),
              },
            });
          }
        }
      },
      { connection: redisConfig },
    );

    this.tokenRefreshWorker.on('failed', (job, err) => {
      console.error(`Token refresh job failed: ${job?.id} with error: ${err.message}`);
    });
  }

  async onModuleDestroy() {
    if (this.tokenRefreshWorker) {
      await this.tokenRefreshWorker.close();
    }
  }

  async getRedirectUrl(provider: string, workspaceId: string): Promise<string> {
    const clientId = process.env[`${provider.toUpperCase()}_CLIENT_ID`] || 'mock-client-id';
    const redirectUri = `${process.env.APP_URL || 'http://localhost:3000'}/oauth/${provider}/callback`;
    
    switch (provider.toLowerCase()) {
      case 'github':
        return `https://github.com/login/oauth/authorize?client_id=${clientId}&redirect_uri=${redirectUri}&state=${workspaceId}&scope=repo,user,admin:repo_hook`;
      case 'gitlab':
        return `https://gitlab.com/oauth/authorize?client_id=${clientId}&redirect_uri=${redirectUri}&response_type=code&state=${workspaceId}&scope=api,read_user`;
      case 'google':
        return `https://accounts.google.com/o/oauth2/v2/auth?client_id=${clientId}&redirect_uri=${redirectUri}&response_type=code&state=${workspaceId}&scope=https://www.googleapis.com/auth/calendar https://www.googleapis.com/auth/drive.readonly&access_type=offline&prompt=consent`;
      case 'microsoft':
        return `https://login.microsoftonline.com/common/oauth2/v2.0/authorize?client_id=${clientId}&redirect_uri=${redirectUri}&response_type=code&state=${workspaceId}&scope=offline_access Calendars.ReadWrite Files.ReadWrite.All`;
      case 'slack':
        return `https://slack.com/oauth/v2/authorize?client_id=${clientId}&redirect_uri=${redirectUri}&state=${workspaceId}&scope=incoming-webhook,commands,chat:write`;
      default:
        throw new Error(`Unsupported OAuth provider: ${provider}`);
    }
  }

  async connectProvider(workspaceId: string, provider: string, code: string) {
    // In production: perform exchange POST request to provider OAuth endpoint
    // We mock the tokens exchange for simulation
    const mockAccessToken = `mock_access_token_${provider}_${Math.random().toString(36).substring(2)}`;
    const mockRefreshToken = `mock_refresh_token_${provider}_${Math.random().toString(36).substring(2)}`;
    const expiresAt = new Date(Date.now() + 3600 * 1000); // 1 hour expiration

    const encryptedAccess = this.secretVault.encrypt(mockAccessToken);
    const encryptedRefresh = this.secretVault.encrypt(mockRefreshToken);

    const credential = await this.prisma.integrationCredential.upsert({
      where: {
        id: `${workspaceId}_${provider.toUpperCase()}`, // unique ID pattern for simple demo
      },
      update: {
        encryptedAccessToken: encryptedAccess,
        encryptedRefreshToken: encryptedRefresh,
        expiresAt,
      },
      create: {
        id: `${workspaceId}_${provider.toUpperCase()}`,
        workspaceId,
        provider: provider.toUpperCase(),
        encryptedAccessToken: encryptedAccess,
        encryptedRefreshToken: encryptedRefresh,
        expiresAt,
      },
    });

    return {
      success: true,
      provider: provider.toUpperCase(),
      expiresAt: credential.expiresAt,
    };
  }

  async getCredentials(workspaceId: string, provider: string) {
    const cred = await this.prisma.integrationCredential.findFirst({
      where: {
        workspaceId,
        provider: provider.toUpperCase(),
      },
    });

    if (!cred) {
      throw new UnauthorizedException(`No credentials found for provider ${provider}`);
    }

    // Return decrypted tokens
    const accessToken = this.secretVault.decrypt(cred.encryptedAccessToken);
    const refreshToken = cred.encryptedRefreshToken
      ? this.secretVault.decrypt(cred.encryptedRefreshToken)
      : null;

    return {
      accessToken,
      refreshToken,
      expiresAt: cred.expiresAt,
    };
  }

  async refreshAccessToken(workspaceId: string, provider: string) {
    const cred = await this.prisma.integrationCredential.findFirst({
      where: {
        workspaceId,
        provider: provider.toUpperCase(),
      },
    });

    if (!cred || !cred.encryptedRefreshToken) {
      throw new UnauthorizedException(`No refresh token available for provider ${provider}`);
    }

    const decryptedRefresh = this.secretVault.decrypt(cred.encryptedRefreshToken);

    // Simulate requesting token refreshing from OAuth endpoints
    const newAccessToken = `mock_refreshed_access_${provider}_${Math.random().toString(36).substring(2)}`;
    const newExpiresAt = new Date(Date.now() + 3600 * 1000);

    const newEncryptedAccess = this.secretVault.encrypt(newAccessToken);

    await this.prisma.integrationCredential.update({
      where: { id: cred.id },
      data: {
        encryptedAccessToken: newEncryptedAccess,
        expiresAt: newExpiresAt,
      },
    });

    return newAccessToken;
  }
}

