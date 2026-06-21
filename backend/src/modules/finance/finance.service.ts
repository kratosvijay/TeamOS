import { Injectable, BadRequestException, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { AIService } from '../ai/ai.service';

@Injectable()
export class FinanceService {
  constructor(
    private prisma: PrismaService,
    private aiService: AIService,
  ) {}

  async createInvoice(workspaceId: string, amount: number, customerName: string, dueDate: Date) {
    if (amount <= 0) {
      throw new BadRequestException('Invoice amount must be greater than zero');
    }
    return this.prisma.invoice.create({
      data: {
        workspaceId,
        amount,
        customerName,
        dueDate,
        status: 'UNPAID',
      },
    });
  }

  async getInvoices(workspaceId: string) {
    return this.prisma.invoice.findMany({
      where: { workspaceId },
      orderBy: { dueDate: 'asc' },
    });
  }

  async createExpense(workspaceId: string, amount: number, rawCategory: string, employeeId: string) {
    if (amount <= 0) {
      throw new BadRequestException('Expense amount must be greater than zero');
    }

    // AI Classification
    const aiResult = await this.aiService.classifyExpense(rawCategory);
    const category = aiResult.category;

    // Budget Limit check
    const budget = await this.prisma.budget.findFirst({
      where: { workspaceId, category },
    });

    if (budget && budget.spent + amount > budget.amount) {
      // Trigger policy breach or budget warning
      console.warn(`Budget breach warning for category ${category}`);
    }

    // Expense policy: expenses above 5000 require CFO manual authorization
    const status = amount > 5000.0 ? 'FLAGGED' : 'PENDING';

    const expense = await this.prisma.expense.create({
      data: {
        workspaceId,
        amount,
        category,
        employeeId,
        status,
      },
    });

    // Update budget spent if budget exists
    if (budget) {
      await this.prisma.budget.update({
        where: { id: budget.id },
        data: { spent: budget.spent + amount },
      });
    }

    return expense;
  }

  async getExpenses(workspaceId: string) {
    return this.prisma.expense.findMany({
      where: { workspaceId },
      orderBy: { createdAt: 'desc' },
    });
  }

  async createBudget(workspaceId: string, category: string, amount: number) {
    if (amount <= 0) {
      throw new BadRequestException('Budget limit must be greater than zero');
    }
    return this.prisma.budget.create({
      data: {
        workspaceId,
        category,
        amount,
        spent: 0.0,
      },
    });
  }

  async getBudgets(workspaceId: string) {
    return this.prisma.budget.findMany({
      where: { workspaceId },
      orderBy: { category: 'asc' },
    });
  }
}
