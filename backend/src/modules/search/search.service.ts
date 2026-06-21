import { Injectable, OnModuleInit } from '@nestjs/common';
import { Client } from '@opensearch-project/opensearch';

@Injectable()
export class SearchService implements OnModuleInit {
  private client: Client;

  async onModuleInit() {
    const node = process.env.OPENSEARCH_NODE || 'http://localhost:9200';
    this.client = new Client({
      node: node,
      ssl: {
        rejectUnauthorized: false,
      },
    });
    console.log(`Connected to OpenSearch at node: ${node}`);
  }

  async indexEntity(type: string, id: string, payload: any) {
    try {
      await this.client.index({
        index: `teamos-${type}`,
        id: id,
        body: {
          ...payload,
          updatedAt: new Date().toISOString(),
        },
      });
      console.log(`OpenSearch: Entity indexed [${type}] with ID [${id}]`);
    } catch (e) {
      console.error(`OpenSearch: Indexing failed for [${type}:${id}]`, e);
    }
  }

  async deleteEntity(type: string, id: string) {
    try {
      await this.client.delete({
        index: `teamos-${type}`,
        id: id,
      });
      console.log(`OpenSearch: Entity deleted [${type}] with ID [${id}]`);
    } catch (e) {
      console.error(`OpenSearch: Deletion failed for [${type}:${id}]`, e);
    }
  }


  async search(query: string, indexes: string[] = ['teamos-*']) {
    try {
      const response = await this.client.search({
        index: indexes.join(','),
        body: {
          query: {
            multi_match: {
              query: query,
              fields: ['title', 'content', 'description', 'fullName', 'email', 'name'],
              fuzziness: 'AUTO',
            },
          },
        },
      });
      return response.body.hits.hits.map((hit) => ({
        id: hit._id,
        index: hit._index,
        score: hit._score,
        source: hit._source,
      }));
    } catch (e) {
      console.error('OpenSearch: Search failed', e);
      return [];
    }
  }
}
