import { Test, TestingModule } from '@nestjs/testing';
import { DataQualityEngineService } from '../data-quality-engine.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('DataQualityEngineService', () => {
  let service: DataQualityEngineService;

  const mockPrisma = {};

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        DataQualityEngineService,
        { provide: PrismaService, useValue: mockPrisma },
      ],
    }).compile();

    service = module.get<DataQualityEngineService>(DataQualityEngineService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
