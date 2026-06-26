import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class AgentRegistryService {
  private registry = new Map<string, any>();

  constructor(private readonly prisma: PrismaService) {}

  async registerAgent(
    agentId: string,
    metadata: {
      ownerId: string;
      department: string;
      version: string;
      permissions: string[];
      dependencies: string[];
      approvalRules: any;
    },
  ) {
    const entry = {
      agentId,
      ...metadata,
      health: 'HEALTHY',
      usageCount: 0,
      status: 'ACTIVE',
      updatedAt: new Date(),
    };
    this.registry.set(agentId, entry);
    return entry;
  }

  async getAgentDetails(agentId: string) {
    const fromMem = this.registry.get(agentId);
    if (fromMem) return fromMem;

    const dbAgent = await this.prisma.aIAgent.findUnique({
      where: { id: agentId },
    });

    if (!dbAgent) return null;

    return {
      agentId,
      name: dbAgent.name,
      purpose: dbAgent.purpose,
      ownerId: 'system',
      department: 'General',
      version: '1.0.0',
      health: 'HEALTHY',
      usageCount: 1,
      status: 'ACTIVE',
    };
  }

  async incrementUsage(agentId: string) {
    const entry = this.registry.get(agentId);
    if (entry) {
      entry.usageCount++;
      entry.updatedAt = new Date();
    }
  }

  async updateHealth(agentId: string, health: 'HEALTHY' | 'DEGRADED' | 'CRITICAL') {
    const entry = this.registry.get(agentId);
    if (entry) {
      entry.health = health;
      entry.updatedAt = new Date();
    }
  }
}
