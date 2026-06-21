import { Injectable, OnModuleInit } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class TaskSchedulerService implements OnModuleInit {
  constructor(private prisma: PrismaService) {}

  onModuleInit() {
    // Run checks hourly to auto-generate tasks based on recurrence rules
    setInterval(() => this.processRecurringTasks(), 3600 * 1000);
  }

  async processRecurringTasks() {
    console.log('[Recurring Task Scheduler] Checking for tasks to duplicate...');
    const tasks = await this.prisma.task.findMany({
      where: {
        recurrenceRule: { not: null },
      },
    });

    for (const task of tasks) {
      // In production: parses RFC-5545 recurrence rules (daily, weekly, etc.)
      // and spawns a new Task copy if current date matching schedule requirements is met.
      console.log(`[Task Scheduler] Processing rule [${task.recurrenceRule}] for task: ${task.key}`);
    }
  }
}
