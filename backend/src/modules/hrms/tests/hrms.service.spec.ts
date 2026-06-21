import { Test, TestingModule } from '@nestjs/testing';
import { HRMSService } from '../hrms.service';
import { PrismaService } from '../../prisma/prisma.service';
import { AIService } from '../../ai/ai.service';
import { CreateEmployeeDto } from '../dto/create-employee.dto';
import { CreateLeaveDto } from '../dto/create-leave.dto';
import { CreatePayrollDto } from '../dto/create-payroll.dto';

describe('HRMSService', () => {
  let service: HRMSService;
  let prisma: PrismaService;
  let ai: AIService;

  const mockPrismaService = {
    employee: {
      create: jest.fn(),
      findMany: jest.fn(),
      findUnique: jest.fn(),
    },
    attendance: {
      create: jest.fn(),
      findFirst: jest.fn(),
      update: jest.fn(),
    },
    leaveRequest: {
      create: jest.fn(),
      findUnique: jest.fn(),
      update: jest.fn(),
    },
    payrollRun: {
      create: jest.fn(),
      findMany: jest.fn(),
    },
    recruitmentCandidate: {
      create: jest.fn(),
    },
  };

  const mockAIService = {
    screenResume: jest.fn().mockResolvedValue({ score: 85, matchDetails: 'Great' }),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        HRMSService,
        { provide: PrismaService, useValue: mockPrismaService },
        { provide: AIService, useValue: mockAIService },
      ],
    }).compile();

    service = module.get<HRMSService>(HRMSService);
    prisma = module.get<PrismaService>(PrismaService);
    ai = module.get<AIService>(AIService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should create an employee', async () => {
    const dto: CreateEmployeeDto = { fullName: 'John Doe', email: 'john@teamos.com', role: 'Engineer', department: 'IT', salary: 5000 };
    mockPrismaService.employee.create.mockResolvedValue({ id: 'emp-1', ...dto });

    const result = await service.createEmployee('ws-1', dto);
    expect(result.fullName).toBe('John Doe');
    expect(mockPrismaService.employee.create).toHaveBeenCalled();
  });

  it('should clock-in employee', async () => {
    mockPrismaService.employee.findUnique.mockResolvedValue({ id: 'emp-1' });
    mockPrismaService.attendance.create.mockResolvedValue({ id: 'att-1', employeeId: 'emp-1' });

    const result = await service.checkIn('emp-1');
    expect(result.employeeId).toBe('emp-1');
  });

  it('should clock-out employee', async () => {
    mockPrismaService.attendance.findFirst.mockResolvedValue({ id: 'att-1', employeeId: 'emp-1', checkOut: null });
    mockPrismaService.attendance.update.mockResolvedValue({ id: 'att-1', employeeId: 'emp-1', checkOut: new Date() });

    const result = await service.checkOut('emp-1');
    expect(result.id).toBe('att-1');
  });

  it('should submit leave request', async () => {
    mockPrismaService.employee.findUnique.mockResolvedValue({ id: 'emp-1' });
    const dto: CreateLeaveDto = { employeeId: 'emp-1', startDate: '2026-06-22', endDate: '2026-06-25', reason: 'Vacation' };
    mockPrismaService.leaveRequest.create.mockResolvedValue({ id: 'l-1', status: 'PENDING' });

    const result = await service.createLeaveRequest(dto);
    expect(result.status).toBe('PENDING');
  });

  it('should approve leave request', async () => {
    mockPrismaService.leaveRequest.findUnique.mockResolvedValue({ id: 'l-1', status: 'PENDING' });
    mockPrismaService.leaveRequest.update.mockResolvedValue({ id: 'l-1', status: 'APPROVED' });

    const result = await service.approveLeaveRequest('l-1');
    expect(result.status).toBe('APPROVED');
  });

  it('should run payroll', async () => {
    mockPrismaService.employee.findMany.mockResolvedValue([{ id: 'emp-1', salary: 5000 }]);
    const dto: CreatePayrollDto = { periodStart: '2026-06-01', periodEnd: '2026-06-30' };
    mockPrismaService.payrollRun.create.mockResolvedValue({ id: 'p-1', totalAmount: 5000, status: 'COMPLETED' });

    const result = await service.runPayroll('ws-1', dto);
    expect(result.totalAmount).toBe(5000);
  });

  it('should screen candidate resume with AI scoring', async () => {
    mockPrismaService.recruitmentCandidate.create.mockResolvedValue({ id: 'c-1', aiScore: 85, status: 'SHORTLISTED' });

    const result = await service.screenCandidateResume('ws-1', 'Alice', 'alice@teamos.com', 'Resume text...');
    expect(result.aiScore).toBe(85);
    expect(result.status).toBe('SHORTLISTED');
  });
});
