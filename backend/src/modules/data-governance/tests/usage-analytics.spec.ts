import { Test, TestingModule } from '@nestjs/testing';
import { UsageAnalyticsService } from '../usage-analytics.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('UsageAnalyticsService', () => {
  let service: UsageAnalyticsService;

  const mockPrisma = {};

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        UsageAnalyticsService,
        { provide: PrismaService, useValue: mockPrisma },
      ],
    }).compile();

    service = module.get<UsageAnalyticsService>(UsageAnalyticsService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
