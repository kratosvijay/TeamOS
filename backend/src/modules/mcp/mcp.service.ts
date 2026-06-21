import { Injectable, ForbiddenException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

export interface Citation {
  type: 'DOCUMENT' | 'MEETING' | 'TASK' | 'PROJECT' | 'CHAT';
  id: string;
  title: string;
  key?: string;
  url?: string;
}

export interface CompressedContext {
  contextText: string;
  citations: Citation[];
}

@Injectable()
export class MCPService {
  constructor(private prisma: PrismaService) {}

  /**
   * Retrieves, filters, isolates, and compresses contextual data from TeamOS resources.
   */
  async retrieveContext(
    workspaceId: string,
    userId: string,
    query: string,
    collectionIds?: string[],
  ): Promise<CompressedContext> {
    const citations: Citation[] = [];
    const contextBlocks: string[] = [];

    // 1. Verify User Workspace Membership
    const membership = await this.prisma.workspaceMember.findUnique({
      where: {
        workspaceId_userId: { workspaceId, userId },
      },
    });
    if (!membership || membership.status !== 'ACTIVE') {
      throw new ForbiddenException('User is not an active member of this workspace');
    }

    // 2. Fetch Documents (Knowledge Base & Wiki)
    const docQuery: any = {
      workspaceId,
      isPublished: true,
    };
    if (collectionIds && collectionIds.length > 0) {
      docQuery.collectionId = { in: collectionIds };
    }

    const docs = await this.prisma.document.findMany({
      where: docQuery,
      take: 5,
      include: {
        contents: {
          orderBy: { createdAt: 'desc' },
          take: 1,
        },
      },
    });

    for (const doc of docs) {
      // Check document permission
      const hasPermission = await this.checkDocumentPermission(doc.id, userId, membership.role);
      if (hasPermission) {
        const text = doc.contents[0]?.plainText || '';
        if (text) {
          const compressed = this.compressText(text, 150);
          contextBlocks.push(`[Document: ${doc.title} (ID: ${doc.id})]\n${compressed}`);
          citations.push({ type: 'DOCUMENT', id: doc.id, title: doc.title });
        }
      }
    }

    // 3. Fetch Tasks
    const tasks = await this.prisma.task.findMany({
      where: {
        project: { workspaceId },
      },
      take: 5,
    });

    for (const task of tasks) {
      const desc = task.description || '';
      contextBlocks.push(
        `[Task: ${task.key} - ${task.title} (Status: ${task.status}, Priority: ${task.priority})]\n${this.compressText(desc, 100)}`,
      );
      citations.push({ type: 'TASK', id: task.id, title: task.title, key: task.key });
    }

    // 4. Fetch Meetings and Transcripts
    const meetings = await this.prisma.meeting.findMany({
      where: { workspaceId },
      take: 3,
      include: {
        transcripts: {
          take: 1,
        },
        summaries: {
          take: 1,
        },
      },
    });

    for (const m of meetings) {
      const summaryText = m.summaries[0]?.summary || m.transcripts[0]?.content || '';
      if (summaryText) {
        contextBlocks.push(`[Meeting: ${m.title} (ID: ${m.id})]\n${this.compressText(summaryText, 150)}`);
        citations.push({ type: 'MEETING', id: m.id, title: m.title });
      }
    }

    // Combine and return
    return {
      contextText: contextBlocks.join('\n\n'),
      citations,
    };
  }

  /**
   * Helper to check role-based permissions on specific documents
   */
  async checkDocumentPermission(docId: string, userId: string, userRole: any): Promise<boolean> {
    const permissions = await this.prisma.documentPermission.findMany({
      where: { documentId: docId },
    });

    if (permissions.length === 0) {
      return true; // Workspace-wide by default
    }

    // Check specific user permission
    const userPerm = permissions.find((p) => p.userId === userId);
    if (userPerm) {
      return userPerm.canView;
    }

    // Check role-based override permission
    const rolePerm = permissions.find((p) => p.role === userRole);
    if (rolePerm) {
      return rolePerm.canView;
    }

    // If there is any restricted permission and user is not matched, default to false
    return false;
  }

  /**
   * Compresses text blocks by cutting off at word limits to optimize context window space
   */
  private compressText(text: string, maxWords: number): string {
    const words = text.split(/\s+/);
    if (words.length <= maxWords) return text;
    return words.slice(0, maxWords).join(' ') + '... [Context Compressed]';
  }
}
