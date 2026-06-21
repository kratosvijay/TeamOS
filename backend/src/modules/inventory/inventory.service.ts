import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class InventoryService {
  constructor(private prisma: PrismaService) {}

  async createItem(workspaceId: string, name: string, sku: string, quantity: number, warehouseId: string) {
    if (quantity < 0) {
      throw new BadRequestException('Quantity cannot be negative');
    }

    const warehouse = await this.prisma.warehouse.findUnique({
      where: { id: warehouseId },
    });
    if (!warehouse) {
      throw new NotFoundException(`Warehouse with ID ${warehouseId} not found`);
    }

    return this.prisma.inventoryItem.create({
      data: {
        workspaceId,
        name,
        sku,
        quantity,
        warehouseId,
      },
    });
  }

  async getItems(workspaceId: string) {
    return this.prisma.inventoryItem.findMany({
      where: { workspaceId },
      orderBy: { name: 'asc' },
    });
  }

  async createWarehouse(workspaceId: string, name: string, location: string) {
    return this.prisma.warehouse.create({
      data: {
        workspaceId,
        name,
        location,
      },
    });
  }

  async getWarehouses(workspaceId: string) {
    return this.prisma.warehouse.findMany({
      where: { workspaceId },
      orderBy: { name: 'asc' },
    });
  }

  async transferStock(
    workspaceId: string,
    itemId: string,
    fromWarehouseId: string,
    toWarehouseId: string,
    quantity: number,
  ) {
    if (quantity <= 0) {
      throw new BadRequestException('Transfer quantity must be greater than zero');
    }

    const item = await this.prisma.inventoryItem.findUnique({
      where: { id: itemId },
    });
    if (!item) {
      throw new NotFoundException(`Item with ID ${itemId} not found`);
    }

    // Safety: Verify quantity in the source warehouse
    if (item.warehouseId !== fromWarehouseId || item.quantity < quantity) {
      throw new BadRequestException('Insufficient stock in source warehouse');
    }

    // Deduct from source item
    await this.prisma.inventoryItem.update({
      where: { id: itemId },
      data: { quantity: item.quantity - quantity },
    });

    // Add to target item or create new target item entry
    const targetItem = await this.prisma.inventoryItem.findFirst({
      where: { sku: item.sku, warehouseId: toWarehouseId },
    });

    if (targetItem) {
      await this.prisma.inventoryItem.update({
        where: { id: targetItem.id },
        data: { quantity: targetItem.quantity + quantity },
      });
    } else {
      await this.prisma.inventoryItem.create({
        data: {
          workspaceId,
          name: item.name,
          sku: item.sku,
          quantity,
          warehouseId: toWarehouseId,
        },
      });
    }

    return this.prisma.stockTransfer.create({
      data: {
        workspaceId,
        itemId,
        fromWarehouseId,
        toWarehouseId,
        quantity,
        status: 'COMPLETED',
      },
    });
  }

  async adjustStock(workspaceId: string, itemId: string, warehouseId: string, qtyChange: number, reason: string) {
    const item = await this.prisma.inventoryItem.findUnique({
      where: { id: itemId },
    });
    if (!item) {
      throw new NotFoundException(`Item with ID ${itemId} not found`);
    }

    const newQty = item.quantity + qtyChange;
    if (newQty < 0) {
      throw new BadRequestException('Adjustment would result in negative stock level');
    }

    await this.prisma.inventoryItem.update({
      where: { id: itemId },
      data: { quantity: newQty },
    });

    return this.prisma.inventoryAdjustment.create({
      data: {
        workspaceId,
        itemId,
        warehouseId,
        qtyChange,
        reason,
      },
    });
  }
}
