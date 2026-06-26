import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { SearchService } from '../search/search.service';
import { EmbeddingsService } from './embeddings.service';

@Injectable()
export class SemanticSearchService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly searchService: SearchService,
    private readonly embeddingsService: EmbeddingsService,
  ) {}

  async hybridSearch(workspaceId: string, query: string, collectionId?: string): Promise<any[]> {
    // 1. Text Search via SearchService
    let lexicalHits: any[] = [];
    try {
      lexicalHits = await this.searchService.search(query, [workspaceId]);
    } catch (e) {
      lexicalHits = [];
    }

    // 2. Vector Search via Prisma embeddings (simulated cosine similarity over embeddingVectorFallback)
    const queryVector = await this.embeddingsService.generateEmbedding(query);
    const dbEmbeddings = await this.prisma.embedding.findMany({
      where: { workspaceId },
      take: 10,
    });

    const semanticHits = dbEmbeddings
      .map((emb) => {
        const vec = (emb.embeddingVectorFallback as number[]) || [];
        // Calculate mock cosine similarity
        let similarity = 0.5;
        if (vec.length === queryVector.length) {
          let dotProduct = 0;
          let normA = 0;
          let normB = 0;
          for (let i = 0; i < vec.length; i++) {
            dotProduct += vec[i] * queryVector[i];
            normA += vec[i] * vec[i];
            normB += queryVector[i] * queryVector[i];
          }
          similarity = normA && normB ? dotProduct / (Math.sqrt(normA) * Math.sqrt(normB)) : 0.5;
        }
        return {
          id: emb.entityId,
          type: emb.entityType,
          score: similarity,
          source: 'semantic',
        };
      })
      .filter((hit) => hit.score > 0.1)
      .sort((a, b) => b.score - a.score);

    // 3. Filter by collectionId if provided
    let collectionNodeIds = new Set<string>();
    if (collectionId) {
      const collectionNodes = await this.prisma.knowledgeCollectionNode.findMany({
        where: { collectionId },
      });
      collectionNodes.forEach((n) => collectionNodeIds.add(n.nodeId));
    }

    // 4. Merge and deduplicate results
    const merged = new Map<string, any>();
    for (const hit of semanticHits) {
      if (collectionId && !collectionNodeIds.has(hit.id)) continue;
      merged.set(hit.id, { ...hit, rank: hit.score * 1.5 }); // Vector weight multiplier
    }

    for (const hit of lexicalHits) {
      if (collectionId && !collectionNodeIds.has(hit.id)) continue;
      if (merged.has(hit.id)) {
        const existing = merged.get(hit.id);
        existing.rank += 0.5; // Score boost for hybrid hits
        existing.source = 'hybrid';
      } else {
        merged.set(hit.id, {
          id: hit.id,
          type: hit.type || 'DOCUMENT',
          score: 0.5,
          source: 'lexical',
          rank: 0.5,
        });
      }
    }

    return Array.from(merged.values()).sort((a, b) => b.rank - a.rank);
  }
}
