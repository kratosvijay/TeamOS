import { Controller, Get, Query, UseGuards, Headers } from '@nestjs/common';
import { AuditService } from './audit.service';
import { WorkspaceAuthGuard } from '../../common/guards/workspace-auth.guard';

@Controller('audit-logs')
@UseGuards(WorkspaceAuthGuard)
export class AuditController {
  constructor(private auditService: AuditService) {}

  @Get()
  async getAuditLogs(
    @Headers('x-workspace-id') workspaceId: string,
    @Query('limit') limit?: string,
    @Query('offset') offset?: string,
  ) {
    const parsedLimit = limit ? parseInt(limit, 10) : 100;
    const parsedOffset = offset ? parseInt(offset, 10) : 0;
    return this.auditService.getAuditLogs(workspaceId, parsedLimit, parsedOffset);
  }
}
