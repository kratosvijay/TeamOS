import { Test, TestingModule } from '@nestjs/testing';
import { ProcurementService } from '../procurement.service';
import { PrismaService } from '../../prisma/prisma.service';
import { AIService } from '../../ai/ai.service';

describe('ProcurementService', () => {
  let service: ProcurementService;
  let prisma: PrismaService;
  let ai: AIService;

  const mockPrismaService = {
    eRPVendor: {
      create: jest.fn(),
      findMany: jest.fn(),
      findUnique: jest.fn(),
    },
    purchaseRequest: {
      create: jest.fn(),
      findMany: jest.fn(),
    },
    purchaseOrder: {
      create: jest.fn(),
      findMany: jest.fn(),
    },
    rFQ: {
      create: jest.fn(),
      findMany: jest.fn(),
    },
  };

  const mockAIService = {
    analyzeVendorRisk: jest.fn().mockResolvedValue({ riskRating: 'LOW' }),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ProcurementService,
        { provide: PrismaService, useValue: mockPrismaService },
        { provide: AIService, useValue: mockAIService },
      ],
    }).compile();

    service = module.get<ProcurementService>(ProcurementService);
    prisma = module.get<PrismaService>(PrismaService);
    ai = module.get<AIService>(AIService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should create vendor with AI risk assessment', async () => {
    mockPrismaService.eRPVendor.create.mockResolvedValue({ id: 'v-1', name: 'Vendor 1', riskRating: 'LOW' });

    const result = await service.createVendor('ws-1', 'Vendor 1', 'v1@corp.com');
    expect(result.riskRating).toBe('LOW');
    expect(mockAIService.analyzeVendorRisk).toHaveBeenCalled();
  });

  it('should create purchase request', async () => {
    mockPrismaService.purchaseRequest.create.mockResolvedValue({ id: 'pr-1', item: 'Laptops', quantity: 5, status: 'PENDING' });

    const result = await service.createPurchaseRequest('ws-1', 'Laptops', 5, 4500, 'user-1');
    expect(result.status).toBe('PENDING');
  });

  it('should create purchase order', async () => {
    mockPrismaService.eRPVendor.findUnique.mockResolvedValue({ id: 'v-1' });
    mockPrismaService.purchaseOrder.create.mockResolvedValue({ id: 'po-1', totalAmount: 5000, status: 'DRAFT' });

    const result = await service.createPurchaseOrder('ws-1', 'pr-1', 'v-1', 5000);
    expect(result.status).toBe('DRAFT');
  });
});
