import { Injectable } from '@nestjs/common';

export interface SloReport {
  workspaceId: string;
  availabilitySli: number;
  latencySliMs: number;
  errorBudgetRemaining: number;
}

@Injectable()
export class SloService {
  private sloRecords = new Map<string, { requests: number; errors: number; totalLatencyMs: number }>();

  recordRequest(workspaceId: string, durationMs: number, isError: boolean) {
    const record = this.sloRecords.get(workspaceId) || { requests: 0, errors: 0, totalLatencyMs: 0 };
    record.requests++;
    record.totalLatencyMs += durationMs;
    if (isError) {
      record.errors++;
    }
    this.sloRecords.set(workspaceId, record);

    // Trigger alert if error rate is too high (SLO violation)
    const errRatio = record.errors / record.requests;
    if (record.requests > 10 && errRatio > 0.05) {
      console.warn(`[Alertmanager] SLO Violation Warning: ${workspaceId} error rate is ${(errRatio * 100).toFixed(2)}%`);
    }
  }

  getSloReport(workspaceId: string): SloReport {
    const record = this.sloRecords.get(workspaceId) || { requests: 0, errors: 0, totalLatencyMs: 0 };
    const requests = record.requests === 0 ? 1 : record.requests;
    const availability = 1 - record.errors / requests;
    const avgLatency = record.totalLatencyMs / requests;

    return {
      workspaceId,
      availabilitySli: availability,
      latencySliMs: avgLatency,
      errorBudgetRemaining: Math.max(0, 100 - (record.errors / requests) * 100 * 20), // mock budget calculation
    };
  }
}
