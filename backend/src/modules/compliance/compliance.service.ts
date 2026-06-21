import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class ComplianceService {
  constructor(private prisma: PrismaService) {}

  async generateComplianceReport(workspaceId: string, standard: 'SOC2' | 'ISO27001' | 'GDPR' | 'HIPAA') {
    // Collect settings and status to calculate compliance checklist and score
    const securityPolicy = await this.prisma.securityPolicy.findUnique({
      where: { workspaceId },
    });

    const dlpPoliciesCount = await this.prisma.dLPPolicy.count({
      where: { workspaceId },
    });

    const retentionPoliciesCount = await this.prisma.retentionPolicy.count({
      where: { workspaceId },
    });

    const mfaRequired = securityPolicy?.requireMFA || false;
    const ipRestricted = securityPolicy ? securityPolicy.ipAllowlist !== null : false;

    let score = 50;
    const checks = [
      { id: 'mfa', name: 'MFA Enforcement', passed: mfaRequired, scoreValue: 15 },
      { id: 'ip_allowlist', name: 'IP Access Restrictions', passed: ipRestricted, scoreValue: 15 },
      { id: 'dlp_active', name: 'Data Loss Prevention Rules', passed: dlpPoliciesCount > 0, scoreValue: 10 },
      { id: 'retention_policy', name: 'Data Retention Configuration', passed: retentionPoliciesCount > 0, scoreValue: 10 },
    ];

    checks.forEach((chk) => {
      if (chk.passed) {
        score += chk.scoreValue;
      }
    });

    return {
      workspaceId,
      standard,
      score: Math.min(score, 100),
      generatedAt: new Date(),
      checks,
      recommendations: this.getRecommendations(standard, mfaRequired, ipRestricted, dlpPoliciesCount, retentionPoliciesCount),
    };
  }

  private getRecommendations(
    standard: string,
    mfa: boolean,
    ip: boolean,
    dlpCount: number,
    retentionCount: number,
  ): string[] {
    const recs: string[] = [];
    if (!mfa) recs.push('Enforce Multi-Factor Authentication (MFA) globally.');
    if (!ip) recs.push('Configure IP Access Allowlist to restrict admin portal access.');
    if (dlpCount === 0) recs.push('Create DLP rules to automatically quarantine API keys and SSN data.');
    if (retentionCount === 0) recs.push('Define data retention schedules for messages and documents.');
    return recs;
  }
}
