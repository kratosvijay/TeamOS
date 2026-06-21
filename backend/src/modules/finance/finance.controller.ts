import { Controller, Get, Post, Body, Headers, BadRequestException } from '@nestjs/common';
import { FinanceService } from './finance.service';

@Controller('finance')
export class FinanceController {
  constructor(private financeService: FinanceService) {}

  @Get('invoices')
  async getInvoices(@Headers('x-workspace-id') workspaceId: string) {
    if (!workspaceId) {
      throw new BadRequestException('Workspace ID is required');
    }
    return this.financeService.getInvoices(workspaceId);
  }

  @Post('invoices')
  async createInvoice(
    @Headers('x-workspace-id') workspaceId: string,
    @Body() body: { amount: number; customerName: string; dueDate: string },
  ) {
    if (!workspaceId) {
      throw new BadRequestException('Workspace ID is required');
    }
    if (body.amount === undefined || !body.customerName || !body.dueDate) {
      throw new BadRequestException('amount, customerName, and dueDate are required');
    }
    return this.financeService.createInvoice(workspaceId, body.amount, body.customerName, new Date(body.dueDate));
  }

  @Post('expenses')
  async createExpense(
    @Headers('x-workspace-id') workspaceId: string,
    @Body() body: { amount: number; category: string; employeeId: string },
  ) {
    if (!workspaceId) {
      throw new BadRequestException('Workspace ID is required');
    }
    if (body.amount === undefined || !body.category || !body.employeeId) {
      throw new BadRequestException('amount, category, and employeeId are required');
    }
    return this.financeService.createExpense(workspaceId, body.amount, body.category, body.employeeId);
  }

  @Get('expenses')
  async getExpenses(@Headers('x-workspace-id') workspaceId: string) {
    if (!workspaceId) {
      throw new BadRequestException('Workspace ID is required');
    }
    return this.financeService.getExpenses(workspaceId);
  }

  @Get('budgets')
  async getBudgets(@Headers('x-workspace-id') workspaceId: string) {
    if (!workspaceId) {
      throw new BadRequestException('Workspace ID is required');
    }
    return this.financeService.getBudgets(workspaceId);
  }

  @Post('budgets')
  async createBudget(
    @Headers('x-workspace-id') workspaceId: string,
    @Body() body: { category: string; amount: number },
  ) {
    if (!workspaceId) {
      throw new BadRequestException('Workspace ID is required');
    }
    if (!body.category || body.amount === undefined) {
      throw new BadRequestException('category and amount are required');
    }
    return this.financeService.createBudget(workspaceId, body.category, body.amount);
  }
}
