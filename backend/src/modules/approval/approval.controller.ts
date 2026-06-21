import { Controller, Post, Get, Body, Param, Headers, Query } from '@nestjs/common';
import { ApprovalService } from './approval.service';

@Controller('approvals')
export class ApprovalController {
  constructor(private readonly approvalService: ApprovalService) {}

  @Get()
  async getApprovals(
    @Headers('x-user-id') userId: string,
    @Query('approverId') queryApproverId?: string,
  ) {
    const approver = queryApproverId || userId;
    return this.approvalService.getApprovals(approver);
  }

  @Get(':id')
  async getApprovalById(@Param('id') id: string) {
    return this.approvalService.getApprovalById(id);
  }

  @Post(':id/approve')
  async approveRequest(
    @Param('id') id: string,
    @Body() body?: { comments?: string },
  ) {
    return this.approvalService.approveRequest(id, body?.comments);
  }

  @Post(':id/reject')
  async rejectRequest(
    @Param('id') id: string,
    @Body() body?: { comments?: string },
  ) {
    return this.approvalService.rejectRequest(id, body?.comments);
  }
}
