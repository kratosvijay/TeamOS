import { Controller, Get, Param, Res, UseGuards } from '@nestjs/common';
import { Response } from 'express';
import { ReportingService } from './reporting.service';
import { WorkspaceAuthGuard } from '../../common/guards/workspace-auth.guard';

@Controller('reporting')
@UseGuards(WorkspaceAuthGuard)
export class ReportingController {
  constructor(private reportingService: ReportingService) {}

  @Get('sprint/:sprintId')
  async getSprintReport(@Param('sprintId') sprintId: string) {
    return this.reportingService.getSprintReport(sprintId);
  }

  @Get('sprint/:sprintId/csv')
  async getSprintCsv(@Param('sprintId') sprintId: string, @Res() res: Response) {
    const csv = await this.reportingService.exportSprintCsv(sprintId);
    res.setHeader('Content-Type', 'text/csv');
    res.setHeader('Content-Disposition', `attachment; filename="sprint-report-${sprintId}.csv"`);
    return res.send(csv);
  }

  @Get('sprint/:sprintId/pdf')
  async getSprintPdf(@Param('sprintId') sprintId: string, @Res() res: Response) {
    const pdfBuffer = await this.reportingService.exportSprintPdf(sprintId);
    res.setHeader('Content-Type', 'application/pdf');
    res.setHeader('Content-Disposition', `attachment; filename="sprint-report-${sprintId}.pdf"`);
    return res.send(pdfBuffer);
  }
}
