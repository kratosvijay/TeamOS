import { Injectable } from '@nestjs/common';

export interface TenantOpsReport {
  workspaceId: string;
  cpuCoresUsed: number;
  memoryBytesUsed: number;
  storageBytesUsed: number;
  aiTokensCount: number;
  monthlyCostUSD: number;
  activeSessionsCount: number;
}

@Injectable()
export class TenantOperationsService {
  private tenantMetrics = new Map<string, TenantOpsReport>();

  constructor() {
    this.tenantMetrics.set('ws-engineering', {
      workspaceId: 'ws-engineering',
      cpuCoresUsed: 4.2,
      memoryBytesUsed: 12884901888, // 12 GiB
      storageBytesUsed: 536870912000, // 500 GiB
      aiTokensCount: 145020,
      monthlyCostUSD: 2450.00,
      activeSessionsCount: 42,
    });
    this.tenantMetrics.set('ws-marketing', {
      workspaceId: 'ws-marketing',
      cpuCoresUsed: 1.5,
      memoryBytesUsed: 4294967296, // 4 GiB
      storageBytesUsed: 107374182400, // 100 GiB
      aiTokensCount: 89000,
      monthlyCostUSD: 890.00,
      activeSessionsCount: 12,
    });
  }

  async getTenantReport(workspaceId: string): Promise<TenantOpsReport | null> {
    return this.tenantMetrics.get(workspaceId) || null;
  }

  async getAllTenantReports(): Promise<TenantOpsReport[]> {
    return Array.from(this.tenantMetrics.values());
  }
}
