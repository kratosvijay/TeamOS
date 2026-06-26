import { Test, TestingModule } from '@nestjs/testing';
import { DataObservabilityService } from '../data-observability.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('DataObservabilityService', () => {
  let service: DataObservabilityService;

  const mockPrisma = {};

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        DataObservabilityService,
        { provide: PrismaService, useValue: mockPrisma },
      ],
    }).compile();

    service = module.get<DataObservabilityService>(DataObservabilityService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
