import { Test, TestingModule } from '@nestjs/testing';
import { DataMarketplaceService } from '../data-marketplace.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('DataMarketplaceService', () => {
  let service: DataMarketplaceService;

  const mockPrisma = {};

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        DataMarketplaceService,
        { provide: PrismaService, useValue: mockPrisma },
      ],
    }).compile();

    service = module.get<DataMarketplaceService>(DataMarketplaceService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
