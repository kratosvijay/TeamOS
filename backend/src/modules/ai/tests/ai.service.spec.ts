import { Test, TestingModule } from '@nestjs/testing';
import { AIService } from '../ai.service';
import { PrismaService } from '../../prisma/prisma.service';
import { SearchService } from '../../search/search.service';
import { MCPService } from '../../mcp/mcp.service';
import { ForbiddenException } from '@nestjs/common';

describe('AIService', () => {
  let service: AIService;
  let prisma: PrismaService;
  let mcpService: MCPService;

  const mockPrisma = {
    aIBudget: {
      findUnique: jest.fn(),
    },
    aIUsageLog: {
      findMany: jest.fn(),
      create: jest.fn(),
    },
    aIAgent: {
      findFirst: jest.fn(),
    },
    aIWorkspaceMemory: {
      findUnique: jest.fn(),
    },
    aIModelPolicy: {
      findFirst: jest.fn(),
    },
    aIMessage: {
      create: jest.fn(),
    },
    documentEmbedding: {
      findMany: jest.fn(),
    },
    task: {
      findMany: jest.fn(),
    },
    aIPendingAction: {
      create: jest.fn(),
    },
  };

  const mockSearchService = {
    search: jest.fn(),
  };

  const mockMCPService = {
    retrieveContext: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AIService,
        { provide: PrismaService, useValue: mockPrisma },
        { provide: SearchService, useValue: mockSearchService },
        { provide: MCPService, useValue: mockMCPService },
      ],
    }).compile();

    service = module.get<AIService>(AIService);
    prisma = module.get<PrismaService>(PrismaService);
    mcpService = module.get<MCPService>(MCPService);
    await service.onModuleInit();
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  it('should block execution if workspace cost exceeds monthly budget', async () => {
    mockPrisma.aIBudget.findUnique.mockResolvedValue({
      workspaceId: 'w-1',
      monthlyLimit: 10.0,
      warningThreshold: 8.0,
    });

    mockPrisma.aIUsageLog.findMany.mockResolvedValue([
      { cost: 6.0 },
      { cost: 5.0 }, // Total = 11.0 > 10.0 limit
    ]);

    await expect(
      service.executeChat('w-1', 'u-1', 'c-1', 'hello'),
    ).rejects.toThrow(ForbiddenException);
  });

  it('should execute chat successfully and calculate correct log cost metrics', async () => {
    mockPrisma.aIBudget.findUnique.mockResolvedValue(null);
    mockPrisma.aIAgent.findFirst.mockResolvedValue({
      id: 'agent-1',
      name: 'Technical Writer',
      systemPrompt: 'Write clear technical documents.',
    });
    mockPrisma.aIWorkspaceMemory.findUnique.mockResolvedValue({
      summary: 'Memory text',
    });
    mockPrisma.aIModelPolicy.findFirst.mockResolvedValue({
      provider: 'OPENAI',
      model: 'gpt-4o',
    });
    mockMCPService.retrieveContext.mockResolvedValue({
      contextText: 'Context details',
      citations: [{ type: 'DOCUMENT', id: 'd-1', title: 'Deployment Specs' }],
    });

    mockPrisma.aIMessage.create.mockImplementation((args) => {
      return { id: 'm-' + Date.now(), ...args.data };
    });

    const response = await service.executeChat('w-1', 'u-1', 'c-1', 'Write a runbook');
    expect(response.content).toBeDefined();
    expect(response.citations).toHaveLength(1);
    expect(response.latency).toBeGreaterThanOrEqual(0);
    expect(response.cost).toBeGreaterThan(0);
    expect(mockPrisma.aIUsageLog.create).toHaveBeenCalled();
  });

  it('should execute hybrid search combining OpenSearch lexical and semantic values', async () => {
    mockSearchService.search.mockResolvedValue([
      { id: 'd-1', source: { title: 'Spec doc' } },
    ]);

    mockPrisma.documentEmbedding.findMany.mockResolvedValue([
      { documentId: 'd-2', embeddingVectorFallback: [0.1, 0.2], document: { title: 'Deployment' } },
    ]);

    const results = await service.hybridSearch('w-1', 'deployment');
    expect(results).toHaveLength(2);
    expect(results[0].id).toBe('d-2'); // Semantic hits prioritised first
    expect(results[1].id).toBe('d-1'); // OpenSearch hit
  });

  it('should return calculations from task metrics in the Risk Engine', async () => {
    mockPrisma.task.findMany.mockResolvedValue([
      { status: 'TODO' },
      { status: 'TODO' },
      { status: 'DONE' },
      { status: 'BLOCKED' },
    ]);

    const risk = await service.calculateRiskEngine('w-1');
    expect(risk.totalTasks).toBe(4);
    expect(risk.deliveryRisk).toBeGreaterThan(0);
    expect(risk.burnoutRisk).toBeGreaterThan(0);
  });
});
