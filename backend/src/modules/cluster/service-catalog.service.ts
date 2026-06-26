import { Injectable } from '@nestjs/common';

export interface CatalogServiceItem {
  id: string;
  name: string;
  owner: string;
  repositoryUrl: string;
  version: string;
  healthEndpoint: string;
  sloOwner: string;
  dependencies: string[];
}

@Injectable()
export class ServiceCatalogService {
  private services: CatalogServiceItem[] = [
    {
      id: 'srv-backend',
      name: 'teamos-backend',
      owner: 'Platform Team',
      repositoryUrl: 'https://github.com/teamos/backend',
      version: 'v1.21.0-rc1',
      healthEndpoint: 'http://teamos-backend:3000/health',
      sloOwner: 'SRE-Squad-Alpha',
      dependencies: ['redis-cluster', 'postgres-primary', 'OpenAI API Gateway'],
    },
    {
      id: 'srv-frontend',
      name: 'teamos-frontend',
      owner: 'UI Team',
      repositoryUrl: 'https://github.com/teamos/frontend',
      version: 'v1.20.0',
      healthEndpoint: 'http://teamos-frontend:80/health',
      sloOwner: 'SRE-Squad-Alpha',
      dependencies: ['teamos-backend'],
    },
    {
      id: 'srv-graphql',
      name: 'graphql-gateway',
      owner: 'PaaS Developer Team',
      repositoryUrl: 'https://github.com/teamos/graphql-gateway',
      version: 'v1.20.0',
      healthEndpoint: 'http://graphql-gateway:3500/health',
      sloOwner: 'SRE-Squad-Beta',
      dependencies: ['teamos-backend'],
    },
  ];

  async getCatalog(): Promise<CatalogServiceItem[]> {
    return this.services;
  }

  async registerService(item: Omit<CatalogServiceItem, 'id'>): Promise<CatalogServiceItem> {
    const newItem: CatalogServiceItem = {
      id: `srv-${Math.random().toString(36).substr(2, 9)}`,
      ...item,
    };
    this.services.push(newItem);
    return newItem;
  }
}
