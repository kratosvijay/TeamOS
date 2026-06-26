import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class ApplicationLifecycleService {
  constructor(private prisma: PrismaService) {}

  async createDraft(workspaceId: string, name: string, description?: string) {
    return this.prisma.application.create({
      data: { workspaceId, name, description, status: 'DRAFT' },
    });
  }

  async checkinVersion(workspaceId: string, applicationId: string, version: string, metadataJson: string) {
    return this.prisma.applicationVersion.create({
      data: { workspaceId, applicationId, version, metadataJson, status: 'DRAFT' },
    });
  }

  async publishVersion(workspaceId: string, applicationId: string, versionId: string) {
    const version = await this.prisma.applicationVersion.findUnique({ where: { id: versionId } });
    if (!version) throw new Error('Version not found');

    await this.prisma.applicationVersion.update({
      where: { id: versionId },
      data: { status: 'PUBLISHED' },
    });

    return this.prisma.application.update({
      where: { id: applicationId },
      data: { status: 'ACTIVE', configJson: version.metadataJson },
    });
  }

  async archiveApplication(workspaceId: string, applicationId: string) {
    return this.prisma.application.update({
      where: { id: applicationId },
      data: { status: 'ARCHIVED' },
    });
  }

  async cloneApplication(workspaceId: string, applicationId: string, newName: string) {
    const app = await this.prisma.application.findUnique({ where: { id: applicationId } });
    if (!app) throw new Error('Application not found');

    return this.prisma.application.create({
      data: {
        workspaceId,
        name: newName,
        description: app.description,
        status: 'DRAFT',
        configJson: app.configJson,
      },
    });
  }
}
