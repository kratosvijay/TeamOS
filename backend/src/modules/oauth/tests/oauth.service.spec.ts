import { Test, TestingModule } from '@nestjs/testing';
import { OAuthService } from '../oauth.service';
import { PrismaService } from '../../prisma/prisma.service';
import { SecretVaultService } from '../../secret-vault/secret-vault.service';

describe('OAuthService', () => {
  let service: OAuthService;
  let prisma: PrismaService;
  let vault: SecretVaultService;

  const mockPrisma = {
    integrationCredential: {
      upsert: jest.fn(),
      findFirst: jest.fn(),
      update: jest.fn(),
    },
    integrationInstallation: {
      findFirst: jest.fn(),
      update: jest.fn(),
    },
    workspaceMember: {
      findMany: jest.fn(),
    },
    notification: {
      create: jest.fn(),
    },
  };

  const mockVault = {
    encrypt: jest.fn((text) => `enc:${text}`),
    decrypt: jest.fn((text) => text.replace('enc:', '')),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        OAuthService,
        { provide: PrismaService, useValue: mockPrisma },
        { provide: SecretVaultService, useValue: mockVault },
      ],
    }).compile();

    service = module.get<OAuthService>(OAuthService);
    prisma = module.get<PrismaService>(PrismaService);
    vault = module.get<SecretVaultService>(SecretVaultService);
  });

  afterEach(async () => {
    await service.onModuleDestroy();
  });

  it('should generate redirect urls correctly', async () => {
    const url = await service.getRedirectUrl('github', 'workspace-1');
    expect(url).toContain('github.com');
    expect(url).toContain('workspace-1');
  });

  it('should connect provider and store encrypted credentials', async () => {
    mockPrisma.integrationCredential.upsert.mockResolvedValue({
      id: 'cred-1',
      expiresAt: new Date(),
    });

    const result = await service.connectProvider('workspace-1', 'github', 'auth-code');
    expect(result.success).toBe(true);
    expect(vault.encrypt).toHaveBeenCalled();
  });

  it('should retrieve decrypted credentials', async () => {
    mockPrisma.integrationCredential.findFirst.mockResolvedValue({
      encryptedAccessToken: 'enc:token123',
      encryptedRefreshToken: 'enc:refresh123',
      expiresAt: new Date(),
    });

    const creds = await service.getCredentials('workspace-1', 'github');
    expect(creds.accessToken).toBe('token123');
    expect(creds.refreshToken).toBe('refresh123');
  });
});
