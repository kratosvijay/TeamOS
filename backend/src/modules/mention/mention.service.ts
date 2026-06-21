import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { NotificationService } from '../notification/notification.service';
import { NotificationType } from '@prisma/client';

@Injectable()
export class MentionService {
  constructor(
    private prisma: PrismaService,
    private notificationService: NotificationService,
  ) {}

  async scanAndCreateMentions(
    actorId: string,
    workspaceId: string,
    text: string,
    entityType: 'TASK_COMMENT' | 'CHAT_MESSAGE' | 'DOCUMENT' | 'MEETING_NOTE',
    entityId: string,
  ) {
    const regex = /@([a-zA-Z0-9_\-\.]+)/g;
    const matches = [...text.matchAll(regex)];
    const usernames = matches.map((m) => m[1]);

    if (usernames.length === 0) return [];

    const actor = await this.prisma.user.findUnique({ where: { id: actorId } });
    const actorName = actor ? actor.fullName : 'Someone';

    const mentionsCreated = [];

    for (const username of usernames) {
      // Find user by matching email prefix or fullName substring
      const user = await this.prisma.user.findFirst({
        where: {
          OR: [
            { email: { startsWith: username } },
            { fullName: { contains: username, mode: 'insensitive' } },
          ],
        },
      });

      if (user && user.id !== actorId) {
        // Confirm user workspace membership
        const member = await this.prisma.workspaceMember.findUnique({
          where: { workspaceId_userId: { workspaceId, userId: user.id } },
        });

        if (member && member.status === 'ACTIVE') {
          // Create database Mention log
          const mention = await this.prisma.mention.create({
            data: {
              userId: user.id,
              entityType,
              entityId,
            },
          });

          // Dispatch mention notification
          await this.notificationService.createNotification(
            user.id,
            NotificationType.MENTION,
            'You were mentioned',
            `${actorName} mentioned you in a ${entityType.toLowerCase().replace('_', ' ')}`,
            entityType,
            entityId,
          );

          // Add to activity stream
          await this.prisma.activityLog.create({
            data: {
              workspaceId,
              userId: actorId,
              entityType: 'MENTION',
              entityId: mention.id,
              action: 'CREATED',
              metadata: { targetUserId: user.id, entityType, entityId },
            },
          });

          mentionsCreated.push(mention);
        }
      }
    }

    return mentionsCreated;
  }
}
