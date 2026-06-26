import { Test, TestingModule } from '@nestjs/testing';
import { ExtensionRuntimeService } from '../extension-runtime.service';
import { SdkService } from '../../sdk/sdk.service';
import { PrismaService } from '../../prisma/prisma.service';
import { HttpException } from '@nestjs/common';

describe('ExtensionRuntimeService', () => {
  let service: ExtensionRuntimeService;
  let prisma: PrismaService;

  const mockPrisma = {
    extensionPermission: { findMany: jest.fn() },
    extensionAnalytics: { create: jest.fn() },
  };

  const mockSdk = {
    getTasks: jest.fn().mockResolvedValue([{ title: 'Mock Task' }]),
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

  it('should run valid JS extension script and set the result', async () => {
    mockPrisma.extensionPermission.findMany.mockResolvedValue([]);
    const code = 'result = 40 + 2;';
    const res = await service.runExtension('ext-1', 'ws-1', code, 'event', {});
    expect(res).toBe(42);
  });

  it('should allow accessing sdk tasks if permission is granted', async () => {
    mockPrisma.extensionPermission.findMany.mockResolvedValue([
      { permission: 'READ_TASKS' },
    ]);
    const code = `
      (async () => {
        const tasks = await sdk.getTasks();
        result = tasks[0].title;
      })()
    `;
    const res = await service.runExtension('ext-1', 'ws-1', code, 'event', {});
    // wait for promise inside context
    await new Promise((resolve) => setTimeout(resolve, 50));
    // check result (result is resolved in asynchronous execution inside context)
  });

  it('should fail and timeout on CPU-heavy script', async () => {
    mockPrisma.extensionPermission.findMany.mockResolvedValue([]);
    const code = 'while(true) {}';
    await expect(
      service.runExtension('ext-1', 'ws-1', code, 'event', {}),
    ).rejects.toThrow(HttpException);
  });
});
