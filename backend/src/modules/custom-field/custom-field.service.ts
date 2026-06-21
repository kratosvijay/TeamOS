import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CustomFieldType } from '@prisma/client';
import { EventService } from '../event/event.service';

@Injectable()
export class CustomFieldService {
  constructor(
    private prisma: PrismaService,
    private eventService: EventService,
  ) {}

  async createField(workspaceId: string, name: string, type: CustomFieldType, required = false, defaultValue?: string) {
    return this.prisma.customField.create({
      data: { workspaceId, name, type, required, defaultValue },
    });
  }

  async getFields(workspaceId: string) {
    return this.prisma.customField.findMany({ where: { workspaceId } });
  }

  async setFieldValue(taskId: string, customFieldId: string, value: string) {
    const valRecord = await this.prisma.taskCustomFieldValue.upsert({
      where: { taskId_customFieldId: { taskId, customFieldId } },
      update: { value },
      create: { taskId, customFieldId, value },
      include: { task: true },
    });

    // Reindex the task so its search index stays up-to-date with custom field values
    try {
      await this.eventService.dispatch('search-indexing', 'task:index', {
        entityType: 'task',
        entityId: taskId,
        payload: {
          title: valRecord.task.title,
          description: valRecord.task.description,
          status: valRecord.task.status,
          priority: valRecord.task.priority,
          key: valRecord.task.key,
        },
      });
    } catch (e) {
      console.error('Failed to dispatch search indexing on custom field change', e);
    }

    return valRecord;
  }
}
