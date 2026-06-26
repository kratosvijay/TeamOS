import { Test, TestingModule } from '@nestjs/testing';
import { DataProductService } from '../data-product.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('DataProductService', () => {
  let service: DataProductService;

  const mockPrisma = {};

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        DataProductService,
        { provide: PrismaService, useValue: mockPrisma },
      ],
    }).compile();

    service = module.get<DataProductService>(DataProductService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
