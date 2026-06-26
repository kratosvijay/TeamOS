import { Test, TestingModule } from '@nestjs/testing';
import { IntegrationSandboxService } from '../integration-sandbox.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('IntegrationSandboxService', () => {
  let service: IntegrationSandboxService;

  const mockPrisma = {};

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        IntegrationSandboxService,
        { provide: PrismaService, useValue: mockPrisma },
      ],
    }).compile();

    service = module.get<IntegrationSandboxService>(IntegrationSandboxService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
