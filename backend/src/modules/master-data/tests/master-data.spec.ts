import { Test, TestingModule } from '@nestjs/testing';
import { MasterDataService } from '../master-data.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('MasterDataService', () => {
  let service: MasterDataService;

  const mockPrisma = {};

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        MasterDataService,
        { provide: PrismaService, useValue: mockPrisma },
      ],
    }).compile();

    service = module.get<MasterDataService>(MasterDataService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
