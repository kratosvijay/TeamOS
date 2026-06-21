import { Module } from '@nestjs/common';
import { ComplianceService } from './compliance.service';
import { AuditExportService } from './audit-export.service';
import { ComplianceController } from './compliance.controller';
import { PrismaModule } from '../prisma/prisma.module';

@Module({
  imports: [PrismaModule],
  providers: [ComplianceService, AuditExportService],
  controllers: [ComplianceController],
  exports: [ComplianceService, AuditExportService],
})
export class ComplianceModule {}
