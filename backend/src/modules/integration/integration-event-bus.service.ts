import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { AIService } from '../ai/ai.service';
import { TaskStatus, TaskPriority, TaskType } from '@prisma/client';

export interface StandardIntegrationEvent {
  provider: string;
  eventType: string;
  resourceId: string;
  workspaceId: string;
  payload: any;
}

@Injectable()
export class IntegrationEventBus {
  constructor(
    private readonly prisma: PrismaService,
    private readonly aiService: AIService,
  ) {}

  async publish(event: StandardIntegrationEvent) {
    const { provider, eventType, resourceId, workspaceId, payload } = event;

    // Log the event to the database
    const loggedEvent = await this.prisma.integrationEvent.create({
      data: {
        workspaceId,
        provider: provider.toUpperCase(),
        eventType,
        payload: payload as any,
        processed: false,
      },
    });

    console.log(`EventBus: Received event ${eventType} from ${provider}`);

    try {
      if (provider.toLowerCase() === 'github' && eventType === 'pull_request.opened') {
        await this.handleGitHubPROpened(workspaceId, resourceId, payload);
      } else if (provider.toLowerCase() === 'github' && eventType === 'push') {
        await this.handleGitHubPush(workspaceId, resourceId, payload);
      } else if (provider.toLowerCase() === 'gitlab' && eventType === 'merge_request') {
        await this.handleGitLabMROpened(workspaceId, resourceId, payload);
      }

      // Mark the event as processed
      await this.prisma.integrationEvent.update({
        where: { id: loggedEvent.id },
        data: { processed: true },
      });
    } catch (error) {
      console.error(`EventBus: Error processing event ${loggedEvent.id}`, error);
    }
  }

  private async handleGitHubPROpened(workspaceId: string, resourceId: string, payload: any) {
    const prTitle = payload.title || 'Untitled Pull Request';
    const prBody = payload.body || 'No description provided.';
    const repoName = payload.repository?.name || 'unknown-repo';
    const branchName = payload.head?.ref || 'main';

    // 1. Generate AI Summary of the Pull Request
    let aiSummary = '[Mock Summary] Optimized pgvector indexing queries and fixed BullMQ OAuth rotation latency.';
    try {
      if (this.aiService.generateSummary) {
        aiSummary = await this.aiService.generateSummary(prBody);
      }
    } catch (e) {
      console.warn('AI Summary generation failed, using fallback summary.', e);
    }

    // Resolve or find a default project in the workspace
    const project = await this.prisma.project.findFirst({
      where: { workspaceId },
    });

    if (!project) return;

    // 2. Create Task linked to this PR
    const task = await this.prisma.task.create({
      data: {
        projectId: project.id,
        key: `GH-${resourceId}`,
        title: `PR: ${prTitle}`,
        description: `GitHub PR #${resourceId} in ${repoName} (${branchName})\n\nDescription:\n${prBody}\n\nAI Summary:\n${aiSummary}`,
        status: TaskStatus.IN_PROGRESS,
        priority: TaskPriority.MEDIUM,
        type: TaskType.TASK,
      },
    });

    // 3. Create Audit log
    await this.prisma.auditTrail.create({
      data: {
        workspaceId,
        actorId: 'system-bot', // Bot placeholder actor ID
        action: 'GITHUB_PR_LINKED',
        entityType: 'Task',
        entityId: task.id,
        newValue: { prId: resourceId, taskKey: task.key },
      },
    });

    console.log(`EventBus: Created task ${task.key} for GitHub PR #${resourceId}`);
  }

  private async handleGitHubPush(workspaceId: string, resourceId: string, payload: any) {
    const commitMessage = payload.message || '';
    const author = payload.author?.name || 'Unknown Author';

    // Attempt to map commit to an existing task by matching GH-XXX pattern
    const match = commitMessage.match(/GH-(\d+)/i);
    if (match) {
      const taskKey = match[0].toUpperCase();
      const task = await this.prisma.task.findUnique({
        where: { key: taskKey },
      });

      if (task) {
        // Append commit description to task
        await this.prisma.task.update({
          where: { id: task.id },
          data: {
            description: `${task.description}\n\nCommit by ${author}:\n${commitMessage}`,
          },
        });

        console.log(`EventBus: Mapped commit ${resourceId} to Task ${task.key}`);
      }
    }
  }

  private async handleGitLabMROpened(workspaceId: string, resourceId: string, payload: any) {
    const mrTitle = payload.title || 'Untitled Merge Request';
    const mrDescription = payload.description || '';

    const project = await this.prisma.project.findFirst({
      where: { workspaceId },
    });
    if (!project) return;

    // Create GitLab MR task
    const task = await this.prisma.task.create({
      data: {
        projectId: project.id,
        key: `GL-${resourceId}`,
        title: `MR: ${mrTitle}`,
        description: `GitLab MR #${resourceId}\n\nDescription:\n${mrDescription}`,
        status: TaskStatus.IN_PROGRESS,
        priority: TaskPriority.MEDIUM,
        type: TaskType.TASK,
      },
    });

    console.log(`EventBus: Created task ${task.key} for GitLab MR #${resourceId}`);
  }
}
