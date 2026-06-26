import { Test, TestingModule } from '@nestjs/testing';
import { MetadataDiscoveryService } from '../metadata-discovery.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('MetadataDiscoveryService', () => {
  let service: MetadataDiscoveryService;

  const mockPrisma = {};

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        MetadataDiscoveryService,
        { provide: PrismaService, useValue: mockPrisma },
      ],
    }).compile();

    service = module.get<MetadataDiscoveryService>(MetadataDiscoveryService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
