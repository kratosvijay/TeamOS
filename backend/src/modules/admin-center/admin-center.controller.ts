import { Controller, Get, Headers, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { ComplianceService } from '../compliance/compliance.service';
import { SessionService } from '../security/session.service';

@Controller('admin-center')
export class AdminCenterController {
  constructor(
    private prisma: PrismaService,
    private complianceService: ComplianceService,
    private sessionService: SessionService,
  ) {}

  @Get('analytics')
  async getAnalytics(@Headers('x-workspace-id') workspaceId: string) {
    if (!workspaceId) {
      throw new BadRequestException('Workspace ID is required');
    }

    // 1. MFA Adoption
    const totalUsers = await this.prisma.user.count();
    const usersWithMfa = await this.prisma.user.count({
      where: {
        mfaRecoveryCodes: { some: {} },
      },
    });
    const mfaAdoption = totalUsers > 0 ? Math.round((usersWithMfa / totalUsers) * 100) : 0;

    // 2. Active Sessions
    const activeSessions = await this.sessionService.getActiveSessionsCount(workspaceId);

    // 3. Security Incidents & DLP Violations
    const securityIncidents = await this.prisma.securityIncident.count({
      where: { workspaceId },
    });

    const dlpViolations = await this.prisma.securityIncident.count({
      where: {
        workspaceId,
        category: 'DLP Policy Violation',
      },
    });

    // 4. Failed Logins
    const failedLogins = await this.prisma.loginAuditLog.count({
      where: { status: 'FAILED' },
    });

    // 5. Compliance Scores
    const standards: ('SOC2' | 'ISO27001' | 'GDPR' | 'HIPAA')[] = ['SOC2', 'ISO27001', 'GDPR', 'HIPAA'];
    let totalScore = 0;
    for (const std of standards) {
      const res = await this.complianceService.generateComplianceReport(workspaceId, std);
      totalScore += res.score;
    }
    const complianceScore = Math.round(totalScore / standards.length);

    // 6. Audit Export Counts
    const auditExports = await this.prisma.auditExport.count({
      where: { workspaceId },
    });

    // 7. Legal Holds
    const legalHolds = await this.prisma.legalHold.count({
      where: { workspaceId, active: true },
    });

    // 8. Retention Violations / Policies
    const retentionPolicies = await this.prisma.retentionPolicy.count({
      where: { workspaceId },
    });

    return {
      mfaAdoption,
      activeSessions,
      securityIncidents,
      dlpViolations,
      failedLogins,
      complianceScore,
      auditExports,
      legalHolds,
      retentionPolicies,
      timestamp: new Date().toISOString(),
    };
  }
}
