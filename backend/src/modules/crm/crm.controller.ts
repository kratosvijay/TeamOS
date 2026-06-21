import { Controller, Get, Post, Body, Headers, BadRequestException } from '@nestjs/common';
import { CRMService } from './crm.service';

@Controller('crm')
export class CRMController {
  constructor(private crmService: CRMService) {}

  @Get('leads')
  async getLeads(@Headers('x-workspace-id') workspaceId: string) {
    if (!workspaceId) {
      throw new BadRequestException('Workspace ID is required');
    }
    return this.crmService.getLeads(workspaceId);
  }

  @Post('leads')
  async createLead(
    @Headers('x-workspace-id') workspaceId: string,
    @Body() body: { name: string; company: string; email: string; value: number },
  ) {
    if (!workspaceId) {
      throw new BadRequestException('Workspace ID is required');
    }
    if (!body.name || !body.company || !body.email || body.value === undefined) {
      throw new BadRequestException('name, company, email, and value are required');
    }
    return this.crmService.createLead(workspaceId, body.name, body.company, body.email, body.value);
  }

  @Get('opportunities')
  async getOpportunities(@Headers('x-workspace-id') workspaceId: string) {
    if (!workspaceId) {
      throw new BadRequestException('Workspace ID is required');
    }
    return this.crmService.getOpportunities(workspaceId);
  }

  @Post('opportunities')
  async createOpportunity(
    @Headers('x-workspace-id') workspaceId: string,
    @Body() body: { leadId?: string; name: string; stage: string; value: number; probability: number },
  ) {
    if (!workspaceId) {
      throw new BadRequestException('Workspace ID is required');
    }
    if (!body.name || !body.stage || body.value === undefined || body.probability === undefined) {
      throw new BadRequestException('name, stage, value, and probability are required');
    }
    return this.crmService.createOpportunity(
      workspaceId,
      body.leadId || null,
      body.name,
      body.stage,
      body.value,
      body.probability,
    );
  }

  @Get('accounts')
  async getAccounts(@Headers('x-workspace-id') workspaceId: string) {
    if (!workspaceId) {
      throw new BadRequestException('Workspace ID is required');
    }
    return this.crmService.getAccounts(workspaceId);
  }

  @Get('contacts')
  async getContacts(@Headers('x-workspace-id') workspaceId: string) {
    if (!workspaceId) {
      throw new BadRequestException('Workspace ID is required');
    }
    return this.crmService.getContacts(workspaceId);
  }

  @Post('score-lead')
  async scoreLead(@Body('leadId') leadId: string) {
    if (!leadId) {
      throw new BadRequestException('Lead ID is required');
    }
    return this.crmService.scoreCRMLead(leadId);
  }

  @Post('forecast-opportunity')
  async forecastOpportunity(@Body('oppId') oppId: string) {
    if (!oppId) {
      throw new BadRequestException('Opportunity ID (oppId) is required');
    }
    return this.crmService.forecastCRMOpportunity(oppId);
  }
}
