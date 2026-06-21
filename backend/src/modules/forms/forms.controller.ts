import { Controller, Post, Get, Body, Param, Headers } from '@nestjs/common';
import { FormsService } from './forms.service';

@Controller('forms')
export class FormsController {
  constructor(private readonly formsService: FormsService) {}

  @Post()
  async createForm(
    @Headers('x-workspace-id') workspaceId: string,
    @Headers('x-user-id') userId: string,
    @Body() body: { name: string; schema: any },
  ) {
    const creator = userId || 'user-1';
    return this.formsService.createForm(workspaceId || 'ws-1', creator, body);
  }

  @Get()
  async getForms(@Headers('x-workspace-id') workspaceId: string) {
    return this.formsService.getForms(workspaceId || 'ws-1');
  }

  @Get(':id')
  async getFormById(@Param('id') id: string) {
    return this.formsService.getFormById(id);
  }

  @Post(':id/submit')
  async submitForm(
    @Param('id') id: string,
    @Headers('x-user-id') userId: string,
    @Body() payload: any,
  ) {
    const submitter = userId || 'user-1';
    return this.formsService.submitForm(id, submitter, payload);
  }

  @Get(':id/submissions')
  async getSubmissions(@Param('id') id: string) {
    return this.formsService.getSubmissions(id);
  }
}
