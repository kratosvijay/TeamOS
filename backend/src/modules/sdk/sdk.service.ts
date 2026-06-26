import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class SdkService {
  constructor(private readonly prisma: PrismaService) {}

  async getWorkspaceContext(workspaceId: string) {
    return this.prisma.workspace.findUnique({
      where: { id: workspaceId },
    });
  }

  async verifyApiKey(keyHash: string) {
    const key = await this.prisma.aPIKey.findUnique({
      where: { keyHash },
    });
    if (!key) return null;
    if (key.expiresAt && key.expiresAt < new Date()) return null;

    await this.prisma.aPIKey.update({
      where: { id: key.id },
      data: { lastUsed: new Date() },
    });

    return key;
  }

  async getStorageSettings(workspaceId: string) {
    return {
      bucket: `workspace-${workspaceId}-bucket`,
      endpoint: process.env.MINIO_ENDPOINT || 'localhost',
    };
  }

  async getTasks(workspaceId: string) {
    return this.prisma.task.findMany({
      where: { project: { workspaceId } },
      take: 20,
    });
  }

  async getDocuments(workspaceId: string) {
    return this.prisma.document.findMany({
      where: { workspaceId },
      take: 20,
    });
  }

  async getMeetings(workspaceId: string) {
    return this.prisma.meeting.findMany({
      where: { workspaceId },
      take: 20,
    });
  }

  async getErpData(workspaceId: string) {
    return {
      workspaceId,
      invoices: await this.prisma.invoice.findMany({ where: { workspaceId }, take: 10 }),
      budget: await this.prisma.budget.findMany({ where: { workspaceId }, take: 10 }),
    };
  }

  async executeAiCompletion(prompt: string) {
    return {
      text: `Mocked AI response for: "${prompt}"`,
      model: 'Gemini 3.5 Flash',
      usage: { promptTokens: 12, completionTokens: 15 },
    };
  }
}
