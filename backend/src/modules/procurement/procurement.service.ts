import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { AIService } from '../ai/ai.service';

@Injectable()
export class ProcurementService {
  constructor(
    private prisma: PrismaService,
    private aiService: AIService,
  ) {}

  async createVendor(workspaceId: string, name: string, email: string, phone?: string) {
    const aiResult = await this.aiService.analyzeVendorRisk({ name, email });
    return this.prisma.eRPVendor.create({
      data: {
        workspaceId,
        name,
        email,
        phone: phone || null,
        riskRating: aiResult.riskRating,
        status: 'ACTIVE',
      },
    });
  }

  async getVendors(workspaceId: string) {
    return this.prisma.eRPVendor.findMany({
      where: { workspaceId },
      orderBy: { name: 'asc' },
    });
  }

  async createPurchaseRequest(
    workspaceId: string,
    item: string,
    quantity: number,
    estimatedCost: number,
    requestedBy: string,
  ) {
    return this.prisma.purchaseRequest.create({
      data: {
        workspaceId,
        item,
        quantity,
        estimatedCost,
        requestedBy,
        status: 'PENDING',
      },
    });
  }

  async getPurchaseRequests(workspaceId: string) {
    return this.prisma.purchaseRequest.findMany({
      where: { workspaceId },
      orderBy: { createdAt: 'desc' },
    });
  }

  async createPurchaseOrder(workspaceId: string, requestId: string | null, vendorId: string, totalAmount: number) {
    const vendor = await this.prisma.eRPVendor.findUnique({
      where: { id: vendorId },
    });
    if (!vendor) {
      throw new NotFoundException(`Vendor with ID ${vendorId} not found`);
    }

    return this.prisma.purchaseOrder.create({
      data: {
        workspaceId,
        requestId,
        vendorId,
        totalAmount,
        status: 'DRAFT',
      },
    });
  }

  async getPurchaseOrders(workspaceId: string) {
    return this.prisma.purchaseOrder.findMany({
      where: { workspaceId },
      orderBy: { createdAt: 'desc' },
    });
  }

  async createRFQ(workspaceId: string, title: string, description: string, dueDate: Date) {
    return this.prisma.rFQ.create({
      data: {
        workspaceId,
        title,
        description,
        dueDate,
        status: 'OPEN',
      },
    });
  }

  async getRFQs(workspaceId: string) {
    return this.prisma.rFQ.findMany({
      where: { workspaceId },
      orderBy: { createdAt: 'desc' },
    });
  }
}
