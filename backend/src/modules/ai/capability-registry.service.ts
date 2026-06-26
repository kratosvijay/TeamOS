import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
export enum AgentCapability {
  PLANNING = 'PLANNING',
  SUMMARIZATION = 'SUMMARIZATION',
  OCR = 'OCR',
  FORECASTING = 'FORECASTING',
  TRANSLATION = 'TRANSLATION',
  CODE_REVIEW = 'CODE_REVIEW',
  DEPLOYMENT = 'DEPLOYMENT',
  THREAT_DETECTION = 'THREAT_DETECTION',
  SCHEDULING = 'SCHEDULING',
}

@Injectable()
export class CapabilityRegistryService {
  private agentCapabilities = new Map<string, AgentCapability[]>();

  constructor(private readonly prisma: PrismaService) {}

  async declareCapability(agentId: string, capabilities: AgentCapability[]) {
    this.agentCapabilities.set(agentId, capabilities);
    return { agentId, capabilities };
  }

  async getCapabilities(agentId: string): Promise<AgentCapability[]> {
    return this.agentCapabilities.get(agentId) || [];
  }

  async resolveAgentsByCapability(capability: AgentCapability): Promise<string[]> {
    const matching: string[] = [];
    for (const [agentId, caps] of this.agentCapabilities.entries()) {
      if (caps.includes(capability)) {
        matching.push(agentId);
      }
    }

    // Default fallback agent resolution if none are explicitly declared in memory
    if (matching.length === 0) {
      const dbAgents = await this.prisma.aIAgent.findMany({
        take: 3,
      });
      dbAgents.forEach((a) => matching.push(a.id));
    }

    return matching;
  }
}
