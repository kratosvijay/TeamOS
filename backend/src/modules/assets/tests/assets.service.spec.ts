import { Test, TestingModule } from '@nestjs/testing';
import { AssetsService } from '../assets.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('AssetsService', () => {
  let service: AssetsService;
  let prisma: PrismaService;

  const mockPrismaService = {
    eRPAsset: {
      create: jest.fn(),
      findMany: jest.fn(),
      findUnique: jest.fn(),
    },
    assetMaintenance: {
      create: jest.fn(),
      findMany: jest.fn(),
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AssetsService,
        { provide: PrismaService, useValue: mockPrismaService },
      ],
    }).compile();

    service = module.get<AssetsService>(AssetsService);
    prisma = module.get<PrismaService>(PrismaService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should create asset', async () => {
    mockPrismaService.eRPAsset.create.mockResolvedValue({ id: 'a-1', name: 'Server Rack 1' });

    const result = await service.createAsset('ws-1', 'Server Rack 1', 'Hardware', 8500);
    expect(result.name).toBe('Server Rack 1');
  });

  it('should schedule maintenance task', async () => {
    mockPrismaService.eRPAsset.findUnique.mockResolvedValue({ id: 'a-1' });
    mockPrismaService.assetMaintenance.create.mockResolvedValue({ id: 'm-1', title: 'Monthly Clean' });

    const result = await service.scheduleMaintenance('a-1', 'Monthly Clean', new Date('2026-07-01'));
    expect(result.title).toBe('Monthly Clean');
  });
});
