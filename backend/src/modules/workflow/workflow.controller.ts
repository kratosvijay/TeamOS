import { Controller, Post, Get, Put, Delete, Body, Param, Headers, HttpCode, HttpStatus } from '@nestjs/common';
import { WorkflowService } from './workflow.service';

@Controller('workflow')
export class WorkflowController {
  constructor(private readonly workflowService: WorkflowService) {}

  @Post()
  async createWorkflow(
    @Headers('x-workspace-id') workspaceId: string,
    @Headers('x-user-id') userId: string,
    @Body() body: { name: string; description?: string; definition: any },
  ) {
    const creator = userId || 'user-1';
    return this.workflowService.createWorkflow(workspaceId || 'ws-1', creator, body);
  }

  @Get()
  async getWorkflows(@Headers('x-workspace-id') workspaceId: string) {
    return this.workflowService.getWorkflows(workspaceId || 'ws-1');
  }

  @Get(':id')
  async getWorkflowById(@Param('id') id: string) {
    return this.workflowService.getWorkflowById(id);
  }

  @Put(':id')
  async updateWorkflow(
    @Param('id') id: string,
    @Body() body: { name?: string; description?: string; definition?: any },
  ) {
    return this.workflowService.updateWorkflow(id, body);
  }

  @Delete(':id')
  async deleteWorkflow(@Param('id') id: string) {
    return this.workflowService.deleteWorkflow(id);
  }

  @Post(':id/publish')
  @HttpCode(HttpStatus.OK)
  async publishWorkflow(@Param('id') id: string) {
    return this.workflowService.publishWorkflow(id);
  }

  @Post(':id/pause')
  @HttpCode(HttpStatus.OK)
  async pauseWorkflow(@Param('id') id: string) {
    return this.workflowService.pauseWorkflow(id);
  }

  @Post(':id/run')
  @HttpCode(HttpStatus.OK)
  async runWorkflow(
    @Param('id') id: string,
    @Body() body: { inputPayload?: any },
  ) {
    return this.workflowService.runWorkflow(id, body?.inputPayload);
  }

  @Get(':id/executions')
  async getWorkflowExecutions(@Param('id') id: string) {
    return this.workflowService.getWorkflowExecutions(id);
  }
}
