import { Controller, Get, Post, Body, Headers, BadRequestException } from '@nestjs/common';
import { InventoryService } from './inventory.service';

@Controller('inventory')
export class InventoryController {
  constructor(private inventoryService: InventoryService) {}

  @Get('items')
  async getItems(@Headers('x-workspace-id') workspaceId: string) {
    if (!workspaceId) {
      throw new BadRequestException('Workspace ID is required');
    }
    return this.inventoryService.getItems(workspaceId);
  }

  @Post('items')
  async createItem(
    @Headers('x-workspace-id') workspaceId: string,
    @Body() body: { name: string; sku: string; quantity: number; warehouseId: string },
  ) {
    if (!workspaceId) {
      throw new BadRequestException('Workspace ID is required');
    }
    if (!body.name || !body.sku || body.quantity === undefined || !body.warehouseId) {
      throw new BadRequestException('name, sku, quantity, and warehouseId are required');
    }
    return this.inventoryService.createItem(workspaceId, body.name, body.sku, body.quantity, body.warehouseId);
  }

  @Get('warehouses')
  async getWarehouses(@Headers('x-workspace-id') workspaceId: string) {
    if (!workspaceId) {
      throw new BadRequestException('Workspace ID is required');
    }
    return this.inventoryService.getWarehouses(workspaceId);
  }

  @Post('warehouses')
  async createWarehouse(
    @Headers('x-workspace-id') workspaceId: string,
    @Body() body: { name: string; location: string },
  ) {
    if (!workspaceId) {
      throw new BadRequestException('Workspace ID is required');
    }
    if (!body.name || !body.location) {
      throw new BadRequestException('name and location are required');
    }
    return this.inventoryService.createWarehouse(workspaceId, body.name, body.location);
  }

  @Post('transfers')
  async transferStock(
    @Headers('x-workspace-id') workspaceId: string,
    @Body() body: { itemId: string; fromWarehouseId: string; toWarehouseId: string; quantity: number },
  ) {
    if (!workspaceId) {
      throw new BadRequestException('Workspace ID is required');
    }
    if (!body.itemId || !body.fromWarehouseId || !body.toWarehouseId || body.quantity === undefined) {
      throw new BadRequestException('itemId, fromWarehouseId, toWarehouseId, and quantity are required');
    }
    return this.inventoryService.transferStock(
      workspaceId,
      body.itemId,
      body.fromWarehouseId,
      body.toWarehouseId,
      body.quantity,
    );
  }

  @Post('adjustments')
  async adjustStock(
    @Headers('x-workspace-id') workspaceId: string,
    @Body() body: { itemId: string; warehouseId: string; qtyChange: number; reason: string },
  ) {
    if (!workspaceId) {
      throw new BadRequestException('Workspace ID is required');
    }
    if (!body.itemId || !body.warehouseId || body.qtyChange === undefined || !body.reason) {
      throw new BadRequestException('itemId, warehouseId, qtyChange, and reason are required');
    }
    return this.inventoryService.adjustStock(
      workspaceId,
      body.itemId,
      body.warehouseId,
      body.qtyChange,
      body.reason,
    );
  }
}
