import { Test, TestingModule } from '@nestjs/testing';
import { ConnectorGeneratorService } from '../connector-generator.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('ConnectorGeneratorService', () => {
  let service: ConnectorGeneratorService;

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
        ConnectorGeneratorService,
        { provide: PrismaService, useValue: mockPrismaService },
      ],
    }).compile();

    service = module.get<ConnectorGeneratorService>(ConnectorGeneratorService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
