import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { SearchService } from '../search/search.service';
import * as Y from 'yjs';

export interface Mutation {
  action: 'CREATE' | 'UPDATE' | 'DELETE' | 'APPEND';
  entity: 'Task' | 'Document' | 'Setting' | 'Comment';
  entityId: string;
  data: any;
  clientUpdatedAt: string;
}

export interface SyncBatch {
  batchId: string;
  deviceId: string;
  sequenceNumber: number;
  mutations: Mutation[];
  createdAt: string;
}

@Injectable()
export class OfflineService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly searchService: SearchService,
  ) {}

  async getSyncStatus(deviceId: string) {
    const latestJournal = await this.prisma.syncJournal.findFirst({
      where: { deviceId },
      orderBy: { startedAt: 'desc' },
    });

    const session = await this.prisma.deviceSession.findFirst({
      where: { deviceId },
      orderBy: { lastSeenAt: 'desc' },
    });

    return {
      deviceId,
      lastSyncTime: latestJournal?.completedAt || null,
      lastBatchId: latestJournal?.batchId || null,
      status: latestJournal?.status || 'UNKNOWN',
      appVersion: session?.appVersion || null,
      platform: session?.platform || null,
    };
  }

  async processSyncBatch(userId: string, batch: SyncBatch) {
    const { batchId, deviceId, sequenceNumber, mutations } = batch;

    // Idempotency check: If batch already completed, skip
    const existingJournal = await this.prisma.syncJournal.findUnique({
      where: { batchId },
    });

    if (existingJournal && existingJournal.status === 'COMPLETED') {
      return {
        success: true,
        batchId,
        message: 'Batch already processed successfully.',
      };
    }

    // Register or update device session
    await this.prisma.deviceSession.upsert({
      where: { id: deviceId },
      update: {
        userId,
        lastSeenAt: new Date(),
      },
      create: {
        id: deviceId,
        userId,
        deviceId,
        platform: 'desktop', // default, can be parsed from context or batch payload
        appVersion: '1.0.0',
        lastSeenAt: new Date(),
      },
    });

    // Create or update SyncJournal to PROCESSING
    const journal = await this.prisma.syncJournal.upsert({
      where: { batchId },
      update: {
        status: 'PROCESSING',
        startedAt: new Date(),
      },
      create: {
        deviceId,
        batchId,
        status: 'PROCESSING',
        startedAt: new Date(),
      },
    });

    try {
      // Process mutations sequentially
      for (const mutation of mutations) {
        await this.applyMutation(userId, mutation);
      }

      // Mark journal as COMPLETED
      await this.prisma.syncJournal.update({
        where: { batchId },
        data: {
          status: 'COMPLETED',
          completedAt: new Date(),
        },
      });

      return {
        success: true,
        batchId,
        message: `Successfully processed ${mutations.length} mutations.`,
      };
    } catch (error) {
      console.error(`Offline sync batch [${batchId}] failed:`, error);

      // Mark journal as FAILED
      await this.prisma.syncJournal.update({
        where: { batchId },
        data: {
          status: 'FAILED',
          error: error.message || String(error),
          completedAt: new Date(),
        },
      });

      throw error;
    }
  }

  private async applyMutation(userId: string, mutation: Mutation) {
    const { action, entity, entityId, data, clientUpdatedAt } = mutation;

    switch (entity) {
      case 'Task':
        await this.handleTaskMutation(userId, action, entityId, data, clientUpdatedAt);
        break;
      case 'Document':
        await this.handleDocumentMutation(userId, action, entityId, data, clientUpdatedAt);
        break;
      case 'Setting':
        await this.handleSettingMutation(userId, action, entityId, data, clientUpdatedAt);
        break;
      case 'Comment':
        await this.handleCommentMutation(userId, action, entityId, data, clientUpdatedAt);
        break;
      default:
        throw new Error(`Unsupported entity type: ${entity}`);
    }
  }

  private async handleTaskMutation(
    userId: string,
    action: string,
    entityId: string,
    data: any,
    clientUpdatedAt: string,
  ) {
    if (action === 'CREATE') {
      const task = await this.prisma.task.create({
        data: {
          id: entityId,
          ...data,
        },
      });
      // Index task in OpenSearch
      await this.searchService.indexEntity('tasks', task.id, {
        title: task.title,
        description: task.description,
        status: task.status,
      });
    } else if (action === 'UPDATE') {
      const existing = await this.prisma.task.findUnique({
        where: { id: entityId },
      });

      if (!existing) {
        // If not found on server, create it as a fallback
        const task = await this.prisma.task.create({
          data: {
            id: entityId,
            ...data,
          },
        });
        await this.searchService.indexEntity('tasks', task.id, {
          title: task.title,
          description: task.description,
          status: task.status,
        });
        return;
      }

      // Field-level merge: If server update is newer, we only merge fields that weren't updated on server,
      // or we apply client updates. For a clean field-level merge, we only update the keys that the client explicitly modified.
      // We extract all keys from the client mutation payload and update them.
      const serverUpdatedAt = new Date(existing.updatedAt).getTime();
      const clientUpdateMillis = new Date(clientUpdatedAt).getTime();

      const updateData: any = {};
      for (const key of Object.keys(data)) {
        // If server is newer, check if value matches what we sent. If it's different, let the server's field win.
        // Otherwise, client wins.
        if (serverUpdatedAt > clientUpdateMillis) {
          if (existing[key] !== data[key]) {
            // Server has modified this field since client's version, skip client change (Server wins)
            continue;
          }
        }
        updateData[key] = data[key];
      }

      if (Object.keys(updateData).length > 0) {
        const task = await this.prisma.task.update({
          where: { id: entityId },
          data: updateData,
        });
        await this.searchService.indexEntity('tasks', task.id, {
          title: task.title,
          description: task.description,
          status: task.status,
        });
      }
    } else if (action === 'DELETE') {
      await this.prisma.task.delete({
        where: { id: entityId },
      });
      await this.searchService.deleteEntity('tasks', entityId);
    }
  }

  private async handleDocumentMutation(
    userId: string,
    action: string,
    entityId: string,
    data: any,
    clientUpdatedAt: string,
  ) {
    if (action === 'CREATE') {
      const { title, slug, workspaceId, parentId, plainText, yjsSnapshot } = data;
      const document = await this.prisma.document.create({
        data: {
          id: entityId,
          title,
          slug: slug || title.toLowerCase().replace(/ /g, '-'),
          workspaceId,
          parentId,
          createdBy: userId,
          updatedBy: userId,
        },
      });

      let snapshotBuffer: Buffer | null = null;
      if (yjsSnapshot) {
        snapshotBuffer = Buffer.from(yjsSnapshot, 'base64');
      }

      await this.prisma.documentContent.create({
        data: {
          documentId: entityId,
          plainText: plainText || '',
          yjsSnapshot: snapshotBuffer,
        },
      });

      // Index in OpenSearch
      await this.searchService.indexEntity('documents', document.id, {
        title: document.title,
        content: plainText || '',
      });
    } else if (action === 'UPDATE') {
      const existing = await this.prisma.document.findUnique({
        where: { id: entityId },
      });

      if (!existing) {
        return; // document missing on server
      }

      const { title, slug, plainText, yjsSnapshot } = data;

      // Update metadata if provided
      if (title || slug) {
        await this.prisma.document.update({
          where: { id: entityId },
          data: {
            title: title || undefined,
            slug: slug || undefined,
            updatedBy: userId,
          },
        });
      }

      // CRDT merge for Yjs snapshots
      const existingContent = await this.prisma.documentContent.findFirst({
        where: { documentId: entityId },
        orderBy: { version: 'desc' },
      });

      if (existingContent) {
        let mergedText = plainText || existingContent.plainText;
        let mergedSnapshot: Buffer | null = null;

        if (yjsSnapshot) {
          const clientSnapshotBuffer = Buffer.from(yjsSnapshot, 'base64');
          if (existingContent.yjsSnapshot) {
            // Perform actual Yjs binary CRDT merge
            const serverDoc = new Y.Doc();
            Y.applyUpdate(serverDoc, new Uint8Array(existingContent.yjsSnapshot));

            const clientDoc = new Y.Doc();
            Y.applyUpdate(clientDoc, new Uint8Array(clientSnapshotBuffer));

            // Merge updates
            const serverUpdate = Y.encodeStateAsUpdate(serverDoc);
            Y.applyUpdate(clientDoc, serverUpdate);

            mergedSnapshot = Buffer.from(Y.encodeStateAsUpdate(clientDoc));
            mergedText = clientDoc.getText('content').toString() || clientDoc.getText('codemirror').toString() || mergedText;
          } else {
            mergedSnapshot = clientSnapshotBuffer;
          }
        }

        await this.prisma.documentContent.update({
          where: { id: existingContent.id },
          data: {
            plainText: mergedText,
            yjsSnapshot: mergedSnapshot,
            version: existingContent.version + 1,
          },
        });

        // Index updated text
        await this.searchService.indexEntity('documents', entityId, {
          title: title || existing.title,
          content: mergedText,
        });
      }
    }
  }

  private async handleSettingMutation(
    userId: string,
    action: string,
    entityId: string,
    data: any,
    clientUpdatedAt: string,
  ) {
    // Settings use Last-Write-Wins (LWW) based on timestamps
    // We fetch the workspace settings using entityId (which is workspaceId)
    const existing = await this.prisma.workspaceSettings.findUnique({
      where: { workspaceId: entityId },
    });

    if (!existing) {
      if (action === 'CREATE' || action === 'UPDATE') {
        await this.prisma.workspaceSettings.create({
          data: {
            workspaceId: entityId,
            ...data,
          },
        });
      }
      return;
    }

    const serverUpdatedAt = new Date(existing.updatedAt).getTime();
    const clientUpdateMillis = new Date(clientUpdatedAt).getTime();

    // LWW rule: client wins only if it is newer
    if (clientUpdateMillis > serverUpdatedAt) {
      await this.prisma.workspaceSettings.update({
        where: { workspaceId: entityId },
        data,
      });
    }
  }

  private async handleCommentMutation(
    userId: string,
    action: string,
    entityId: string,
    data: any,
    clientUpdatedAt: string,
  ) {
    // Comments are Append-Only
    if (action === 'CREATE' || action === 'APPEND') {
      const { taskId, content } = data;
      await this.prisma.taskComment.create({
        data: {
          id: entityId,
          taskId,
          userId,
          content,
          createdAt: new Date(clientUpdatedAt),
        },
      });
    }
  }
}
