import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

export interface ToolDefinition {
  name: string;
  description: string;
  permission: string; // e.g. DEVELOPER, QA, OWNER
  risk: 'LOW' | 'MEDIUM' | 'HIGH';
  owner: string;
  timeoutMs: number;
  retryCount: number;
  fallbackStrategy: string;
  averageCost: number;
  averageLatencyMs: number;
  requiredApproval: boolean;
  version: string;
  health: 'HEALTHY' | 'DEGRADED';
}

@Injectable()
export class ToolRegistryService {
  private tools = new Map<string, ToolDefinition>();

  constructor(private readonly prisma: PrismaService) {
    this.initializeDefaultTools();
  }

  private initializeDefaultTools() {
    this.tools.set('invoiceOCR', {
      name: 'invoiceOCR',
      description: 'OCR script parser for billing invoice PDF uploads.',
      permission: 'DEVELOPER',
      risk: 'LOW',
      owner: 'finance_team',
      timeoutMs: 10000,
      retryCount: 3,
      fallbackStrategy: 'localMock',
      averageCost: 0.05,
      averageLatencyMs: 1500,
      requiredApproval: false,
      version: '1.0.1',
      health: 'HEALTHY',
    });

    this.tools.set('deploymentTrigger', {
      name: 'deploymentTrigger',
      description: 'K8s deployment trigger rollouts.',
      permission: 'ADMIN',
      risk: 'HIGH',
      owner: 'devops_sre',
      timeoutMs: 30000,
      retryCount: 1,
      fallbackStrategy: 'abortRollout',
      averageCost: 0.15,
      averageLatencyMs: 8000,
      requiredApproval: true,
      version: '2.0.0',
      health: 'HEALTHY',
    });
  }

  async getTool(name: string): Promise<ToolDefinition | null> {
    return this.tools.get(name) || null;
  }

  async registerTool(name: string, definition: ToolDefinition) {
    this.tools.set(name, definition);
    return definition;
  }

  async getAllTools(): Promise<ToolDefinition[]> {
    return Array.from(this.tools.values());
  }
}
