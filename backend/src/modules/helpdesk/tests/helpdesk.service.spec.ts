import { Test, TestingModule } from '@nestjs/testing';
import { HelpdeskService } from '../helpdesk.service';
import { PrismaService } from '../../prisma/prisma.service';
import { AIService } from '../../ai/ai.service';

describe('HelpdeskService', () => {
  let service: HelpdeskService;
  let prisma: PrismaService;
  let ai: AIService;

  const mockPrismaService = {
    helpdeskTicket: {
      create: jest.fn(),
      findMany: jest.fn(),
      findUnique: jest.fn(),
      update: jest.fn(),
    },
    ticketComment: {
      create: jest.fn(),
    },
    ticketSLA: {
      create: jest.fn(),
      findFirst: jest.fn(),
      update: jest.fn(),
    },
  };

  const mockAIService = {
    summarizeHelpdeskTicket: jest.fn().mockResolvedValue({ priorityProposal: 'HIGH' }),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        HelpdeskService,
        { provide: PrismaService, useValue: mockPrismaService },
        { provide: AIService, useValue: mockAIService },
      ],
    }).compile();

    service = module.get<HelpdeskService>(HelpdeskService);
    prisma = module.get<PrismaService>(PrismaService);
    ai = module.get<AIService>(AIService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should create ticket and establish SLA targetHours based on AI priority', async () => {
    mockPrismaService.helpdeskTicket.create.mockResolvedValue({ id: 't-1', priority: 'HIGH' });
    mockPrismaService.ticketSLA.create.mockResolvedValue({ id: 'sla-1', targetHours: 8 });

    const result = await service.createTicket('ws-1', 'Server down', 'Cannot access reporting dashboard', 'MEDIUM');
    expect(result.priority).toBe('HIGH');
    expect(mockPrismaService.ticketSLA.create).toHaveBeenCalledWith({
      data: {
        ticketId: 't-1',
        targetHours: 8,
        breached: false,
      },
    });
  });

  it('should add ticket comment', async () => {
    mockPrismaService.helpdeskTicket.findUnique.mockResolvedValue({ id: 't-1' });
    mockPrismaService.ticketComment.create.mockResolvedValue({ id: 'tc-1', comment: 'Checking now' });

    const result = await service.addComment('t-1', 'user-1', 'Checking now');
    expect(result.comment).toBe('Checking now');
  });

  it('should trigger SLA breach flag on ticket check status after elapsed targetHours', async () => {
    // Ticket created 10 hours ago
    const tenHoursAgo = new Date();
    tenHoursAgo.setHours(tenHoursAgo.getHours() - 10);

    mockPrismaService.helpdeskTicket.findUnique.mockResolvedValue({ id: 't-1', createdAt: tenHoursAgo });
    mockPrismaService.ticketSLA.findFirst.mockResolvedValue({ id: 'sla-1', ticketId: 't-1', targetHours: 8, breached: false });
    mockPrismaService.ticketSLA.update.mockResolvedValue({ id: 'sla-1', breached: true });

    await service.checkSLAStatus('t-1');
    expect(mockPrismaService.ticketSLA.update).toHaveBeenCalledWith({
      where: { id: 'sla-1' },
      data: { breached: true },
    });
  });
});
