import { Test, TestingModule } from '@nestjs/testing';
import { DataReliabilityService } from '../data-reliability.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('DataReliabilityService', () => {
  let service: DataReliabilityService;

  const mockPrisma = {};

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        DataReliabilityService,
        { provide: PrismaService, useValue: mockPrisma },
      ],
    }).compile();

    service = module.get<DataReliabilityService>(DataReliabilityService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
