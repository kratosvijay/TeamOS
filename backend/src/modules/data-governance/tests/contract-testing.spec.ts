import { Test, TestingModule } from '@nestjs/testing';
import { ContractTestingService } from '../contract-testing.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('ContractTestingService', () => {
  let service: ContractTestingService;

  const mockPrisma = {};

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ContractTestingService,
        { provide: PrismaService, useValue: mockPrisma },
      ],
    }).compile();

    service = module.get<ContractTestingService>(ContractTestingService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
