import { Test, TestingModule } from '@nestjs/testing';
import { DataFederationService } from '../data-federation.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('DataFederationService', () => {
  let service: DataFederationService;

  const mockPrisma = {};

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        DataFederationService,
        { provide: PrismaService, useValue: mockPrisma },
      ],
    }).compile();

    service = module.get<DataFederationService>(DataFederationService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
