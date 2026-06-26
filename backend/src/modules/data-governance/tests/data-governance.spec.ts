import { Test, TestingModule } from '@nestjs/testing';
import { DataGovernanceService } from '../data-governance.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('DataGovernanceService', () => {
  let service: DataGovernanceService;

  const mockPrisma = {};

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        DataGovernanceService,
        { provide: PrismaService, useValue: mockPrisma },
      ],
    }).compile();

    service = module.get<DataGovernanceService>(DataGovernanceService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
