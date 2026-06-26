import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class PackageManagerService {
  constructor(private prisma: PrismaService) {}

  async exportPackage(workspaceId: string, applicationId: string, version: string) {
    const app = await this.prisma.application.findUnique({ where: { id: applicationId } });
    if (!app) throw new Error('Application not found');

    const bundle = {
      appId: applicationId,
      name: app.name,
      version,
      configJson: app.configJson,
      exportedAt: new Date().toISOString(),
    };

    // Simulate cryptographic signing
    const signature = `sha256-sig-${Buffer.from(JSON.stringify(bundle)).toString('base64').substring(0, 32)}`;

    return this.prisma.applicationPackage.create({
      data: {
        workspaceId,
        applicationId,
        version,
        bundleJson: JSON.stringify(bundle),
        signature,
        publicKey: 'eap-signing-public-key-2026',
      },
    });
  }

  async verifyAndInstallPackage(workspaceId: string, packageJson: string, signature: string) {
    // Basic verification simulation
    if (!signature.startsWith('sha256-sig-')) {
      throw new Error('Invalid cryptographic signature. Tampering suspected.');
    }

    const payload = JSON.parse(packageJson);
    
    // Create new application from package
    return this.prisma.application.create({
      data: {
        workspaceId,
        name: `${payload.name} (Installed)`,
        status: 'ACTIVE',
        configJson: payload.configJson || '{}',
      },
    });
  }

  async rollbackOverrides(workspaceId: string, applicationId: string, toVersion: string) {
    const versionLog = await this.prisma.applicationVersion.findFirst({
      where: { workspaceId, applicationId, version: toVersion },
    });
    if (!versionLog) throw new Error('Target rollback version not found');

    return this.prisma.application.update({
      where: { id: applicationId },
      data: { configJson: versionLog.metadataJson },
    });
  }
}
