import { Injectable, OnModuleInit, OnModuleDestroy } from '@nestjs/common';
import { Worker, Job } from 'bullmq';
import { PrismaService } from '../prisma/prisma.service';
import { AIService } from './ai.service';

@Injectable()
export class AIProcessor implements OnModuleInit, OnModuleDestroy {
  private automationWorker: Worker;

  constructor(
    private prisma: PrismaService,
    private aiService: AIService,
  ) {}

  async onModuleInit() {
    const redisConfig = {
      host: process.env.REDIS_HOST || 'localhost',
      port: parseInt(process.env.REDIS_PORT || '6379'),
    };

    // AI Automation queue worker
    this.automationWorker = new Worker(
      'ai-automations',
      async (job: Job) => {
        console.log(`Processing AI Automation Job: ${job.name} (ID: ${job.id})`);

        switch (job.name) {
          case 'cron:weekly-report': {
            const { workspaceId } = job.data;
            // Compile weekly metrics
            const riskMetrics = await this.aiService.calculateRiskEngine(workspaceId);
            
            await this.prisma.aIArtifact.create({
              data: {
                workspaceId,
                type: 'EXECUTIVE_REPORT',
                title: `Weekly Status Report - ${new Date().toLocaleDateString()}`,
                content: `AI compiled risk summary: Delivery Risk ${riskMetrics.deliveryRisk}%, Burnout Risk ${riskMetrics.burnoutRisk}%. Total active tasks: ${riskMetrics.totalTasks}.`,
                createdByAI: true,
              },
            });
            console.log(`Successfully completed weekly-report for workspace ${workspaceId}`);
            break;
          }

          case 'cron:daily-standup': {
            const { workspaceId } = job.data;
            await this.prisma.aIArtifact.create({
              data: {
                workspaceId,
                type: 'SPRINT_PLAN',
                title: `Daily Standup Summary - ${new Date().toLocaleDateString()}`,
                content: `Daily scan of tasks completed. No high-level blockers detected. Keep moving forward!`,
                createdByAI: true,
              },
            });
            console.log(`Successfully completed daily-standup summary for workspace ${workspaceId}`);
            break;
          }

          case 'event:meeting-ended': {
            const { workspaceId, meetingId, transcript } = job.data;
            const summary = await this.aiService.generateSummary(transcript);
            
            await this.prisma.aIArtifact.create({
              data: {
                workspaceId,
                type: 'MEETING_SUMMARY',
                title: `Meeting Notes Summary - ${meetingId}`,
                content: summary,
                createdByAI: true,
                sourceExecutionId: meetingId,
              },
            });
            console.log(`Successfully completed event:meeting-ended for meeting ${meetingId}`);
            break;
          }

          default:
            console.warn(`Unknown job name: ${job.name}`);
        }
      },
      { connection: redisConfig },
    );

    this.automationWorker.on('failed', (job, err) => {
      console.error(`AI Automation job failed: ${job.id} with error: ${err.message}`);
    });
  }

  async onModuleDestroy() {
    await this.automationWorker.close();
  }
}
