import { Test, TestingModule } from '@nestjs/testing';
import { RulesEngineService } from '../rules-engine.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('RulesEngineService', () => {
  let service: RulesEngineService;

  const mockPrismaService = {
    businessRule: {
      create: jest.fn(),
      findMany: jest.fn(),
      findUnique: jest.fn(),
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        RulesEngineService,
        { provide: PrismaService, useValue: mockPrismaService },
      ],
    }).compile();

    service = module.get<RulesEngineService>(RulesEngineService);
  });

  it('should parse and evaluate comparisons (> operator)', () => {
    const condition = { field: 'budget', operator: '>', value: '100000' };
    const factsTrue = { budget: 150000 };
    const factsFalse = { budget: 90000 };

    expect(service.evaluateRule(condition, factsTrue)).toBe(true);
    expect(service.evaluateRule(condition, factsFalse)).toBe(false);
  });

  it('should parse and evaluate leave days condition (<= operator)', () => {
    const condition = { field: 'days', operator: '<=', value: '3' };
    const factsTrue = { days: 2 };
    const factsFalse = { days: 5 };

    expect(service.evaluateRule(condition, factsTrue)).toBe(true);
    expect(service.evaluateRule(condition, factsFalse)).toBe(false);
  });

  it('should parse string containment (contains operator)', () => {
    const condition = { field: 'description', operator: 'contains', value: 'Overdue' };
    const factsTrue = { description: 'This invoice is Overdue by 10 days' };
    const factsFalse = { description: 'This invoice is paid' };

    expect(service.evaluateRule(condition, factsTrue)).toBe(true);
    expect(service.evaluateRule(condition, factsFalse)).toBe(false);
  });

  it('should evaluate equality operator (==)', () => {
    const condition = { field: 'department', operator: '==', value: 'Engineering' };
    const factsTrue = { department: 'Engineering' };
    const factsFalse = { department: 'HR' };

    expect(service.evaluateRule(condition, factsTrue)).toBe(true);
    expect(service.evaluateRule(condition, factsFalse)).toBe(false);
  });
});
