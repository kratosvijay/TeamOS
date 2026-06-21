import { Test, TestingModule } from '@nestjs/testing';
import { FinanceService } from '../finance.service';
import { PrismaService } from '../../prisma/prisma.service';
import { AIService } from '../../ai/ai.service';
import { BadRequestException } from '@nestjs/common';

describe('FinanceService', () => {
  let service: FinanceService;
  let prisma: PrismaService;
  let ai: AIService;

  const mockPrismaService = {
    invoice: {
      create: jest.fn(),
      findMany: jest.fn(),
    },
    expense: {
      create: jest.fn(),
      findMany: jest.fn(),
    },
    budget: {
      create: jest.fn(),
      findMany: jest.fn(),
      findFirst: jest.fn(),
      update: jest.fn(),
    },
  };

  const mockAIService = {
    classifyExpense: jest.fn().mockResolvedValue({ category: 'SOFTWARE' }),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        FinanceService,
        { provide: PrismaService, useValue: mockPrismaService },
        { provide: AIService, useValue: mockAIService },
      ],
    }).compile();

    service = module.get<FinanceService>(FinanceService);
    prisma = module.get<PrismaService>(PrismaService);
    ai = module.get<AIService>(AIService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should create invoice', async () => {
    mockPrismaService.invoice.create.mockResolvedValue({ id: 'inv-1', amount: 3500 });

    const result = await service.createInvoice('ws-1', 3500, 'Acme Corp', new Date('2026-07-31'));
    expect(result.amount).toBe(3500);
  });

  it('should create budget limit', async () => {
    mockPrismaService.budget.create.mockResolvedValue({ id: 'b-1', category: 'SOFTWARE', amount: 50000 });

    const result = await service.createBudget('ws-1', 'SOFTWARE', 50000);
    expect(result.amount).toBe(50000);
  });

  it('should flag expense when amount exceeds policy limit of 5000', async () => {
    mockPrismaService.budget.findFirst.mockResolvedValue(null);
    mockPrismaService.expense.create.mockResolvedValue({ id: 'exp-1', amount: 6500, status: 'FLAGGED' });

    const result = await service.createExpense('ws-1', 6500, 'AWS Cloud Billing', 'emp-1');
    expect(result.status).toBe('FLAGGED');
  });

  it('should create compliant pending expense and update category budget spent', async () => {
    const mockBudget = { id: 'b-1', category: 'SOFTWARE', amount: 50000, spent: 1000 };
    mockPrismaService.budget.findFirst.mockResolvedValue(mockBudget);
    mockPrismaService.expense.create.mockResolvedValue({ id: 'exp-1', amount: 2000, status: 'PENDING' });
    mockPrismaService.budget.update.mockResolvedValue({ ...mockBudget, spent: 3000 });

    const result = await service.createExpense('ws-1', 2000, 'Github SaaS Enterprise', 'emp-1');
    expect(result.status).toBe('PENDING');
    expect(mockPrismaService.budget.update).toHaveBeenCalledWith({
      where: { id: 'b-1' },
      data: { spent: 3000 },
    });
  });
});
