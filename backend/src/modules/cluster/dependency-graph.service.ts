import { Injectable } from '@nestjs/common';

export interface ServiceNode {
  id: string;
  name: string;
  type: 'SERVICE' | 'DATABASE' | 'CACHE' | 'EXTERNAL_API';
  status: 'HEALTHY' | 'DEGRADED' | 'DOWN';
  dependencies: string[]; // Linked node IDs
}

@Injectable()
export class DependencyGraphService {
  private nodes: ServiceNode[] = [
    { id: 'teamos-backend', name: 'teamos-backend', type: 'SERVICE', status: 'HEALTHY', dependencies: ['postgres-db', 'redis-cache', 'opensearch-index'] },
    { id: 'teamos-frontend', name: 'teamos-frontend', type: 'SERVICE', status: 'HEALTHY', dependencies: ['teamos-backend'] },
    { id: 'graphql-gateway', name: 'graphql-gateway', type: 'SERVICE', status: 'HEALTHY', dependencies: ['teamos-backend'] },
    { id: 'postgres-db', name: 'PostgreSQL DB', type: 'DATABASE', status: 'HEALTHY', dependencies: [] },
    { id: 'redis-cache', name: 'Redis Cache', type: 'CACHE', status: 'HEALTHY', dependencies: [] },
    { id: 'opensearch-index', name: 'OpenSearch Search', type: 'EXTERNAL_API', status: 'HEALTHY', dependencies: [] },
    { id: 'openai-api', name: 'OpenAI API Gateway', type: 'EXTERNAL_API', status: 'HEALTHY', dependencies: [] },
  ];

  async getTopologyNodes(): Promise<ServiceNode[]> {
    return this.nodes;
  }

  async calculateBlastRadius(failedNodeId: string): Promise<string[]> {
    const affected: Set<string> = new Set();
    const queue: string[] = [failedNodeId];

    while (queue.length > 0) {
      const current = queue.shift()!;
      // Find nodes that depend on the current node
      for (const node of this.nodes) {
        if (node.dependencies.includes(current) && !affected.has(node.id)) {
          affected.add(node.id);
          queue.push(node.id);
        }
      }
    }

    return Array.from(affected);
  }
}
