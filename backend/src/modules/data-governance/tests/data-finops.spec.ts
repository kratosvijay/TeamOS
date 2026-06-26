import { Test, TestingModule } from '@nestjs/testing';
import { DataFinopsService } from '../data-finops.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('DataFinopsService', () => {
  let service: DataFinopsService;

  const mockPrisma = {};

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        DataFinopsService,
        { provide: PrismaService, useValue: mockPrisma },
      ],
    }).compile();

    service = module.get<DataFinopsService>(DataFinopsService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
