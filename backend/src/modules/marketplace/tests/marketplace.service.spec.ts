import { Test, TestingModule } from '@nestjs/testing';
import { MarketplaceService } from '../marketplace.service';
import { PrismaService } from '../../prisma/prisma.service';
import { IntegrationService } from '../../integration/integration.service';
import { IntegrationPermission } from '@prisma/client';

describe('MarketplaceService', () => {
  let service: MarketplaceService;
  let prisma: PrismaService;

  const mockPrisma = {
    developerApp: {
      findMany: jest.fn().mockResolvedValue([{ id: 'db-app-1', name: 'App DB', slug: 'app-db', rating: 4.0, downloads: 10, status: 'APPROVED' }]),
      findFirst: jest.fn(),
      update: jest.fn(),
    },
    installedExtension: {
      create: jest.fn(),
      findFirst: jest.fn(),
      delete: jest.fn(),
    },
    marketplaceReview: {
      create: jest.fn(),
      findMany: jest.fn(),
    },
  };

  const mockIntegration = {
    installIntegration: jest.fn().mockResolvedValue({ id: 'integration-id' }),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        MarketplaceService,
        { provide: PrismaService, useValue: mockPrisma },
        { provide: IntegrationService, useValue: mockIntegration },
      ],
    }).compile();

    service = module.get<MarketplaceService>(MarketplaceService);
    prisma = module.get<PrismaService>(PrismaService);
  });

  it('should list catalog items from static + DB approved apps', async () => {
    const catalog = await service.getCatalog();
    expect(catalog.length).toBeGreaterThan(2);
    expect(catalog.find((c) => c.name === 'App DB')).toBeDefined();
  });

  it('should install app and record to InstalledExtension table', async () => {
    mockPrisma.developerApp.findFirst.mockResolvedValue({ id: 'db-app-1', slug: 'github', downloads: 10 });
    mockPrisma.developerApp.update.mockResolvedValue({});
    mockPrisma.installedExtension.create.mockResolvedValue({ id: 'inst-1' });

    const result = await service.installMarketplaceIntegration(
      'ws-1',
      'user-1',
      'GITHUB',
      IntegrationPermission.READ_ONLY,
    );

    expect(result.id).toBe('integration-id');
    expect(mockPrisma.installedExtension.create).toHaveBeenCalled();
  });

  it('should submit reviews and update app rating', async () => {
    mockPrisma.marketplaceReview.create.mockResolvedValue({ id: 'rev-1', rating: 5 });
    mockPrisma.marketplaceReview.findMany.mockResolvedValue([{ rating: 4 }, { rating: 5 }]);
    mockPrisma.developerApp.update.mockResolvedValue({});

    const review = await service.addReview('db-app-1', 'Reviewer', 5, 'Great app!');
    expect(review.id).toBe('rev-1');
    expect(mockPrisma.developerApp.update).toHaveBeenCalledWith({
      where: { id: 'db-app-1' },
      data: { rating: 4.5 },
    });
  });
});
