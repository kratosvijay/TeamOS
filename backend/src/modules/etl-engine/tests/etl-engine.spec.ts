import { Test, TestingModule } from '@nestjs/testing';
import { EtlEngineService } from '../etl-engine.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('EtlEngineService', () => {
  let service: EtlEngineService;

  const mockPrisma = {};

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        EtlEngineService,
        { provide: PrismaService, useValue: mockPrisma },
      ],
    }).compile();

    service = module.get<EtlEngineService>(EtlEngineService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
