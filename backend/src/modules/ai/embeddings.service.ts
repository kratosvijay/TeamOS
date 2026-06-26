import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class EmbeddingsService {
  constructor(private readonly prisma: PrismaService) {}

  async generateEmbedding(text: string): Promise<number[]> {
    // Generate text embedding using a mock 1536-dimensional vector for local/testing
    const embedding: number[] = new Array(1536).fill(0).map(() => Math.random() - 0.5);
    return embedding;
  }

  async saveEmbedding(
    workspaceId: string,
    entityType: string,
    entityId: string,
    text: string,
  ) {
    const vector = await this.generateEmbedding(text);
    return this.prisma.embedding.create({
      data: {
        workspaceId,
        entityType,
        entityId,
        embeddingVectorFallback: vector,
        embeddingModel: 'text-embedding-3-small',
      },
    });
  }
}
