import { Injectable, OnModuleInit } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { KnowledgeEntityType, KnowledgeRelationType } from '@prisma/client';

@Injectable()
export class KnowledgeService implements OnModuleInit {
  constructor(private readonly prisma: PrismaService) {}

  async onModuleInit() {
    // Initialization code
  }

  async createNode(
    workspaceId: string,
    entityType: KnowledgeEntityType,
    entityId: string,
    label: string,
    metadata: any = {},
  ) {
    return this.prisma.knowledgeNode.upsert({
      where: { entityId },
      update: { label, metadata },
      create: { workspaceId, entityType, entityId, label, metadata },
    });
  }

  async createEdge(
    workspaceId: string,
    sourceNodeId: string,
    targetNodeId: string,
    relationType: KnowledgeRelationType,
    metadata: any = {},
  ) {
    return this.prisma.knowledgeEdge.create({
      data: { workspaceId, sourceNodeId, targetNodeId, relationType, metadata },
    });
  }

  async traverseGraph(
    workspaceId: string,
    startNodeId: string,
    maxDepth: number = 3,
  ): Promise<any> {
    const nodes = new Map<string, any>();
    const edges: any[] = [];
    const queue = [{ id: startNodeId, depth: 0 }];
    const visited = new Set<string>();

    while (queue.length > 0) {
      const { id, depth } = queue.shift()!;
      if (visited.has(id) || depth > maxDepth) continue;
      visited.add(id);

      const node = await this.prisma.knowledgeNode.findUnique({
        where: { id },
      });

      if (!node) continue;
      nodes.set(id, node);

      const outgoing = await this.prisma.knowledgeEdge.findMany({
        where: { workspaceId, sourceNodeId: id },
      });

      for (const edge of outgoing) {
        edges.push(edge);
        if (!visited.has(edge.targetNodeId)) {
          queue.push({ id: edge.targetNodeId, depth: depth + 1 });
        }
      }
    }

    return {
      nodes: Array.from(nodes.values()),
      edges,
    };
  }
}
