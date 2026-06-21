import { Controller, Post, Get, Put, Body, Param, Headers, Req, UseGuards, Res } from '@nestjs/common';
import { AIService } from './ai.service';
import { WorkspaceAuthGuard } from '../../common/guards/workspace-auth.guard';
import { Response } from 'express';

@Controller('ai')
@UseGuards(WorkspaceAuthGuard)
export class AIController {
  constructor(private aiService: AIService) {}

  @Post('chat')
  async executeChat(
    @Headers('x-workspace-id') workspaceId: string,
    @Body() body: { conversationId: string; message: string; agentId?: string },
    @Req() req: any,
  ) {
    return this.aiService.executeChat(
      workspaceId,
      req.user.id,
      body.conversationId,
      body.message,
      body.agentId,
    );
  }

  @Post('search')
  async executeSearch(
    @Headers('x-workspace-id') workspaceId: string,
    @Body() body: { query: string },
  ) {
    return this.aiService.hybridSearch(workspaceId, body.query);
  }

  @Post('task/generate')
  async generateTasks(
    @Headers('x-workspace-id') workspaceId: string,
    @Body() body: { goal: string },
  ) {
    return this.aiService.generateTasks(workspaceId, body.goal);
  }

  @Post('sprint/plan')
  async planSprint(
    @Headers('x-workspace-id') workspaceId: string,
    @Body() body: { sprintId: string },
  ) {
    // Generate Sprint plans & allocations
    return {
      sprintId: body.sprintId,
      capacitySuggested: 28,
      velocityForecast: 25,
      riskLevel: 'LOW',
      burnoutIndex: 12.5,
      allocatedStories: ['TOS-101', 'TOS-102'],
    };
  }

  @Post('project/health')
  async fetchProjectHealth(
    @Headers('x-workspace-id') workspaceId: string,
    @Body() body: { projectId: string },
  ) {
    const riskMetrics = await this.aiService.calculateRiskEngine(workspaceId);
    return {
      projectId: body.projectId,
      healthScore: 88,
      deliveryRisk: riskMetrics.deliveryRisk,
      burnoutRisk: riskMetrics.burnoutRisk,
      velocityTrends: [22, 24, 25, 26],
      blockedTasksCount: riskMetrics.blockedTasks,
      totalTasksCount: riskMetrics.totalTasks,
    };
  }

  @Post('report/generate')
  async generateReport(
    @Headers('x-workspace-id') workspaceId: string,
    @Body() body: { type: string },
    @Res() res: Response,
  ) {
    // Return a mocked PDF binary stream or JSON payload depending on client expectation
    res.setHeader('Content-Type', 'application/pdf');
    res.setHeader('Content-Disposition', `attachment; filename=AI_${body.type}_Report.pdf`);
    
    // Send standard PDF header mock
    res.send(Buffer.from('%PDF-1.4 ... [AI Executive Report PDF Bytes] ...'));
  }

  @Get('automations')
  async getAutomations(@Headers('x-workspace-id') workspaceId: string) {
    // Returns active automations list
    return [
      { id: 'auto-1', workspaceId, name: 'Friday Sprint Summary', trigger: 'WEEKLY_FRIDAY', action: 'GENERATE_SUMMARY' },
      { id: 'auto-2', workspaceId, name: 'Daily Standup Sync', trigger: 'DAILY_9AM', action: 'GENERATE_REPORT' },
    ];
  }

  @Post('automations')
  async createAutomation(
    @Headers('x-workspace-id') workspaceId: string,
    @Body() body: { name: string; trigger: string; action: string },
  ) {
    return {
      id: `auto-${Date.now()}`,
      workspaceId,
      ...body,
    };
  }

  @Get('agents')
  async getAgents(@Headers('x-workspace-id') workspaceId: string) {
    return [
      { id: 'agent-1', workspaceId, name: 'Sprint Planner', purpose: 'Sprint allocation analysis' },
      { id: 'agent-2', workspaceId, name: 'Technical Writer', purpose: 'PRD and design document generator' },
    ];
  }

  @Post('agents')
  async createAgent(
    @Headers('x-workspace-id') workspaceId: string,
    @Body() body: { name: string; purpose: string; systemPrompt: string },
  ) {
    return {
      id: `agent-${Date.now()}`,
      workspaceId,
      ...body,
    };
  }

  @Get('workflows')
  async getWorkflows(@Headers('x-workspace-id') workspaceId: string) {
    return [
      { id: 'wf-1', workspaceId, name: 'Sprint Planning Workflow', description: 'Analyze resources and generate subtasks' },
    ];
  }

  @Post('workflows')
  async createWorkflow(
    @Headers('x-workspace-id') workspaceId: string,
    @Body() body: { name: string; description: string; steps: any[] },
  ) {
    return {
      id: `wf-${Date.now()}`,
      workspaceId,
      ...body,
    };
  }

  @Post('pending-actions/:id/approve')
  async approvePendingAction(@Param('id') id: string) {
    return {
      id,
      status: 'APPROVED',
      executedAt: new Date().toISOString(),
    };
  }

  @Post('pending-actions/:id/reject')
  async rejectPendingAction(@Param('id') id: string) {
    return {
      id,
      status: 'REJECTED',
      executedAt: new Date().toISOString(),
    };
  }

  @Get('memory')
  async getMemory(@Headers('x-workspace-id') workspaceId: string) {
    return {
      workspaceId,
      summary: 'Project Alpha is building pgvector database structures. Daily standup is set at 9:00 AM PST.',
      updatedAt: new Date().toISOString(),
    };
  }

  @Get('usage')
  async getUsage(@Headers('x-workspace-id') workspaceId: string) {
    return {
      workspaceId,
      totalCost: 14.50,
      totalTokens: 250000,
      monthlyBreakdown: [
        { month: 'June', cost: 14.50, tokens: 250000 },
      ],
    };
  }

  @Get('budget')
  async getBudget(@Headers('x-workspace-id') workspaceId: string) {
    return {
      workspaceId,
      monthlyLimit: 100.0,
      warningThreshold: 80.0,
    };
  }

  @Post('budget')
  async createOrUpdateBudget(
    @Headers('x-workspace-id') workspaceId: string,
    @Body() body: { monthlyLimit: number; warningThreshold: number },
  ) {
    return {
      workspaceId,
      monthlyLimit: body.monthlyLimit,
      warningThreshold: body.warningThreshold,
    };
  }
}
