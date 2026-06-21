import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class ApprovalService {
  constructor(private prisma: PrismaService) {}

  async createApprovalRequest(data: { workflowId: string; requestedBy: string; approverId: string }) {
    return this.prisma.approvalRequest.create({
      data: {
        workflowId: data.workflowId,
        requestedBy: data.requestedBy,
        approverId: data.approverId,
        status: 'PENDING',
      },
    });
  }

  async getApprovals(approverId?: string) {
    if (approverId) {
      return this.prisma.approvalRequest.findMany({
        where: { approverId },
        orderBy: { createdAt: 'desc' },
      });
    }
    return this.prisma.approvalRequest.findMany({
      orderBy: { createdAt: 'desc' },
    });
  }

  async getApprovalById(id: string) {
    const request = await this.prisma.approvalRequest.findUnique({
      where: { id },
    });
    if (!request) {
      throw new NotFoundException(`Approval Request with ID ${id} not found`);
    }
    return request;
  }

  async approveRequest(id: string, comments?: string) {
    const request = await this.getApprovalById(id);
    const updated = await this.prisma.approvalRequest.update({
      where: { id },
      data: {
        status: 'APPROVED',
        comments: comments || 'Approved by user',
      },
    });

    // Optionally update associated workflow execution nodes if executing
    const execution = await this.prisma.workflowExecution.findUnique({
      where: { id: request.workflowId },
    });

    if (execution) {
      await this.prisma.workflowExecutionLog.create({
        data: {
          executionId: execution.id,
          nodeId: 'APPROVAL_STEP',
          status: 'COMPLETED',
          message: `Approval step approved. Comments: ${comments}`,
        },
      });
    }

    return updated;
  }

  async rejectRequest(id: string, comments?: string) {
    const request = await this.getApprovalById(id);
    const updated = await this.prisma.approvalRequest.update({
      where: { id },
      data: {
        status: 'REJECTED',
        comments: comments || 'Rejected by user',
      },
    });

    const execution = await this.prisma.workflowExecution.findUnique({
      where: { id: request.workflowId },
    });

    if (execution) {
      await this.prisma.workflowExecutionLog.create({
        data: {
          executionId: execution.id,
          nodeId: 'APPROVAL_STEP',
          status: 'FAILED',
          message: `Approval step rejected. Comments: ${comments}`,
        },
      });

      // Update execution status to failed
      await this.prisma.workflowExecution.update({
        where: { id: execution.id },
        data: {
          status: 'FAILED',
          completedAt: new Date(),
          outputData: { outcome: 'REJECTED', comments },
        },
      });
    }

    return updated;
  }
}
