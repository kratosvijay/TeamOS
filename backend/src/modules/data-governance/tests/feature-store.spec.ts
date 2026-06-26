import { Test, TestingModule } from '@nestjs/testing';
import { FeatureStoreService } from '../feature-store.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('FeatureStoreService', () => {
  let service: FeatureStoreService;

  const mockPrisma = {};

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        FeatureStoreService,
        { provide: PrismaService, useValue: mockPrisma },
      ],
    }).compile();

    service = module.get<FeatureStoreService>(FeatureStoreService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
