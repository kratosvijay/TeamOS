import { Injectable, UnauthorizedException } from '@nestjs/common';
import { OAuthService } from '../oauth/oauth.service';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class GoogleService {
  constructor(
    private readonly oauthService: OAuthService,
    private readonly prisma: PrismaService,
  ) {}

  async connectGoogle(workspaceId: string, code: string) {
    return this.oauthService.connectProvider(workspaceId, 'GOOGLE', code);
  }

  async syncCalendarEvents(workspaceId: string) {
    const credentials = await this.oauthService.getCredentials(workspaceId, 'GOOGLE');
    if (!credentials.accessToken) {
      throw new UnauthorizedException('Missing Google Workspace OAuth credentials');
    }

    // Mock fetching calendar list
    const mockEvents = [
      { id: 'g-cal-1', summary: 'Daily Standup Sync', startTime: new Date().toISOString(), endTime: new Date(Date.now() + 30 * 60 * 1000).toISOString() },
      { id: 'g-cal-2', summary: 'Phase 13 Integration Review', startTime: new Date(Date.now() + 3600 * 1000).toISOString(), endTime: new Date(Date.now() + 2 * 3600 * 1000).toISOString() },
    ];

    // Sync into local Meeting / CalendarEvent tables
    for (const event of mockEvents) {
      await this.prisma.meeting.upsert({
        where: { roomName: event.id },
        update: {
          title: event.summary,
          startedAt: new Date(event.startTime),
          endedAt: new Date(event.endTime),
        },
        create: {
          workspaceId,
          title: event.summary,
          roomName: event.id,
          hostId: 'system-bot',
          startedAt: new Date(event.startTime),
          endedAt: new Date(event.endTime),
          status: 'COMPLETED',
        },
      });
    }

    return { success: true, syncedEventsCount: mockEvents.length };
  }

  async importGoogleDoc(workspaceId: string, userId: string, docId: string, title: string) {
    const credentials = await this.oauthService.getCredentials(workspaceId, 'GOOGLE');
    if (!credentials.accessToken) {
      throw new UnauthorizedException('Missing Google Workspace OAuth credentials');
    }

    // Mock Doc contents
    const plainText = `# Google Document: ${title}\n\nImported successfully from Google Drive.\nThis is a collaborative document workspace.`;

    const document = await this.prisma.document.create({
      data: {
        workspaceId,
        title,
        slug: title.toLowerCase().replace(/ /g, '-'),
        createdBy: userId,
        updatedBy: userId,
        isWiki: true,
      },
    });

    await this.prisma.documentContent.create({
      data: {
        documentId: document.id,
        plainText,
      },
    });

    return document;
  }
}
