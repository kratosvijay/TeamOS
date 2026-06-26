import { Test, TestingModule } from '@nestjs/testing';
import { SdkService } from '../sdk.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('SdkService', () => {
  let service: SdkService;
  let prisma: PrismaService;

  const mockPrisma = {
    workspace: { findUnique: jest.fn() },
    aPIKey: { findUnique: jest.fn(), update: jest.fn() },
    task: { findMany: jest.fn() },
    document: { findMany: jest.fn() },
    meeting: { findMany: jest.fn() },
    invoice: { findMany: jest.fn() },
    budget: { findMany: jest.fn() },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        SdkService,
        { provide: PrismaService, useValue: mockPrisma },
      ],
    }).compile();

    service = module.get<SdkService>(SdkService);
    prisma = module.get<PrismaService>(PrismaService);
  });

  it('should verify valid API keys and update lastUsed', async () => {
    mockPrisma.aPIKey.findUnique.mockResolvedValue({
      id: 'key-1',
      workspaceId: 'ws-1',
      expiresAt: null,
    });
    mockPrisma.aPIKey.update.mockResolvedValue({});

    const result = await service.verifyApiKey('hash');
    expect(result).toBeDefined();
    expect(result.id).toBe('key-1');
  });

  it('should fetch storage configuration', async () => {
    const settings = await service.getStorageSettings('ws-1');
    expect(settings.bucket).toBe('workspace-ws-1-bucket');
  });

  it('should mock AI completions', async () => {
    const ai = await service.executeAiCompletion('hello');
    expect(ai.text).toContain('Mocked AI response');
  });
});
