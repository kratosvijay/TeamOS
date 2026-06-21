import { Test, TestingModule } from '@nestjs/testing';
import { CRMService } from '../crm.service';
import { PrismaService } from '../../prisma/prisma.service';
import { AIService } from '../../ai/ai.service';

describe('CRMService', () => {
  let service: CRMService;
  let prisma: PrismaService;
  let ai: AIService;

  const mockPrismaService = {
    cRMLead: {
      create: jest.fn(),
      findMany: jest.fn(),
      findUnique: jest.fn(),
      update: jest.fn(),
    },
    cRMOpportunity: {
      create: jest.fn(),
      findMany: jest.fn(),
      findUnique: jest.fn(),
      update: jest.fn(),
    },
    cRMAccount: {
      create: jest.fn(),
      findMany: jest.fn(),
    },
    cRMContact: {
      create: jest.fn(),
      findMany: jest.fn(),
    },
  };

  const mockAIService = {
    scoreLead: jest.fn().mockResolvedValue({ score: 90, classification: 'HOT' }),
    forecastOpportunity: jest.fn().mockResolvedValue({ winProbability: 0.85 }),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        CRMService,
        { provide: PrismaService, useValue: mockPrismaService },
        { provide: AIService, useValue: mockAIService },
      ],
    }).compile();

    service = module.get<CRMService>(CRMService);
    prisma = module.get<PrismaService>(PrismaService);
    ai = module.get<AIService>(AIService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should create lead', async () => {
    mockPrismaService.cRMLead.create.mockResolvedValue({ id: 'l-1', name: 'Lead 1', company: 'Corp' });

    const result = await service.createLead('ws-1', 'Lead 1', 'Corp', 'lead1@teamos.com', 10000);
    expect(result.name).toBe('Lead 1');
  });

  it('should create opportunity', async () => {
    mockPrismaService.cRMOpportunity.create.mockResolvedValue({ id: 'opp-1', name: 'Opp 1' });

    const result = await service.createOpportunity('ws-1', 'l-1', 'Opp 1', 'PROSPECTING', 25000, 20);
    expect(result.name).toBe('Opp 1');
  });

  it('should score lead via AI service and update database', async () => {
    mockPrismaService.cRMLead.findUnique.mockResolvedValue({ id: 'l-1', email: 'lead1@teamos.com', company: 'Corp', value: 10000, status: 'NEW' });
    mockPrismaService.cRMLead.update.mockResolvedValue({ id: 'l-1', aiScore: 90, status: 'QUALIFIED' });

    const result = await service.scoreCRMLead('l-1');
    expect(result.aiScore).toBe(90);
    expect(result.status).toBe('QUALIFIED');
  });

  it('should forecast opportunity win probability via AI', async () => {
    mockPrismaService.cRMOpportunity.findUnique.mockResolvedValue({ id: 'opp-1', stage: 'DEMO', value: 25000 });
    mockPrismaService.cRMOpportunity.update.mockResolvedValue({ id: 'opp-1', probability: 85 });

    const result = await service.forecastCRMOpportunity('opp-1');
    expect(result.probability).toBe(85);
  });
});
