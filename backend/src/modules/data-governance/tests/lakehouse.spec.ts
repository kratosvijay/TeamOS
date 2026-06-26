import { Test, TestingModule } from '@nestjs/testing';
import { LakehouseService } from '../lakehouse.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('LakehouseService', () => {
  let service: LakehouseService;

  const mockPrisma = {};

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        LakehouseService,
        { provide: PrismaService, useValue: mockPrisma },
      ],
    }).compile();

    service = module.get<LakehouseService>(LakehouseService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
