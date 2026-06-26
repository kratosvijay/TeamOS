import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class MemoryHierarchyService {
  constructor(private readonly prisma: PrismaService) {}

  async storeMemory(
    workspaceId: string,
    type: string,
    content: string,
    options: { agentId?: string; userId?: string; department?: string; metadata?: any } = {},
  ) {
    return this.prisma.agentMemory.create({
      data: {
        workspaceId,
        type,
        content,
        agentId: options.agentId,
        userId: options.userId,
        department: options.department,
        metadata: options.metadata || {},
      },
    });
  }

  async retrieveContextPipeline(
    workspaceId: string,
    userId: string,
    conversationId: string,
    query: string,
    department?: string,
  ): Promise<any> {
    const memoryPipeline: any = {};

    // 1. Conversation Memory
    const convMemory = await this.prisma.aIMessage.findMany({
      where: { conversationId },
      orderBy: { createdAt: 'desc' },
      take: 5,
    });
    memoryPipeline.conversation = convMemory.map(m => `${m.role}: ${m.content}`).reverse();

    // 2. User Memory
    const userMemory = await this.prisma.agentMemory.findMany({
      where: { workspaceId, userId, type: 'USER' },
      take: 2,
    });
    memoryPipeline.user = userMemory.map(m => m.content);

    // 3. Workspace Memory
    const wsMemory = await this.prisma.aIWorkspaceMemory.findUnique({
      where: { workspaceId },
    });
    memoryPipeline.workspace = wsMemory ? [wsMemory.summary] : [];

    // 4. Department Memory (localized)
    if (department) {
      const deptMemory = await this.prisma.agentMemory.findMany({
        where: { workspaceId, department, type: 'DEPARTMENT' },
        take: 3,
      });
      memoryPipeline.department = deptMemory.map(m => m.content);
    } else {
      memoryPipeline.department = [];
    }

    // 5. Semantic Long-term Memory
    const semanticMemory = await this.prisma.agentMemory.findMany({
      where: { workspaceId, type: 'SEMANTIC' },
      take: 3,
    });
    memoryPipeline.semantic = semanticMemory.map(m => m.content);

    return memoryPipeline;
  }
}
