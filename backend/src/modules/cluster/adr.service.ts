import { Injectable } from '@nestjs/common';

export interface ArchitectureDecisionRecord {
  id: string;
  title: string;
  status: 'PROPOSED' | 'ACCEPTED' | 'REJECTED' | 'SUPERSEDED';
  owner: string;
  date: string;
  linkedReleases: string[];
  context: string;
  decision: string;
}

@Injectable()
export class AdrService {
  private adrs: ArchitectureDecisionRecord[] = [
    {
      id: 'ADR-001',
      title: 'Database Migration & Schema Isolation Strategy',
      status: 'ACCEPTED',
      owner: 'Platform Team',
      date: '2026-06-01',
      linkedReleases: ['v1.19.0', 'v1.20.0'],
      context: 'We needed a clear isolation model for multi-tenant database transactions without sacrificing querying performance for analytical reports.',
      decision: 'Utilize Prisma schema-level partitions combined with workspace-aware connection parameters in the platform connection pool.',
    },
    {
      id: 'ADR-002',
      title: 'Service Mesh Configuration with Istio STRICT mTLS',
      status: 'ACCEPTED',
      owner: 'SecOps Team',
      date: '2026-06-15',
      linkedReleases: ['v1.21.0-rc1'],
      context: 'Enterprise compliance audits require all pod-to-pod communications to be encrypted at rest and in transit.',
      decision: 'Enforce STRICT mTLS across all namespaces in the TeamOS cluster using Istio PeerAuthentication resources.',
    },
  ];

  async getAdrs(): Promise<ArchitectureDecisionRecord[]> {
    return this.adrs;
  }

  async createAdr(
    title: string,
    status: 'PROPOSED' | 'ACCEPTED' | 'REJECTED' | 'SUPERSEDED',
    owner: string,
    linkedReleases: string[],
    context: string,
    decision: string
  ): Promise<ArchitectureDecisionRecord> {
    const nextId = `ADR-00${this.adrs.length + 1}`;
    const newRecord: ArchitectureDecisionRecord = {
      id: nextId,
      title,
      status,
      owner,
      date: new Date().toISOString().split('T')[0],
      linkedReleases,
      context,
      decision,
    };
    this.adrs.push(newRecord);
    return newRecord;
  }
}
