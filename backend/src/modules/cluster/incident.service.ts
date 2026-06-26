import { Injectable } from '@nestjs/common';

export interface IncidentRecord {
  id: string;
  title: string;
  severity: 'LOW' | 'MEDIUM' | 'HIGH' | 'CRITICAL';
  status: 'OPEN' | 'ACKNOWLEDGED' | 'RESOLVED';
  linkedAlertRules: string[];
  createdAt: Date;
  resolvedAt?: Date;
  timeline: { timestamp: Date; event: string }[];
  rollbackLinked?: boolean;
}

@Injectable()
export class IncidentService {
  private incidents: IncidentRecord[] = [
    {
      id: 'inc-001',
      title: 'PostgreSQL Read Latency SLA Violation',
      severity: 'HIGH',
      status: 'OPEN',
      linkedAlertRules: ['DatabaseLatencyHigh'],
      createdAt: new Date(Date.now() - 3600000), // 1 hour ago
      timeline: [
        { timestamp: new Date(Date.now() - 3600000), event: 'Incident triggered by Alertmanager' },
        { timestamp: new Date(Date.now() - 3000000), event: 'Ops team acknowledged incident' },
      ],
      rollbackLinked: false,
    },
    {
      id: 'inc-002',
      title: 'GKE Node CPU Exhaustion Outage',
      severity: 'CRITICAL',
      status: 'RESOLVED',
      linkedAlertRules: ['NodeCPUExhausted'],
      createdAt: new Date(Date.now() - 7200000), // 2 hours ago
      resolvedAt: new Date(Date.now() - 5400000),
      timeline: [
        { timestamp: new Date(Date.now() - 7200000), event: 'Alert fired: CPU utilization exceeded 95%' },
        { timestamp: new Date(Date.now() - 6500000), event: 'Autoscaler scaled node pool to 4 instances' },
        { timestamp: new Date(Date.now() - 5400000), event: 'Metrics returned to healthy levels. Incident closed.' },
      ],
      rollbackLinked: false,
    },
  ];

  async getIncidents(): Promise<IncidentRecord[]> {
    return this.incidents;
  }

  async declareIncident(title: string, severity: 'LOW' | 'MEDIUM' | 'HIGH' | 'CRITICAL', alerts: string[]): Promise<IncidentRecord> {
    const newIncident: IncidentRecord = {
      id: `inc-${Math.random().toString(36).substr(2, 9)}`,
      title,
      severity,
      status: 'OPEN',
      linkedAlertRules: alerts,
      createdAt: new Date(),
      timeline: [{ timestamp: new Date(), event: `Incident declared manually with alerts: ${alerts.join(', ')}` }],
    };
    this.incidents.push(newIncident);
    return newIncident;
  }

  async addTimelineEvent(incidentId: string, event: string) {
    const incident = this.incidents.find((i) => i.id === incidentId);
    if (incident) {
      incident.timeline.push({ timestamp: new Date(), event });
    }
  }

  async resolveIncident(incidentId: string) {
    const incident = this.incidents.find((i) => i.id === incidentId);
    if (incident) {
      incident.status = 'RESOLVED';
      incident.resolvedAt = new Date();
      incident.timeline.push({ timestamp: new Date(), event: 'Incident resolved.' });
    }
  }
}
