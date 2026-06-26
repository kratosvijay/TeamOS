import { Test, TestingModule } from '@nestjs/testing';
import { ReverseEtlService } from '../reverse-etl.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('ReverseEtlService', () => {
  let service: ReverseEtlService;

  const mockPrisma = {};

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ReverseEtlService,
        { provide: PrismaService, useValue: mockPrisma },
      ],
    }).compile();

    service = module.get<ReverseEtlService>(ReverseEtlService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
