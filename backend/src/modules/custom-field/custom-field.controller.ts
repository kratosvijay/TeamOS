import { Controller, Post, Get, Param, Body, UseGuards, Headers } from '@nestjs/common';
import { CustomFieldService } from './custom-field.service';
import { WorkspaceAuthGuard } from '../../common/guards/workspace-auth.guard';
import { CustomFieldType } from '@prisma/client';

@Controller('custom-fields')
@UseGuards(WorkspaceAuthGuard)
export class CustomFieldController {
  constructor(private customFieldService: CustomFieldService) {}

  @Post()
  async createField(
    @Headers('x-workspace-id') workspaceId: string,
    @Body() body: { name: string; type: CustomFieldType; required?: boolean; defaultValue?: string },
  ) {
    return this.customFieldService.createField(workspaceId, body.name, body.type, body.required, body.defaultValue);
  }

  @Get()
  async getFields(@Headers('x-workspace-id') workspaceId: string) {
    return this.customFieldService.getFields(workspaceId);
  }

  @Post('task/:taskId/value')
  async setValue(
    @Param('taskId') taskId: string,
    @Body() body: { customFieldId: string; value: string },
  ) {
    return this.customFieldService.setFieldValue(taskId, body.customFieldId, body.value);
  }
}
