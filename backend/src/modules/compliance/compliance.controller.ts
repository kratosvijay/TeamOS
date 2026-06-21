import { Controller, Get, Post, Body, Query, Headers, BadRequestException } from '@nestjs/common';
import { ComplianceService } from './compliance.service';
import { AuditExportService } from './audit-export.service';

@Controller('compliance')
export class ComplianceController {
  constructor(
    private complianceService: ComplianceService,
    private auditExportService: AuditExportService,
  ) {}

  @Get('report')
  async getReport(
    @Headers('x-workspace-id') workspaceIdHeader: string,
    @Query('standard') standard: 'SOC2' | 'ISO27001' | 'GDPR' | 'HIPAA',
    @Query('workspaceId') workspaceIdQuery?: string,
  ) {
    const workspaceId = workspaceIdQuery || workspaceIdHeader;
    if (!workspaceId) {
      throw new BadRequestException('Workspace ID is required');
    }
    if (!standard) {
      throw new BadRequestException('Standard standard query param is required');
    }
    return this.complianceService.generateComplianceReport(workspaceId, standard);
  }

  @Post('exports')
  async triggerExport(
    @Headers('x-workspace-id') workspaceIdHeader: string,
    @Body() body: { workspaceId?: string; format: 'CSV' | 'PDF' | 'JSON'; sources?: string[] },
  ) {
    const workspaceId = body.workspaceId || workspaceIdHeader;
    if (!workspaceId) {
      throw new BadRequestException('Workspace ID is required');
    }
    if (!body.format) {
      throw new BadRequestException('Export format is required');
    }
    return this.auditExportService.triggerAuditExport(workspaceId, body.format, body.sources || []);
  }

  @Get('exports')
  async getExportJobs(
    @Headers('x-workspace-id') workspaceIdHeader: string,
    @Query('workspaceId') workspaceIdQuery?: string,
  ) {
    const workspaceId = workspaceIdQuery || workspaceIdHeader;
    if (!workspaceId) {
      throw new BadRequestException('Workspace ID is required');
    }
    return this.auditExportService.getExportJobs(workspaceId);
  }
}
