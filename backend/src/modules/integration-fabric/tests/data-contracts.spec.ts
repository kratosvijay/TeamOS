import { Test, TestingModule } from '@nestjs/testing';
import { DataContractsService } from '../data-contracts.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('DataContractsService', () => {
  let service: DataContractsService;

  const mockPrisma = {};

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        DataContractsService,
        { provide: PrismaService, useValue: mockPrisma },
      ],
    }).compile();

    service = module.get<DataContractsService>(DataContractsService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
