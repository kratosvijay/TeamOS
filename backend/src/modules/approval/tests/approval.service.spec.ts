import { Test, TestingModule } from '@nestjs/testing';
import { ApprovalService } from '../approval.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('ApprovalService', () => {
  let service: ApprovalService;
  let prisma: PrismaService;

  const mockPrismaService = {
    approvalRequest: {
      create: jest.fn(),
      findMany: jest.fn(),
      findUnique: jest.fn(),
      update: jest.fn(),
    },
    workflowExecution: {
      findUnique: jest.fn(),
      update: jest.fn(),
    },
    workflowExecutionLog: {
      create: jest.fn(),
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ApprovalService,
        { provide: PrismaService, useValue: mockPrismaService },
      ],
    }).compile();

    service = module.get<ApprovalService>(ApprovalService);
    prisma = module.get<PrismaService>(PrismaService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should create approval request in PENDING state', async () => {
    mockPrismaService.approvalRequest.create.mockResolvedValue({ id: 'app-1', status: 'PENDING' });

    const result = await service.createApprovalRequest({ workflowId: 'ex-1', requestedBy: 'user-1', approverId: 'approver-1' });
    expect(result.status).toBe('PENDING');
  });

  it('should mark request as APPROVED and log execution completion', async () => {
    mockPrismaService.approvalRequest.findUnique.mockResolvedValue({ id: 'app-1', workflowId: 'ex-1' });
    mockPrismaService.approvalRequest.update.mockResolvedValue({ id: 'app-1', status: 'APPROVED' });
    mockPrismaService.workflowExecution.findUnique.mockResolvedValue({ id: 'ex-1' });

    const result = await service.approveRequest('app-1', 'Looks good');
    expect(result.status).toBe('APPROVED');
    expect(mockPrismaService.workflowExecutionLog.create).toHaveBeenCalledWith({
      data: expect.objectContaining({
        nodeId: 'APPROVAL_STEP',
        status: 'COMPLETED',
      }),
    });
  });

  it('should mark request as REJECTED and set execution status to FAILED', async () => {
    mockPrismaService.approvalRequest.findUnique.mockResolvedValue({ id: 'app-1', workflowId: 'ex-1' });
    mockPrismaService.approvalRequest.update.mockResolvedValue({ id: 'app-1', status: 'REJECTED' });
    mockPrismaService.workflowExecution.findUnique.mockResolvedValue({ id: 'ex-1' });

    const result = await service.rejectRequest('app-1', 'Not approved');
    expect(result.status).toBe('REJECTED');
    expect(mockPrismaService.workflowExecution.update).toHaveBeenCalledWith({
      where: { id: 'ex-1' },
      data: expect.objectContaining({
        status: 'FAILED',
      }),
    });
  });
});
