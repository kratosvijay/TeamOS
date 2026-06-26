import { Test, TestingModule } from '@nestjs/testing';
import { IntegrationAnalyticsService } from '../integration-analytics.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('IntegrationAnalyticsService', () => {
  let service: IntegrationAnalyticsService;

  const mockPrisma = {};

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        IntegrationAnalyticsService,
        { provide: PrismaService, useValue: mockPrisma },
      ],
    }).compile();

    service = module.get<IntegrationAnalyticsService>(IntegrationAnalyticsService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
