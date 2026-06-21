import { Controller, Get, Post, Body, Headers, BadRequestException } from '@nestjs/common';
import { ProcurementService } from './procurement.service';

@Controller('procurement')
export class ProcurementController {
  constructor(private procurementService: ProcurementService) {}

  @Get('vendors')
  async getVendors(@Headers('x-workspace-id') workspaceId: string) {
    if (!workspaceId) {
      throw new BadRequestException('Workspace ID is required');
    }
    return this.procurementService.getVendors(workspaceId);
  }

  @Post('vendors')
  async createVendor(
    @Headers('x-workspace-id') workspaceId: string,
    @Body() body: { name: string; email: string; phone?: string },
  ) {
    if (!workspaceId) {
      throw new BadRequestException('Workspace ID is required');
    }
    if (!body.name || !body.email) {
      throw new BadRequestException('name and email are required');
    }
    return this.procurementService.createVendor(workspaceId, body.name, body.email, body.phone);
  }

  @Post('requests')
  async createRequest(
    @Headers('x-workspace-id') workspaceId: string,
    @Body() body: { item: string; quantity: number; estimatedCost: number; requestedBy: string },
  ) {
    if (!workspaceId) {
      throw new BadRequestException('Workspace ID is required');
    }
    if (!body.item || body.quantity === undefined || body.estimatedCost === undefined || !body.requestedBy) {
      throw new BadRequestException('item, quantity, estimatedCost, and requestedBy are required');
    }
    return this.procurementService.createPurchaseRequest(
      workspaceId,
      body.item,
      body.quantity,
      body.estimatedCost,
      body.requestedBy,
    );
  }

  @Get('requests')
  async getRequests(@Headers('x-workspace-id') workspaceId: string) {
    if (!workspaceId) {
      throw new BadRequestException('Workspace ID is required');
    }
    return this.procurementService.getPurchaseRequests(workspaceId);
  }

  @Post('orders')
  async createOrder(
    @Headers('x-workspace-id') workspaceId: string,
    @Body() body: { requestId?: string; vendorId: string; totalAmount: number },
  ) {
    if (!workspaceId) {
      throw new BadRequestException('Workspace ID is required');
    }
    if (!body.vendorId || body.totalAmount === undefined) {
      throw new BadRequestException('vendorId and totalAmount are required');
    }
    return this.procurementService.createPurchaseOrder(
      workspaceId,
      body.requestId || null,
      body.vendorId,
      body.totalAmount,
    );
  }

  @Get('orders')
  async getOrders(@Headers('x-workspace-id') workspaceId: string) {
    if (!workspaceId) {
      throw new BadRequestException('Workspace ID is required');
    }
    return this.procurementService.getPurchaseOrders(workspaceId);
  }

  @Post('rfq')
  async createRFQ(
    @Headers('x-workspace-id') workspaceId: string,
    @Body() body: { title: string; description: string; dueDate: string },
  ) {
    if (!workspaceId) {
      throw new BadRequestException('Workspace ID is required');
    }
    if (!body.title || !body.dueDate) {
      throw new BadRequestException('title and dueDate are required');
    }
    return this.procurementService.createRFQ(workspaceId, body.title, body.description, new Date(body.dueDate));
  }

  @Get('rfq')
  async getRFQs(@Headers('x-workspace-id') workspaceId: string) {
    if (!workspaceId) {
      throw new BadRequestException('Workspace ID is required');
    }
    return this.procurementService.getRFQs(workspaceId);
  }
}
