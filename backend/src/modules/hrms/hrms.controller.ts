import { Controller, Get, Post, Put, Body, Param, Headers, BadRequestException } from '@nestjs/common';
import { HRMSService } from './hrms.service';
import { CreateEmployeeDto } from './dto/create-employee.dto';
import { CreateLeaveDto } from './dto/create-leave.dto';
import { CreatePayrollDto } from './dto/create-payroll.dto';

@Controller('hrms')
export class HRMSController {
  constructor(private hrmsService: HRMSService) {}

  @Get('employees')
  async getEmployees(@Headers('x-workspace-id') workspaceId: string) {
    if (!workspaceId) {
      throw new BadRequestException('Workspace ID is required');
    }
    return this.hrmsService.getEmployees(workspaceId);
  }

  @Post('employees')
  async createEmployee(
    @Headers('x-workspace-id') workspaceId: string,
    @Body() dto: CreateEmployeeDto,
  ) {
    if (!workspaceId) {
      throw new BadRequestException('Workspace ID is required');
    }
    return this.hrmsService.createEmployee(workspaceId, dto);
  }

  @Get('employees/:id')
  async getEmployeeById(@Param('id') id: string) {
    return this.hrmsService.getEmployeeById(id);
  }

  @Post('attendance/checkin')
  async checkIn(@Body('employeeId') employeeId: string) {
    if (!employeeId) {
      throw new BadRequestException('Employee ID is required');
    }
    return this.hrmsService.checkIn(employeeId);
  }

  @Post('attendance/checkout')
  async checkOut(@Body('employeeId') employeeId: string) {
    if (!employeeId) {
      throw new BadRequestException('Employee ID is required');
    }
    return this.hrmsService.checkOut(employeeId);
  }

  @Post('leaves')
  async createLeave(@Body() dto: CreateLeaveDto) {
    return this.hrmsService.createLeaveRequest(dto);
  }

  @Put('leaves/:id/approve')
  async approveLeave(@Param('id') id: string) {
    return this.hrmsService.approveLeaveRequest(id);
  }

  @Get('payroll')
  async getPayrollHistory(@Headers('x-workspace-id') workspaceId: string) {
    if (!workspaceId) {
      throw new BadRequestException('Workspace ID is required');
    }
    return this.hrmsService.getPayrollHistory(workspaceId);
  }

  @Post('payroll/run')
  async runPayroll(
    @Headers('x-workspace-id') workspaceId: string,
    @Body() dto: CreatePayrollDto,
  ) {
    if (!workspaceId) {
      throw new BadRequestException('Workspace ID is required');
    }
    return this.hrmsService.runPayroll(workspaceId, dto);
  }

  @Post('recruitment/screen')
  async screenCandidate(
    @Headers('x-workspace-id') workspaceId: string,
    @Body() body: { fullName: string; email: string; resumeText: string },
  ) {
    if (!workspaceId) {
      throw new BadRequestException('Workspace ID is required');
    }
    if (!body.fullName || !body.email || !body.resumeText) {
      throw new BadRequestException('fullName, email, and resumeText are required');
    }
    return this.hrmsService.screenCandidateResume(workspaceId, body.fullName, body.email, body.resumeText);
  }
}
