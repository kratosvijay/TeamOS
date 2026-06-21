import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { AIService } from '../ai/ai.service';

@Injectable()
export class CRMService {
  constructor(
    private prisma: PrismaService,
    private aiService: AIService,
  ) {}

  async createLead(workspaceId: string, name: string, company: string, email: string, value: number) {
    return this.prisma.cRMLead.create({
      data: {
        workspaceId,
        name,
        company,
        email,
        value,
        status: 'NEW',
      },
    });
  }

  async getLeads(workspaceId: string) {
    return this.prisma.cRMLead.findMany({
      where: { workspaceId },
      orderBy: { createdAt: 'desc' },
    });
  }

  async createOpportunity(
    workspaceId: string,
    leadId: string | null,
    name: string,
    stage: string,
    value: number,
    probability: number,
  ) {
    return this.prisma.cRMOpportunity.create({
      data: {
        workspaceId,
        leadId,
        name,
        stage,
        value,
        probability,
      },
    });
  }

  async getOpportunities(workspaceId: string) {
    return this.prisma.cRMOpportunity.findMany({
      where: { workspaceId },
      orderBy: { value: 'desc' },
    });
  }

  async createAccount(workspaceId: string, name: string, industry?: string, website?: string) {
    return this.prisma.cRMAccount.create({
      data: {
        workspaceId,
        name,
        industry: industry || null,
        website: website || null,
      },
    });
  }

  async getAccounts(workspaceId: string) {
    return this.prisma.cRMAccount.findMany({
      where: { workspaceId },
      orderBy: { name: 'asc' },
    });
  }

  async createContact(workspaceId: string, accountId: string | null, fullName: string, email: string, phone?: string) {
    return this.prisma.cRMContact.create({
      data: {
        workspaceId,
        accountId,
        fullName,
        email,
        phone: phone || null,
      },
    });
  }

  async getContacts(workspaceId: string) {
    return this.prisma.cRMContact.findMany({
      where: { workspaceId },
      orderBy: { fullName: 'asc' },
    });
  }

  async scoreCRMLead(leadId: string) {
    const lead = await this.prisma.cRMLead.findUnique({
      where: { id: leadId },
    });
    if (!lead) {
      throw new NotFoundException(`Lead with ID ${leadId} not found`);
    }

    const aiResult = await this.aiService.scoreLead({
      email: lead.email,
      company: lead.company,
      value: lead.value,
    });

    return this.prisma.cRMLead.update({
      where: { id: leadId },
      data: {
        aiScore: aiResult.score,
        status: aiResult.score >= 80 ? 'QUALIFIED' : lead.status,
      },
    });
  }

  async forecastCRMOpportunity(oppId: string) {
    const opportunity = await this.prisma.cRMOpportunity.findUnique({
      where: { id: oppId },
    });
    if (!opportunity) {
      throw new NotFoundException(`Opportunity with ID ${oppId} not found`);
    }

    const forecast = await this.aiService.forecastOpportunity({
      stage: opportunity.stage,
      value: opportunity.value,
    });

    return this.prisma.cRMOpportunity.update({
      where: { id: oppId },
      data: {
        probability: forecast.winProbability * 100,
      },
    });
  }
}
