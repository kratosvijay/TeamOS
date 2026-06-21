import { Injectable, NotFoundException, ForbiddenException, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import * as crypto from 'crypto';

@Injectable()
export class SecurityService {
  constructor(private prisma: PrismaService) {}

  async createOrUpdatePolicy(
    workspaceId: string,
    requireMFA: boolean,
    sessionTimeout: number,
    allowPasswordLogin: boolean,
    ipAllowlist: string[],
  ) {
    return this.prisma.securityPolicy.upsert({
      where: { workspaceId },
      update: {
        requireMFA,
        sessionTimeout,
        allowPasswordLogin,
        ipAllowlist: JSON.parse(JSON.stringify(ipAllowlist)),
      },
      create: {
        workspaceId,
        requireMFA,
        sessionTimeout,
        allowPasswordLogin,
        ipAllowlist: JSON.parse(JSON.stringify(ipAllowlist)),
      },
    });
  }

  async getPolicy(workspaceId: string) {
    const policy = await this.prisma.securityPolicy.findUnique({
      where: { workspaceId },
    });
    if (!policy) {
      // Return a default policy
      return {
        requireMFA: false,
        sessionTimeout: 3600,
        allowPasswordLogin: true,
        ipAllowlist: null,
      };
    }
    return policy;
  }

  async validateIP(workspaceId: string, ipAddress: string): Promise<boolean> {
    const policy = await this.prisma.securityPolicy.findUnique({
      where: { workspaceId },
    });

    if (!policy || !policy.ipAllowlist) {
      return true; // No policy or allowlist configured
    }

    const allowlist = policy.ipAllowlist as string[];
    if (allowlist.length === 0) {
      return true;
    }

    const isAllowed = allowlist.includes(ipAddress);
    if (!isAllowed) {
      // Log an unauthorized IP access security incident
      await this.logSecurityIncident(
        workspaceId,
        'HIGH',
        'Unauthorized IP Access',
        `Access attempted from unauthorized IP address: ${ipAddress}`,
      );
    }

    return isAllowed;
  }

  async logSecurityIncident(
    workspaceId: string,
    severity: 'LOW' | 'MEDIUM' | 'HIGH' | 'CRITICAL',
    category: string,
    description: string,
  ) {
    return this.prisma.securityIncident.create({
      data: {
        workspaceId,
        severity,
        category,
        description,
      },
    });
  }

  async getSecurityIncidents(workspaceId: string) {
    return this.prisma.securityIncident.findMany({
      where: { workspaceId },
      orderBy: { createdAt: 'desc' },
    });
  }

  async generateRecoveryCodes(userId: string): Promise<string[]> {
    const plainCodes: string[] = [];
    const dbData: { userId: string; codeHash: string }[] = [];

    // Delete existing unused recovery codes
    await this.prisma.mFARecoveryCode.deleteMany({
      where: { userId, used: false },
    });

    for (let i = 0; i < 8; i++) {
      const code = crypto.randomBytes(4).toString('hex').toUpperCase(); // e.g. A1B2C3D4
      const codeHash = crypto.createHash('sha256').update(code).digest('hex');
      plainCodes.push(code);
      dbData.push({ userId, codeHash });
    }

    await this.prisma.mFARecoveryCode.createMany({
      data: dbData,
    });

    return plainCodes;
  }

  async verifyRecoveryCode(userId: string, code: string): Promise<boolean> {
    const codeHash = crypto.createHash('sha256').update(code).digest('hex');
    const recoveryCode = await this.prisma.mFARecoveryCode.findFirst({
      where: { userId, codeHash, used: false },
    });

    if (!recoveryCode) {
      return false;
    }

    await this.prisma.mFARecoveryCode.update({
      where: { id: recoveryCode.id },
      data: { used: true },
    });

    return true;
  }
}
