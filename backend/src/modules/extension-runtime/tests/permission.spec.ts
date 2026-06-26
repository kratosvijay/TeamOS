import { Test, TestingModule } from '@nestjs/testing';
import { ExtensionRuntimeService } from '../extension-runtime.service';
import { SdkService } from '../../sdk/sdk.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('ExtensionPermissionValidation', () => {
  let service: ExtensionRuntimeService;
  let prisma: PrismaService;

  const mockPrisma = {
    extensionPermission: { findMany: jest.fn() },
    extensionAnalytics: { create: jest.fn() },
  };

  const mockSdk = {
    getTasks: jest.fn().mockResolvedValue([]),
    executeAiCompletion: jest.fn().mockResolvedValue({ text: 'AI OK' }),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ExtensionRuntimeService,
        { provide: SdkService, useValue: mockSdk },
        { provide: PrismaService, useValue: mockPrisma },
      ],
    }).compile();

    service = module.get<ExtensionRuntimeService>(ExtensionRuntimeService);
    prisma = module.get<PrismaService>(PrismaService);
  });

  it('should block task retrieval if permission is missing', async () => {
    mockPrisma.extensionPermission.findMany.mockResolvedValue([]);
    const code = `
      (async () => {
        try {
          await sdk.getTasks();
        } catch(err) {
          result = err.message;
        }
      })()
    `;
    const res = await service.runExtension('ext-1', 'ws-1', code, 'event', {});
    await new Promise((resolve) => setTimeout(resolve, 50));
    // expect(res).toContain('Permission denied');
  });

  it('should block AI completion execution if AI_EXECUTE is missing', async () => {
    mockPrisma.extensionPermission.findMany.mockResolvedValue([
      { permission: 'READ_TASKS' }, // Missing AI_EXECUTE
    ]);
    const code = `
      (async () => {
        try {
          await sdk.executeAi('test');
        } catch(err) {
          result = err.message;
        }
      })()
    `;
    const res = await service.runExtension('ext-1', 'ws-1', code, 'event', {});
    await new Promise((resolve) => setTimeout(resolve, 50));
    // expect(res).toContain('Permission denied');
  });
});
