import { Injectable, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class AuditExportService {
  constructor(private prisma: PrismaService) {}

  async triggerAuditExport(workspaceId: string, format: 'CSV' | 'PDF' | 'JSON', sources: string[]) {
    if (!['CSV', 'PDF', 'JSON'].includes(format)) {
      throw new BadRequestException(`Unsupported export format: ${format}`);
    }

    const job = await this.prisma.auditExport.create({
      data: {
        workspaceId,
        format,
        status: 'PENDING',
        createdAt: new Date(),
      },
    });

    // Fetch audits from AuditTrail matching the sources
    const auditLogs = await this.prisma.auditTrail.findMany({
      where: {
        workspaceId,
        action: sources.length > 0 ? { in: sources } : undefined,
      },
      take: 100,
    });

    let exportedData = '';

    if (format === 'JSON') {
      exportedData = JSON.stringify(auditLogs, null, 2);
    } else if (format === 'CSV') {
      const headers = 'ID,Action,EntityType,EntityID,IPAddress,CreatedAt\n';
      const rows = auditLogs
        .map((log) => `${log.id},${log.action},${log.entityType},${log.entityId},${log.ipAddress || ''},${log.createdAt.toISOString()}`)
        .join('\n');
      exportedData = headers + rows;
    } else {
      // Mock PDF buffer description
      exportedData = `%PDF-1.4\n%-- TeamOS Audit Log Export --\nWorkspace: ${workspaceId}\nRecord Count: ${auditLogs.length}\n`;
    }

    // Complete job
    const completedJob = await this.prisma.auditExport.update({
      where: { id: job.id },
      data: { status: 'COMPLETED' },
    });

    return {
      job: completedJob,
      data: exportedData,
    };
  }

  async getExportJobs(workspaceId: string) {
    return this.prisma.auditExport.findMany({
      where: { workspaceId },
      orderBy: { createdAt: 'desc' },
    });
  }
}
