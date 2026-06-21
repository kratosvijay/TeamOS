import { Test, TestingModule } from '@nestjs/testing';
import { InventoryService } from '../inventory.service';
import { PrismaService } from '../../prisma/prisma.service';
import { BadRequestException } from '@nestjs/common';

describe('InventoryService', () => {
  let service: InventoryService;
  let prisma: PrismaService;

  const mockPrismaService = {
    warehouse: {
      create: jest.fn(),
      findMany: jest.fn(),
      findUnique: jest.fn(),
    },
    inventoryItem: {
      create: jest.fn(),
      findMany: jest.fn(),
      findUnique: jest.fn(),
      findFirst: jest.fn(),
      update: jest.fn(),
    },
    stockTransfer: {
      create: jest.fn(),
    },
    inventoryAdjustment: {
      create: jest.fn(),
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        InventoryService,
        { provide: PrismaService, useValue: mockPrismaService },
      ],
    }).compile();

    service = module.get<InventoryService>(InventoryService);
    prisma = module.get<PrismaService>(PrismaService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should create warehouse', async () => {
    mockPrismaService.warehouse.create.mockResolvedValue({ id: 'w-1', name: 'Main WH' });

    const result = await service.createWarehouse('ws-1', 'Main WH', 'New York');
    expect(result.name).toBe('Main WH');
  });

  it('should prevent creating item with negative quantity', async () => {
    await expect(service.createItem('ws-1', 'Laptop', 'SKU-LAP', -5, 'w-1')).rejects.toThrow(BadRequestException);
  });

  it('should transfer stock safely and update warehouse locations', async () => {
    // Mock item exists in source warehouse with 10 units
    mockPrismaService.inventoryItem.findUnique.mockResolvedValue({ id: 'item-1', name: 'Laptop', sku: 'SKU-LAP', quantity: 10, warehouseId: 'w-1' });
    mockPrismaService.inventoryItem.findFirst.mockResolvedValue({ id: 'item-2', name: 'Laptop', sku: 'SKU-LAP', quantity: 2, warehouseId: 'w-2' });

    mockPrismaService.inventoryItem.update.mockResolvedValue({ id: 'item-1', quantity: 5 });
    mockPrismaService.stockTransfer.create.mockResolvedValue({ id: 'tr-1', status: 'COMPLETED' });

    const result = await service.transferStock('ws-1', 'item-1', 'w-1', 'w-2', 5);
    expect(result.status).toBe('COMPLETED');
    expect(mockPrismaService.inventoryItem.update).toHaveBeenCalled();
  });

  it('should reject transfer when stock level is insufficient', async () => {
    mockPrismaService.inventoryItem.findUnique.mockResolvedValue({ id: 'item-1', name: 'Laptop', sku: 'SKU-LAP', quantity: 3, warehouseId: 'w-1' });

    await expect(service.transferStock('ws-1', 'item-1', 'w-1', 'w-2', 5)).rejects.toThrow(BadRequestException);
  });
});
