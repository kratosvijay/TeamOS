import { Test, TestingModule } from '@nestjs/testing';
import { SecretVaultService } from '../secret-vault.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('SecretVaultService', () => {
  let service: SecretVaultService;
  let prisma: PrismaService;

  const mockPrisma = {
    auditTrail: {
      create: jest.fn(),
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        SecretVaultService,
        { provide: PrismaService, useValue: mockPrisma },
      ],
    }).compile();

    service = module.get<SecretVaultService>(SecretVaultService);
    prisma = module.get<PrismaService>(PrismaService);
  });

  it('should encrypt and decrypt a secret correctly', () => {
    const secret = 'my-secret-access-token';
    const encrypted = service.encrypt(secret);
    expect(encrypted).toContain(':');

    const decrypted = service.decrypt(encrypted);
    expect(decrypted).toBe(secret);
  });

  it('should mask a secret correctly', () => {
    const secret = 'gho_1234567890abcdef';
    const masked = service.maskSecret(secret);
    expect(masked).toBe('gho_****cdef');
  });

  it('should create audit logs on secret access', async () => {
    await service.auditAccess('workspace-1', 'user-1', 'ACCESS_TOKEN_GET', 'GITHUB');
    expect(mockPrisma.auditTrail.create).toHaveBeenCalled();
  });
});
