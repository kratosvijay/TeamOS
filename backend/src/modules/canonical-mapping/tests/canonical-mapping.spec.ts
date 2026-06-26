import { Test, TestingModule } from '@nestjs/testing';
import { CanonicalMappingService } from '../canonical-mapping.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('CanonicalMappingService', () => {
  let service: CanonicalMappingService;

  const mockPrisma = {};

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        CanonicalMappingService,
        { provide: PrismaService, useValue: mockPrisma },
      ],
    }).compile();

    service = module.get<CanonicalMappingService>(CanonicalMappingService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
