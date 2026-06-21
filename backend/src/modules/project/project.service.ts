import { Injectable, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { Queue } from 'bullmq';
import { ProjectRole } from '@prisma/client';

@Injectable()
export class ProjectService {
  private provisioningQueue: Queue;

  constructor(private prisma: PrismaService) {
    const redisHost = process.env.REDIS_HOST || 'localhost';
    const redisPort = parseInt(process.env.REDIS_PORT || '6379');
    
    // Instantiate BullMQ Queue for Project Provisioning
    this.provisioningQueue = new Queue('project-provisioning', {
      connection: { host: redisHost, port: redisPort },
    });
  }

  generateProjectKey(name: string): string {
    const words = name.trim().split(/\s+/);
    let key = '';
    
    if (words.length >= 3) {
      key = words.map(w => w[0]).join('');
    } else if (words.length === 2) {
      key = words[0].substring(0, 2) + words[1][0];
    } else {
      const clean = name.replace(/[^a-zA-Z0-9]/g, '');
      key = clean.length >= 3 ? clean.substring(0, 3) : clean.padEnd(3, 'X');
    }

    return key.toUpperCase();
  }

  async createProject(userId: string, workspaceId: string, name: string, description?: string) {
    const key = this.generateProjectKey(name);

    // Verify key uniqueness in this workspace
    const existing = await this.prisma.project.findFirst({
      where: { workspaceId, OR: [{ name }, { key }] },
    });

    if (existing) {
      throw new BadRequestException('Project name or generated key already exists in this workspace');
    }

    return this.prisma.$transaction(async (tx) => {
      // Create project
      const project = await tx.project.create({
        data: {
          workspaceId,
          name,
          key,
          description,
        },
      });

      // Add owner as Project Lead
      await tx.projectMember.create({
        data: {
          projectId: project.id,
          userId,
          role: ProjectRole.LEAD,
        },
      });

      // Enqueue Asynchronous Domain Event for Resource Provisioning
      await this.provisioningQueue.add(
        'project:created',
        {
          projectId: project.id,
          workspaceId: workspaceId,
          userId: userId,
          projectName: name,
          projectKey: key,
        },
        {
          attempts: 3,
          backoff: { type: 'exponential', delay: 5000 },
        },
      );

      // Create Activity Log
      await tx.activityLog.create({
        data: {
          workspaceId,
          userId,
          entityType: 'PROJECT',
          entityId: project.id,
          action: 'CREATED',
          metadata: { name, key },
        },
      });

      return project;
    });
  }

  async getProjects(workspaceId: string) {
    return this.prisma.project.findMany({
      where: { workspaceId, status: 'ACTIVE' },
      include: {
        members: {
          include: {
            user: { select: { id: true, fullName: true, avatarUrl: true } },
          },
        },
      },
    });
  }

  async archiveProject(workspaceId: string, projectId: string, userId: string) {
    return this.prisma.$transaction(async (tx) => {
      const project = await tx.project.update({
        where: { id: projectId },
        data: { status: 'ARCHIVED' },
      });

      await tx.activityLog.create({
        data: {
          workspaceId,
          userId,
          entityType: 'PROJECT',
          entityId: projectId,
          action: 'DELETED',
          metadata: { name: project.name },
        },
      });

      return project;
    });
  }
}
