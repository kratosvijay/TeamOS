import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class PromptRegistryService {
  constructor(private readonly prisma: PrismaService) {}

  async getPromptTemplate(workspaceId: string, name: string) {
    return this.prisma.aIPromptTemplate.findFirst({
      where: { workspaceId, name, isActive: true },
      orderBy: { version: 'desc' },
    });
  }

  async createPromptTemplate(
    workspaceId: string,
    name: string,
    category: string,
    systemPrompt: string,
    userPrompt: string,
  ) {
    // Find highest version
    const existing = await this.prisma.aIPromptTemplate.findFirst({
      where: { workspaceId, name },
      orderBy: { version: 'desc' },
    });

    const version = existing ? existing.version + 1 : 1;

    // Set other versions to inactive
    if (existing) {
      await this.prisma.aIPromptTemplate.updateMany({
        where: { workspaceId, name },
        data: { isActive: false },
      });
    }

    return this.prisma.aIPromptTemplate.create({
      data: {
        workspaceId,
        name,
        category,
        systemPrompt,
        userPrompt,
        version,
        isActive: true,
      },
    });
  }

  bindParameters(templateText: string, params: Record<string, string>): string {
    let bound = templateText;
    for (const [key, val] of Object.entries(params)) {
      bound = bound.replace(new RegExp(`{{${key}}}`, 'g'), val);
    }
    return bound;
  }
}
