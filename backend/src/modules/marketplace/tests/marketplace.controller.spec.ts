import { Test, TestingModule } from '@nestjs/testing';
import { MarketplaceController } from '../marketplace.controller';
import { MarketplaceService } from '../marketplace.service';
import { PrismaService } from '../../prisma/prisma.service';
import { JwtStrategy } from '../../auth/jwt.strategy';

describe('MarketplaceController', () => {
  let controller: MarketplaceController;
  let service: MarketplaceService;

  const mockMarketplaceService = {
    getCatalog: jest.fn(),
    installMarketplaceIntegration: jest.fn(),
  };

  const mockPrisma = {
    workspaceMember: {
      findUnique: jest.fn(),
    },
  };

  const mockJwtStrategy = {
    validateToken: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [MarketplaceController],
      providers: [
        { provide: MarketplaceService, useValue: mockMarketplaceService },
        { provide: PrismaService, useValue: mockPrisma },
        { provide: JwtStrategy, useValue: mockJwtStrategy },
      ],
    }).compile();

    controller = module.get<MarketplaceController>(MarketplaceController);
    service = module.get<MarketplaceService>(MarketplaceService);
  });

  it('should return catalog listing', async () => {
    mockMarketplaceService.getCatalog.mockResolvedValue([]);
    const res = await controller.getCatalog();
    expect(res).toEqual([]);
  });

  it('should install catalog integration', async () => {
    mockMarketplaceService.installMarketplaceIntegration.mockResolvedValue({ id: 'install-1' });
    const req = { user: { id: 'user-1' } };

    const res = await controller.install('workspace-1', req, 'GITHUB');
    expect(res.id).toBe('install-1');
  });
});
