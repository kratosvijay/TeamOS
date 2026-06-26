import { Test, TestingModule } from '@nestjs/testing';
import { DatasetSlaService } from '../dataset-sla.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('DatasetSlaService', () => {
  let service: DatasetSlaService;

  const mockPrisma = {};

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        DatasetSlaService,
        { provide: PrismaService, useValue: mockPrisma },
      ],
    }).compile();

    service = module.get<DatasetSlaService>(DatasetSlaService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
