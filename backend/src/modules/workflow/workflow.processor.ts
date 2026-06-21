import { Injectable, OnModuleInit, OnModuleDestroy } from '@nestjs/common';
import { Worker, Job } from 'bullmq';
import { WorkflowEngine } from './workflow.engine';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class WorkflowProcessor implements OnModuleInit, OnModuleDestroy {
  private workers: Worker[] = [];

  constructor(
    private engine: WorkflowEngine,
    private prisma: PrismaService,
  ) {}

  async onModuleInit() {
    const redisConfig = {
      host: process.env.REDIS_HOST || 'localhost',
      port: parseInt(process.env.REDIS_PORT || '6379'),
    };

    const queueNames = [
      'workflow-execution',
      'workflow-timers',
      'workflow-escalations',
      'workflow-sla-monitor',
      'approval-reminders',
    ];

    for (const queue of queueNames) {
      const worker = new Worker(
        queue,
        async (job: Job) => {
          console.log(`Processing workflow queue [${queue}] job: ${job.id}`);
          return this.handleJob(queue, job);
        },
        { connection: redisConfig },
      );

      worker.on('failed', (job, err) => {
        console.error(`Workflow queue [${queue}] job ${job?.id} failed: ${err.message}`);
      });

      this.workers.push(worker);
    }
  }

  private async handleJob(queue: string, job: Job): Promise<any> {
    const { executionId, workflowId } = job.data;

    switch (queue) {
      case 'workflow-execution':
        if (executionId) {
          await this.engine.execute(executionId);
        }
        return { executed: true };

      case 'workflow-timers':
        console.log(`Timer triggered for execution: ${executionId}`);
        return { timerCompleted: true };

      case 'workflow-escalations':
        console.log(`Escalation triggered for execution: ${executionId}`);
        return { escalated: true };

      case 'workflow-sla-monitor':
        // Check if there are SLA breaches
        console.log(`SLA check triggered for workflow: ${workflowId}`);
        const sla = await this.prisma.sLAConfiguration.findFirst({
          where: { workspaceId: job.data.workspaceId },
        });
        if (sla) {
          console.log(`SLA Configuration active: ${sla.name}`);
        }
        return { slaMonitored: true };

      case 'approval-reminders':
        console.log(`Approval reminder triggered`);
        return { remindersSent: true };

      default:
        return { success: true };
    }
  }

  async onModuleDestroy() {
    for (const worker of this.workers) {
      await worker.close();
    }
  }
}
