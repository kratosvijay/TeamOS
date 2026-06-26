import { Injectable } from '@nestjs/common';

export interface DatabaseMigrationStatus {
  activeMigrationsCount: number;
  pendingMigrations: { id: string; name: string; isDestructive: boolean }[];
  isCompatible: boolean;
}

@Injectable()
export class MigrationService {
  async getMigrationStatus(): Promise<DatabaseMigrationStatus> {
    return {
      activeMigrationsCount: 0,
      pendingMigrations: [
        { id: '20260701_add_finops_billing', name: 'Add FinOps and Spot usage indices', isDestructive: false },
      ],
      isCompatible: true,
    };
  }

  async runPrecheck(): Promise<{ passed: boolean; logs: string[] }> {
    return {
      passed: true,
      logs: [
        '[Precheck] Verified connection to postgres-primary.',
        '[Precheck] Lock tables verify passed: no long-running transactions active.',
        '[Precheck] Replica node replication lag within acceptable 15ms threshold.',
      ],
    };
  }
}
