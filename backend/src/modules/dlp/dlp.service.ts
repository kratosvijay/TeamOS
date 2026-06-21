import { Injectable, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { SecurityService } from '../security/security.service';

@Injectable()
export class DLPService {
  constructor(
    private prisma: PrismaService,
    private securityService: SecurityService,
  ) {}

  async createOrUpdatePolicy(workspaceId: string, name: string, pattern: string, action: 'Warn' | 'Block' | 'Quarantine') {
    const existing = await this.prisma.dLPPolicy.findFirst({
      where: { workspaceId, name },
    });

    if (existing) {
      return this.prisma.dLPPolicy.update({
        where: { id: existing.id },
        data: { pattern, action },
      });
    }

    return this.prisma.dLPPolicy.create({
      data: {
        workspaceId,
        name,
        pattern,
        action,
      },
    });
  }

  async getPolicies(workspaceId: string) {
    return this.prisma.dLPPolicy.findMany({
      where: { workspaceId },
    });
  }

  async scanContent(workspaceId: string, text: string): Promise<{ cleanText: string; violated: boolean; action: string; matches: string[] }> {
    const policies = await this.getPolicies(workspaceId);
    let violated = false;
    let finalAction = 'None';
    const matches: string[] = [];
    let cleanText = text;

    // Default system patterns if no specific policies are defined
    const dlpRules = policies.length > 0 ? policies : [
      { name: 'Credit Cards', pattern: '\\b\\d{4}[- ]?\\d{4}[- ]?\\d{4}[- ]?\\d{4}\\b', action: 'Block' },
      { name: 'SSN', pattern: '\\b\\d{3}-\\d{2}-\\d{4}\\b', action: 'Quarantine' },
      { name: 'API Keys', pattern: '(api[-_]?key|secret|token).*[a-zA-Z0-9]{32}', action: 'Warn' },
    ];

    for (const rule of dlpRules) {
      const regex = new RegExp(rule.pattern, 'gi');
      if (regex.test(text)) {
        violated = true;
        finalAction = rule.action;
        matches.push(rule.name);

        // Log security incident automatically
        await this.securityService.logSecurityIncident(
          workspaceId,
          rule.action === 'Block' ? 'CRITICAL' : 'HIGH',
          'DLP Policy Violation',
          `DLP policy "${rule.name}" triggered on content. Action taken: ${rule.action}`,
        );

        if (rule.action === 'Block') {
          throw new BadRequestException(`DLP Policy Violation: Content blocked due to sensitive data leak (${rule.name})`);
        } else if (rule.action === 'Quarantine') {
          cleanText = cleanText.replace(regex, '[QUARANTINED]');
        }
      }
    }

    return {
      cleanText,
      violated,
      action: finalAction,
      matches,
    };
  }
}
