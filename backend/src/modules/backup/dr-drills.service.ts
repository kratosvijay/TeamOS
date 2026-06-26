import { Injectable } from '@nestjs/common';

export interface DrDrillRecord {
  id: string;
  drillName: string;
  simulatedOutageType: 'DATABASE' | 'REGION' | 'REDIS' | 'AI_PROVIDER' | 'STORAGE' | 'NODE';
  scheduledAt: Date;
  status: 'PENDING' | 'IN_PROGRESS' | 'COMPLETED' | 'FAILED';
  recoveryTimeSeconds?: number;
  runbookFollowed?: string;
  lessonsLearned?: string[];
}

@Injectable()
export class DrDrillsService {
  private drills: DrDrillRecord[] = [
    {
      id: 'drill-001',
      drillName: 'Primary Database Failover Drill',
      simulatedOutageType: 'DATABASE',
      scheduledAt: new Date(Date.now() - 86400000 * 5),
      status: 'COMPLETED',
      recoveryTimeSeconds: 42,
      runbookFollowed: 'RB-DB-002: Postgres Replication Failover',
      lessonsLearned: ['Read replicas DNS switchover completed within 12 seconds.', 'Connection pool reconnect took 30 seconds.'],
    },
    {
      id: 'drill-002',
      drillName: 'US-East Region Outage Drill',
      simulatedOutageType: 'REGION',
      scheduledAt: new Date(Date.now() - 86400000 * 2),
      status: 'COMPLETED',
      recoveryTimeSeconds: 310,
      runbookFollowed: 'RB-INFRA-010: Multi-Region Traffic Failover',
      lessonsLearned: ['DNS routing to backup region GKE took 3 minutes.', 'Redis global datastore PITR validation passed.'],
    },
  ];

  async getDrillsList(): Promise<DrDrillRecord[]> {
    return this.drills;
  }

  async scheduleDrill(drillName: string, outageType: 'DATABASE' | 'REGION' | 'REDIS' | 'AI_PROVIDER' | 'STORAGE' | 'NODE'): Promise<DrDrillRecord> {
    const newDrill: DrDrillRecord = {
      id: `drill-${Math.random().toString(36).substr(2, 9)}`,
      drillName,
      simulatedOutageType: outageType,
      scheduledAt: new Date(),
      status: 'PENDING',
    };
    this.drills.push(newDrill);
    return newDrill;
  }

  async runDrill(drillId: string): Promise<DrDrillRecord> {
    const drill = this.drills.find(d => d.id === drillId);
    if (!drill) throw new Error('Drill not found');
    drill.status = 'IN_PROGRESS';
    
    // Simulate recovery actions asynchronously
    setTimeout(() => {
      drill.status = 'COMPLETED';
      drill.recoveryTimeSeconds = Math.floor(Math.random() * 120) + 15;
      drill.runbookFollowed = `RB-${drill.simulatedOutageType}-001`;
      drill.lessonsLearned = ['Automated alerts fired correctly.', 'Fallback recovery script executed with zero data loss.'];
    }, 1000);

    return drill;
  }
}
