import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class KnowledgeCollectionService {
  constructor(private readonly prisma: PrismaService) {}

  async createCollection(workspaceId: string, name: string, description?: string) {
    return this.prisma.knowledgeCollection.create({
      data: { workspaceId, name, description },
    });
  }

  async addNodeToCollection(collectionId: string, nodeId: string) {
    return this.prisma.knowledgeCollectionNode.create({
      data: { collectionId, nodeId },
    });
  }

  async getCollectionNodes(collectionId: string) {
    return this.prisma.knowledgeCollectionNode.findMany({
      where: { collectionId },
      include: {
        node: true,
      },
    });
  }
}
