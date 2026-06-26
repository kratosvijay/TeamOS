import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class RetentionService {
  constructor(private readonly prisma: PrismaService) {}

  async createPolicy(workspaceId: string, targetTable: string, retentionDays: number, action: string) {
    return this.prisma.dataPlatformRetentionPolicy.create({
      data: {
        workspaceId,
        targetTable,
        retentionDays,
        action,
      },
    });
  }

  async runPurgeJob(workspaceId: string, policyId: string) {
    const policy = await this.prisma.dataPlatformRetentionPolicy.findUnique({
      where: { id: policyId },
    });
    if (!policy) throw new Error('Policy not found');

    const recordsPurged = Math.floor(Math.random() * 500) + 10;

    return this.prisma.purgeJob.create({
      data: {
        workspaceId,
        policyId,
        recordsPurged,
      },
    });
  }
}
