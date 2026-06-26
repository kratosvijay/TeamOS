import { Test, TestingModule } from '@nestjs/testing';
import { ApiGatewayService } from '../api-gateway.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('ApiGatewayService', () => {
  let service: ApiGatewayService;

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
        ApiGatewayService,
        { provide: PrismaService, useValue: mockPrismaService },
      ],
    }).compile();

    service = module.get<ApiGatewayService>(ApiGatewayService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
