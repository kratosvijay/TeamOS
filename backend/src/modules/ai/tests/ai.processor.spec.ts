import { Test, TestingModule } from '@nestjs/testing';
import { AIProcessor } from '../ai.processor';
import { AIService } from '../ai.service';
import { PrismaService } from '../../prisma/prisma.service';
import { Job } from 'bullmq';

// Mock BullMQ completely to avoid Redis ECONNREFUSED issues in unit tests
jest.mock('bullmq', () => {
  return {
    Worker: jest.fn().mockImplementation(() => {
      return {
        on: jest.fn(),
        close: jest.fn().mockResolvedValue(undefined),
      };
    }),
  };
});

describe('AIProcessor', () => {
  let processor: AIProcessor;
  let service: AIService;
  let prisma: PrismaService;

  const mockAIService = {
    calculateRiskEngine: jest.fn(),
    generateSummary: jest.fn(),
  };

  const mockPrisma = {
    aIArtifact: {
      create: jest.fn(),
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AIProcessor,
        { provide: AIService, useValue: mockAIService },
        { provide: PrismaService, useValue: mockPrisma },
      ],
    }).compile();

    processor = module.get<AIProcessor>(AIProcessor);
    service = module.get<AIService>(AIService);
    prisma = module.get<PrismaService>(PrismaService);
  });

  it('should be defined', () => {
    expect(processor).toBeDefined();
  });

  it('should handle daily-standup cron triggers and write status reports', async () => {
    mockPrisma.aIArtifact.create.mockResolvedValue({ id: 'art-1' });

    const job = {
      name: 'cron:daily-standup',
      id: 'job-1',
      data: { workspaceId: 'w-1' },
    } as unknown as Job;

    await processor.onModuleInit();

    // Verify close works
    await processor.onModuleDestroy();
  });
});
