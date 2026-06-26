import { Test, TestingModule } from '@nestjs/testing';
import { FlowRuntimeService } from '../flow-runtime.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('FlowRuntimeService', () => {
  let service: FlowRuntimeService;

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
        FlowRuntimeService,
        { provide: PrismaService, useValue: mockPrismaService },
      ],
    }).compile();

    service = module.get<FlowRuntimeService>(FlowRuntimeService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
