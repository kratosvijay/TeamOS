import { Test, TestingModule } from '@nestjs/testing';
import { ConnectorRuntimeService } from '../connector-runtime.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('ConnectorRuntimeService', () => {
  let service: ConnectorRuntimeService;

  const mockPrismaService = {
    connector: { create: jest.fn(), findMany: jest.fn() },
    integrationFlow: { create: jest.fn(), findMany: jest.fn() },
    apiProduct: { create: jest.fn(), findMany: jest.fn() },
    eventTopic: { create: jest.fn(), findMany: jest.fn() },
    dataPipeline: { create: jest.fn(), findMany: jest.fn() },
    ocrDocument: { create: jest.fn(), findMany: jest.fn() },
    rpaBot: { create: jest.fn(), findMany: jest.fn() },
    tradingPartner: { create: jest.fn(), findMany: jest.fn() },
    syncProfile: { create: jest.fn(), findMany: jest.fn() }
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ConnectorRuntimeService,
        { provide: PrismaService, useValue: mockPrismaService },
      ],
    }).compile();

    service = module.get<ConnectorRuntimeService>(ConnectorRuntimeService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
