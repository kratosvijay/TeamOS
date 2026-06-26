import { Test, TestingModule } from '@nestjs/testing';
import { CdcRegistryService } from '../cdc-registry.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('CdcRegistryService', () => {
  let service: CdcRegistryService;

  const mockPrisma = {};

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        CdcRegistryService,
        { provide: PrismaService, useValue: mockPrisma },
      ],
    }).compile();

    service = module.get<CdcRegistryService>(CdcRegistryService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
