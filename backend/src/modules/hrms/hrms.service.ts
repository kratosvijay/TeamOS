import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { AIService } from '../ai/ai.service';
import { CreateEmployeeDto } from './dto/create-employee.dto';
import { CreateLeaveDto } from './dto/create-leave.dto';
import { CreatePayrollDto } from './dto/create-payroll.dto';

@Injectable()
export class HRMSService {
  constructor(
    private prisma: PrismaService,
    private aiService: AIService,
  ) {}

  async createEmployee(workspaceId: string, dto: CreateEmployeeDto) {
    return this.prisma.employee.create({
      data: {
        workspaceId,
        fullName: dto.fullName,
        email: dto.email,
        role: dto.role,
        department: dto.department,
        salary: dto.salary || 0.0,
      },
    });
  }

  async getEmployees(workspaceId: string) {
    return this.prisma.employee.findMany({
      where: { workspaceId },
      orderBy: { fullName: 'asc' },
    });
  }

  async getEmployeeById(id: string) {
    const employee = await this.prisma.employee.findUnique({
      where: { id },
    });
    if (!employee) {
      throw new NotFoundException(`Employee with ID ${id} not found`);
    }
    return employee;
  }

  async checkIn(employeeId: string) {
    const employee = await this.getEmployeeById(employeeId);
    return this.prisma.attendance.create({
      data: {
        employeeId: employee.id,
        checkIn: new Date(),
      },
    });
  }

  async checkOut(employeeId: string) {
    const attendance = await this.prisma.attendance.findFirst({
      where: { employeeId, checkOut: null },
      orderBy: { checkIn: 'desc' },
    });
    if (!attendance) {
      throw new NotFoundException(`No active check-in found for employee ${employeeId}`);
    }
    return this.prisma.attendance.update({
      where: { id: attendance.id },
      data: { checkOut: new Date() },
    });
  }

  async createLeaveRequest(dto: CreateLeaveDto) {
    await this.getEmployeeById(dto.employeeId);
    return this.prisma.leaveRequest.create({
      data: {
        employeeId: dto.employeeId,
        startDate: new Date(dto.startDate),
        endDate: new Date(dto.endDate),
        reason: dto.reason || '',
        status: 'PENDING',
      },
    });
  }

  async approveLeaveRequest(leaveId: string) {
    const leave = await this.prisma.leaveRequest.findUnique({
      where: { id: leaveId },
    });
    if (!leave) {
      throw new NotFoundException(`Leave request with ID ${leaveId} not found`);
    }
    return this.prisma.leaveRequest.update({
      where: { id: leaveId },
      data: { status: 'APPROVED' },
    });
  }

  async getPayrollHistory(workspaceId: string) {
    return this.prisma.payrollRun.findMany({
      where: { workspaceId },
      orderBy: { periodStart: 'desc' },
    });
  }

  async runPayroll(workspaceId: string, dto: CreatePayrollDto) {
    const employees = await this.getEmployees(workspaceId);
    const totalAmount = employees.reduce((sum, emp) => sum + emp.salary, 0);

    return this.prisma.payrollRun.create({
      data: {
        workspaceId,
        periodStart: new Date(dto.periodStart),
        periodEnd: new Date(dto.periodEnd),
        totalAmount,
        status: 'COMPLETED',
      },
    });
  }

  async screenCandidateResume(workspaceId: string, fullName: string, email: string, resumeText: string) {
    const screening = await this.aiService.screenResume(resumeText);
    return this.prisma.recruitmentCandidate.create({
      data: {
        workspaceId,
        fullName,
        email,
        status: screening.score >= 80 ? 'SHORTLISTED' : 'REJECTED',
        resumeText,
        aiScore: screening.score,
      },
    });
  }
}
