import {
  WebSocketGateway,
  WebSocketServer,
  SubscribeMessage,
  MessageBody,
  ConnectedSocket,
} from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import { PrismaService } from '../prisma/prisma.service';
import { Injectable, UseGuards } from '@nestjs/common';
import { TaskStatus } from '@prisma/client';

@WebSocketGateway({
  cors: { origin: '*' },
})
@Injectable()
export class KanbanGateway {
  @WebSocketServer()
  server: Server;

  constructor(private prisma: PrismaService) {}

  @SubscribeMessage('kanban:card_moved')
  async handleCardMoved(
    @ConnectedSocket() client: Socket,
    @MessageBody()
    data: {
      projectId: string;
      taskId: string;
      targetStatus: TaskStatus;
      prevTaskPosition?: number;
      nextTaskPosition?: number;
    },
  ) {
    // 1. Resolve fractional position midpoint
    let newPosition = 100.0;
    const prevPos = data.prevTaskPosition;
    const nextPos = data.nextTaskPosition;

    if (prevPos !== undefined && nextPos !== undefined) {
      newPosition = (prevPos + nextPos) / 2;
    } else if (prevPos !== undefined) {
      newPosition = prevPos + 100.0;
    } else if (nextPos !== undefined) {
      newPosition = nextPos - 100.0;
    }

    try {
      // 2. Validate WIP Column limits
      const columnSetting = await this.prisma.kanbanColumnSetting.findUnique({
        where: {
          projectId_status: {
            projectId: data.projectId,
            status: data.targetStatus,
          },
        },
      });

      if (columnSetting && columnSetting.wipLimit > 0) {
        const currentCount = await this.prisma.task.count({
          where: { projectId: data.projectId, status: data.targetStatus },
        });

        if (currentCount >= columnSetting.wipLimit) {
          // Emit WIP Warning event to project room
          this.server.to(`project:${data.projectId}`).emit('kanban:wip_warning', {
            projectId: data.projectId,
            status: data.targetStatus,
            wipLimit: columnSetting.wipLimit,
            message: `WIP Limit of ${columnSetting.wipLimit} exceeded on column ${data.targetStatus}`,
          });
        }
      }

      // 3. Update task
      const updated = await this.prisma.task.update({
        where: { id: data.taskId },
        data: {
          status: data.targetStatus,
          position: newPosition,
        },
      });

      // 4. Broadcast synced card movements
      this.server.to(`project:${data.projectId}`).emit('kanban:card_status_synced', {
        taskId: updated.id,
        status: updated.status,
        position: updated.position,
      });

      return { status: 'ok', position: newPosition };
    } catch (e) {
      client.emit('error', { message: `Move failed: ${e.message}` });
    }
  }
}
