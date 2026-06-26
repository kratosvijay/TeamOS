import { Injectable } from '@nestjs/common';
import * as crypto from 'crypto';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class DataPrivacyService {
  constructor(private readonly prisma: PrismaService) {}

  async createMaskingRule(workspaceId: string, columnPath: string, maskType: string) {
    return this.prisma.maskingRule.create({
      data: {
        workspaceId,
        columnPath,
        maskType,
        isActive: true,
      },
    });
  }

  async createTokenizationRule(workspaceId: string, columnPath: string, vaultToken: string) {
    return this.prisma.tokenizationRule.create({
      data: {
        workspaceId,
        columnPath,
        vaultToken,
        isActive: true,
      },
    });
  }

  async applyPrivacyRules(workspaceId: string, columnPath: string, value: string): Promise<string> {
    const maskRule = await this.prisma.maskingRule.findFirst({
      where: { workspaceId, columnPath, isActive: true },
    });
    if (maskRule) {
      if (maskRule.maskType === 'REDACT') return '[REDACTED]';
      if (maskRule.maskType === 'HASH') return crypto.createHash('sha256').update(value).digest('hex');
      if (maskRule.maskType === 'PARTIAL') return value.substring(0, 3) + '****';
    }

    const tokenRule = await this.prisma.tokenizationRule.findFirst({
      where: { workspaceId, columnPath, isActive: true },
    });
    if (tokenRule) {
      // Return vault token as pointer
      return `vault-token:${tokenRule.vaultToken}:${value.substring(0, 2)}`;
    }

    return value;
  }
}
