import { Test, TestingModule } from '@nestjs/testing';
import { IntegrationFabricService } from '../integration-fabric.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('IntegrationFabricService', () => {
  let service: IntegrationFabricService;

  const mockPrisma = {};

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        IntegrationFabricService,
        { provide: PrismaService, useValue: mockPrisma },
      ],
    }).compile();

    service = module.get<IntegrationFabricService>(IntegrationFabricService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
