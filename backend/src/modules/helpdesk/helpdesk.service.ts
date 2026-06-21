import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { AIService } from '../ai/ai.service';

@Injectable()
export class HelpdeskService {
  constructor(
    private prisma: PrismaService,
    private aiService: AIService,
  ) {}

  async createTicket(workspaceId: string, title: string, description: string, priority: string) {
    const aiResult = await this.aiService.summarizeHelpdeskTicket(description);

    const ticket = await this.prisma.helpdeskTicket.create({
      data: {
        workspaceId,
        title,
        description,
        priority: aiResult.priorityProposal || priority || 'MEDIUM',
        status: 'OPEN',
      },
    });

    let targetHours = 24;
    if (ticket.priority === 'CRITICAL') targetHours = 2;
    else if (ticket.priority === 'HIGH') targetHours = 8;

    await this.prisma.ticketSLA.create({
      data: {
        ticketId: ticket.id,
        targetHours,
        breached: false,
      },
    });

    return ticket;
  }

  async getTickets(workspaceId: string) {
    return this.prisma.helpdeskTicket.findMany({
      where: { workspaceId },
      orderBy: { createdAt: 'desc' },
    });
  }

  async updateTicket(ticketId: string, status: string, assignedTo?: string) {
    const ticket = await this.prisma.helpdeskTicket.findUnique({
      where: { id: ticketId },
    });
    if (!ticket) {
      throw new NotFoundException(`Ticket with ID ${ticketId} not found`);
    }

    return this.prisma.helpdeskTicket.update({
      where: { id: ticketId },
      data: {
        status,
        assignedTo: assignedTo !== undefined ? assignedTo : ticket.assignedTo,
      },
    });
  }

  async addComment(ticketId: string, authorId: string, comment: string) {
    const ticket = await this.prisma.helpdeskTicket.findUnique({
      where: { id: ticketId },
    });
    if (!ticket) {
      throw new NotFoundException(`Ticket with ID ${ticketId} not found`);
    }

    return this.prisma.ticketComment.create({
      data: {
        ticketId,
        authorId,
        comment,
      },
    });
  }

  async getSLARecords(workspaceId: string) {
    const tickets = await this.getTickets(workspaceId);
    const ticketIds = tickets.map((t) => t.id);

    return this.prisma.ticketSLA.findMany({
      where: { ticketId: { in: ticketIds } },
    });
  }

  async checkSLAStatus(ticketId: string) {
    const ticket = await this.prisma.helpdeskTicket.findUnique({
      where: { id: ticketId },
    });
    if (!ticket) {
      throw new NotFoundException(`Ticket with ID ${ticketId} not found`);
    }

    const sla = await this.prisma.ticketSLA.findFirst({
      where: { ticketId },
    });

    if (sla) {
      const elapsedHours = (Date.now() - ticket.createdAt.getTime()) / 3600000;
      if (elapsedHours > sla.targetHours && !sla.breached) {
        await this.prisma.ticketSLA.update({
          where: { id: sla.id },
          data: { breached: true },
        });
      }
    }
  }
}
