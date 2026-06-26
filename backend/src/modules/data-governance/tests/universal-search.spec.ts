import { Test, TestingModule } from '@nestjs/testing';
import { UniversalSearchService } from '../universal-search.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('UniversalSearchService', () => {
  let service: UniversalSearchService;

  const mockPrisma = {};

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        UniversalSearchService,
        { provide: PrismaService, useValue: mockPrisma },
      ],
    }).compile();

    service = module.get<UniversalSearchService>(UniversalSearchService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
