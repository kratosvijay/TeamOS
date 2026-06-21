import { Injectable, OnModuleInit, OnModuleDestroy } from '@nestjs/common';
import { Worker, Job } from 'bullmq';
import { PrismaService } from '../prisma/prisma.service';
import { ChannelType, MeetingStatus } from '@prisma/client';

@Injectable()
export class ProjectProvisioningWorker implements OnModuleInit, OnModuleDestroy {
  private worker: Worker;

  constructor(private prisma: PrismaService) {}

  async onModuleInit() {
    const redisHost = process.env.REDIS_HOST || 'localhost';
    const redisPort = parseInt(process.env.REDIS_PORT || '6379');

    this.worker = new Worker(
      'project-provisioning',
      async (job: Job) => {
        const { projectId, workspaceId, userId, projectName, projectKey } = job.data;
        console.log(`[Provisioning Worker] Starting provisioning for Project: ${projectKey} (ID: ${projectId})`);

        try {
          // 1. CreateChatChannelHandler
          await this.createChatChannel(workspaceId, projectId, projectKey);

          // 2. CreateMeetingRoomHandler
          await this.createMeetingRoom(workspaceId, projectId, userId, projectKey);

          // 3. CreateDocumentSpaceHandler
          await this.createDocumentSpace(projectId, userId);

          // 4. CreateStorageFolderHandler
          await this.createStorageFolder(workspaceId, projectId);

          // 5. CreateDefaultSprintHandler
          await this.createDefaultSprint(projectId);

          console.log(`[Provisioning Worker] Successfully provisioned all resources for Project ID: ${projectId}`);
        } catch (e) {
          console.error(`[Provisioning Worker] Error during project provisioning execution:`, e);
          throw e; // Reraise to let BullMQ retry or move to DLQ
        }
      },
      { connection: { host: redisHost, port: redisPort } },
    );

    this.worker.on('failed', (job, err) => {
      console.error(`[Provisioning Worker] Job failed: ${job.id} | attempts: ${job.attemptsMade} | error: ${err.message}`);
    });
  }

  async onModuleDestroy() {
    await this.worker.close();
  }

  // Handlers implementations
  private async createChatChannel(workspaceId: string, projectId: string, projectKey: string) {
    console.log(`[Handler: CreateChatChannelHandler] Setting up default text channels: general, announcements, development`);
    const defaultChannels = [
      { name: 'general', description: 'General project discussion' },
      { name: 'announcements', description: 'Important announcements and alerts' },
      { name: 'development', description: 'Development and engineering discussions' },
    ];

    for (const chan of defaultChannels) {
      await this.prisma.channel.create({
        data: {
          workspaceId,
          projectId,
          name: chan.name,
          description: chan.description,
          type: ChannelType.PROJECT_TEXT,
        },
      });
    }
  }

  private async createMeetingRoom(workspaceId: string, projectId: string, userId: string, projectKey: string) {
    console.log(`[Handler: CreateMeetingRoomHandler] Allocating LiveKit meeting room`);
    const roomName = `meet-${projectKey}-${Math.random().toString(36).substring(2, 6).toUpperCase()}`;
    await this.prisma.meeting.create({
      data: {
        workspaceId,
        projectId,
        hostId: userId,
        title: 'Project Standup',
        description: `Standup meeting room for project [${projectKey}]`,
        status: MeetingStatus.SCHEDULED,
        roomName,
      },
    });
  }

  private async createDocumentSpace(projectId: string, userId: string) {
    console.log(`[Handler: CreateDocumentSpaceHandler] Allocating documents Wiki space`);
    await this.prisma.document.create({
      data: {
        projectId,
        title: 'Wiki Home',
        content: '# Welcome to the Project wiki!\nStart editing document spaces to construct knowledge bases.',
        isWiki: true,
        creatorId: userId,
        updaterId: userId,
      },
    });
  }

  private async createStorageFolder(workspaceId: string, projectId: string) {
    console.log(`[Handler: CreateStorageFolderHandler] Registering prefix workspace/${workspaceId}/project/${projectId}/`);
    // Logic logs or configures folder structure in S3/MinIO bucket
  }

  private async createDefaultSprint(projectId: string) {
    console.log(`[Handler: CreateDefaultSprintHandler] Spawns default Sprint 1`);
    const startDate = new Date();
    const endDate = new Date();
    endDate.setDate(endDate.getDate() + 14); // 2 weeks sprint duration

    await this.prisma.sprint.create({
      data: {
        projectId,
        name: 'Sprint 1',
        goal: 'Complete initial setup and kickoff milestones',
        startDate,
        endDate,
        isActive: true,
      },
    });
  }
}
