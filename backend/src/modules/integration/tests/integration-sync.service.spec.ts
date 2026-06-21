import { Test, TestingModule } from '@nestjs/testing';
import { IntegrationSyncService } from '../integration-sync.service';
import { PrismaService } from '../../prisma/prisma.service';
import { IntegrationSyncStatus } from '@prisma/client';

describe('IntegrationSyncService', () => {
  let service: IntegrationSyncService;
  let prisma: PrismaService;

  const mockPrisma = {
    integrationInstallation: {
      update: jest.fn(),
      findUnique: jest.fn(),
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        IntegrationSyncService,
        { provide: PrismaService, useValue: mockPrisma },
      ],
    }).compile();

    service = module.get<IntegrationSyncService>(IntegrationSyncService);
    prisma = module.get<PrismaService>(PrismaService);
  });

  it('should update sync status correctly', async () => {
    mockPrisma.integrationInstallation.update.mockResolvedValue({});

    await service.updateSyncStatus('install-1', IntegrationSyncStatus.SYNCED);
    expect(mockPrisma.integrationInstallation.update).toHaveBeenCalledWith({
      where: { id: 'install-1' },
      data: { syncStatus: IntegrationSyncStatus.SYNCED },
    });
  });

  it('should transition through sync lifecycle statuses during triggering', async () => {
    mockPrisma.integrationInstallation.update.mockResolvedValue({});
    mockPrisma.integrationInstallation.findUnique.mockResolvedValue({
      id: 'install-1',
      status: 'ACTIVE',
      integration: { provider: 'GITHUB' },
    });

    await service.triggerSync('install-1');
    expect(mockPrisma.integrationInstallation.update).toHaveBeenCalledWith({
      where: { id: 'install-1' },
      data: { syncStatus: IntegrationSyncStatus.SYNCING },
    });
    expect(mockPrisma.integrationInstallation.update).toHaveBeenLastCalledWith({
      where: { id: 'install-1' },
      data: { syncStatus: IntegrationSyncStatus.SYNCED },
    });
  });
});
