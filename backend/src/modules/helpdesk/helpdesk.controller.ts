import { Controller, Get, Post, Put, Body, Param, Headers, BadRequestException } from '@nestjs/common';
import { HelpdeskService } from './helpdesk.service';

@Controller('helpdesk')
export class HelpdeskController {
  constructor(private helpdeskService: HelpdeskService) {}

  @Get('tickets')
  async getTickets(@Headers('x-workspace-id') workspaceId: string) {
    if (!workspaceId) {
      throw new BadRequestException('Workspace ID is required');
    }
    return this.helpdeskService.getTickets(workspaceId);
  }

  @Post('tickets')
  async createTicket(
    @Headers('x-workspace-id') workspaceId: string,
    @Body() body: { title: string; description: string; priority: string },
  ) {
    if (!workspaceId) {
      throw new BadRequestException('Workspace ID is required');
    }
    if (!body.title || !body.description || !body.priority) {
      throw new BadRequestException('title, description, and priority are required');
    }
    return this.helpdeskService.createTicket(workspaceId, body.title, body.description, body.priority);
  }

  @Put('tickets/:id')
  async updateTicket(
    @Param('id') id: string,
    @Body() body: { status: string; assignedTo?: string },
  ) {
    if (!body.status) {
      throw new BadRequestException('status is required');
    }
    return this.helpdeskService.updateTicket(id, body.status, body.assignedTo);
  }

  @Post('tickets/:id/comments')
  async addComment(
    @Param('id') id: string,
    @Body() body: { authorId: string; comment: string },
  ) {
    if (!body.authorId || !body.comment) {
      throw new BadRequestException('authorId and comment are required');
    }
    return this.helpdeskService.addComment(id, body.authorId, body.comment);
  }

  @Get('sla')
  async getSLARecords(@Headers('x-workspace-id') workspaceId: string) {
    if (!workspaceId) {
      throw new BadRequestException('Workspace ID is required');
    }
    return this.helpdeskService.getSLARecords(workspaceId);
  }
}
