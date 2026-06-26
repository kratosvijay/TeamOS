import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

export interface ModelRoute {
  category: string;
  primaryModel: string;
  fallbackModel: string;
  provider: 'OPENAI' | 'CLAUDE' | 'GEMINI' | 'OLLAMA';
  costPerThousandTokens: number;
}

@Injectable()
export class ModelRegistryService {
  private routingRules = new Map<string, ModelRoute>();

  constructor(private readonly prisma: PrismaService) {
    this.initializeDefaultRouting();
  }

  private initializeDefaultRouting() {
    this.routingRules.set('executive', {
      category: 'executive',
      primaryModel: 'gpt-5-preview',
      fallbackModel: 'gpt-4o',
      provider: 'OPENAI',
      costPerThousandTokens: 0.015,
    });

    this.toolsRoute('finance', 'claude-3-5-sonnet', 'claude-3-haiku', 'CLAUDE', 0.003);
    this.toolsRoute('general', 'gemini-1.5-pro', 'gemini-1.5-flash', 'GEMINI', 0.00125);
    this.toolsRoute('private_cloud', 'llama3-70b-offline', 'llama3-8b-offline', 'OLLAMA', 0.0);
  }

  private toolsRoute(category: string, primaryModel: string, fallbackModel: string, provider: any, cost: number) {
    this.routingRules.set(category, {
      category,
      primaryModel,
      fallbackModel,
      provider,
      costPerThousandTokens: cost,
    });
  }

  async getRouteForTask(category: string): Promise<ModelRoute> {
    const route = this.routingRules.get(category);
    if (route) return route;

    // Fallback to general Gemini
    return {
      category: 'general',
      primaryModel: 'gemini-1.5-flash',
      fallbackModel: 'gemini-1.5-flash',
      provider: 'GEMINI',
      costPerThousandTokens: 0.0003,
    };
  }

  async setRoute(route: ModelRoute) {
    this.routingRules.set(route.category, route);
    return route;
  }
}
