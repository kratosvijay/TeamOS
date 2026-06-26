import { Injectable } from '@nestjs/common';

export interface Runbook {
  id: string;
  title: string;
  description: string;
  markdownContent: string;
  linkedAlertRules: string[];
}

@Injectable()
export class RunbookService {
  private runbooks: Runbook[] = [
    {
      id: 'RB-DB-001',
      title: 'PostgreSQL Connection Exhaustion Recovery',
      description: 'Runbook to recover when Postgres connections hit limits',
      markdownContent: `## Postgres Connection Exhaustion Recovery Runbook
### Steps to resolve:
1. Identify the source pods with high connections using:
   \`\`\`bash
   kubectl exec -it postgres-0 -- psql -U teamos_admin -c "SELECT client_addr, count(*) FROM pg_stat_activity GROUP BY client_addr;"
   \`\`\`
2. Scale down non-essential consumer deployments if necessary:
   \`\`\`bash
   kubectl scale deployment teamos-bi-worker --replicas=0 -n teamos
   \`\`\`
3. Increase max connections via runtime configuration overrides.
`,
      linkedAlertRules: ['PostgresConnectionsExhausted', 'DatabaseLatencyHigh'],
    },
    {
      id: 'RB-CACHE-002',
      title: 'Redis Node Recovery and Sentinel Promotion',
      description: 'Promote read replica if Redis primary goes offline',
      markdownContent: `## Redis Sentinel Promotion Runbook
### Steps to resolve:
1. Verify master state:
   \`\`\`bash
   redis-cli -p 26379 sentinel master teamos-master
   \`\`\`
2. If failover is stuck, force manual promotion of healthy replica node:
   \`\`\`bash
   redis-cli -p 26379 sentinel failover teamos-master
   \`\`\`
`,
      linkedAlertRules: ['RedisReplicaLagHigh', 'RedisMasterOffline'],
    },
  ];

  async getRunbooks(): Promise<Runbook[]> {
    return this.runbooks;
  }

  async getRunbookById(id: string): Promise<Runbook | null> {
    return this.runbooks.find(r => r.id === id) || null;
  }

  async suggestRunbookForAlert(alertName: string): Promise<Runbook | null> {
    return this.runbooks.find(r => r.linkedAlertRules.includes(alertName)) || null;
  }
}
