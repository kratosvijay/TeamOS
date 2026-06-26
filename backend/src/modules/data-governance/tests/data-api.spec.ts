import { Test, TestingModule } from '@nestjs/testing';
import { DataApiService } from '../data-api.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('DataApiService', () => {
  let service: DataApiService;

  const mockPrisma = {};

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        DataApiService,
        { provide: PrismaService, useValue: mockPrisma },
      ],
    }).compile();

    service = module.get<DataApiService>(DataApiService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
