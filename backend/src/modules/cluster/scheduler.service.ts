import { Injectable } from '@nestjs/common';

export interface ScheduledJob {
  id: string;
  name: string;
  cronExpression: string;
  lastRun?: Date;
  status: 'IDLE' | 'RUNNING' | 'COMPLETED' | 'FAILED';
  runCount: number;
}

@Injectable()
export class DistributedSchedulerService {
  private isLeaderFlag = true; // Simulating GKE node state (current node is leader)
  private jobs: ScheduledJob[] = [
    { id: 'job-001', name: 'Billing Recurring Invoices Run', cronExpression: '0 0 * * *', status: 'IDLE', runCount: 15 },
    { id: 'job-002', name: 'Workspace Backup Sync', cronExpression: '0 */4 * * *', status: 'COMPLETED', runCount: 142, lastRun: new Date() },
    { id: 'job-003', name: 'SRE SLO Report Compiler', cronExpression: '*/30 * * * *', status: 'IDLE', runCount: 48, lastRun: new Date() },
  ];

  isLeader(): boolean {
    return this.isLeaderFlag;
  }

  async acquireLeaderLock() {
    this.isLeaderFlag = true;
    console.log('[Scheduler] Leader lock acquired by this instance');
  }

  async releaseLeaderLock() {
    this.isLeaderFlag = false;
    console.log('[Scheduler] Leader lock released by this instance');
  }

  async getScheduledJobs(): Promise<ScheduledJob[]> {
    return this.jobs;
  }

  async triggerJobImmediately(jobId: string): Promise<ScheduledJob> {
    const job = this.jobs.find((j) => j.id === jobId);
    if (!job) throw new Error('Job not found');

    if (!this.isLeader()) {
      throw new Error('Lock error: Only leader node can trigger scheduled jobs');
    }

    job.status = 'RUNNING';
    
    // Simulate async execution
    setTimeout(() => {
      job.status = 'COMPLETED';
      job.lastRun = new Date();
      job.runCount++;
    }, 1200);

    return job;
  }
}
