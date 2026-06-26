import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class ContractTestingService {
  constructor(private readonly prisma: PrismaService) {}

  async createSuite(workspaceId: string, contractId: string, name: string) {
    return this.prisma.contractTestSuite.create({
      data: {
        workspaceId,
        contractId,
        name,
      },
    });
  }

  async addAssertion(workspaceId: string, suiteId: string, assertion: string) {
    return this.prisma.contractAssertion.create({
      data: {
        workspaceId,
        suiteId,
        assertion,
        isActive: true,
      },
    });
  }

  async logReport(workspaceId: string, suiteId: string, status: string) {
    return this.prisma.contractReport.create({
      data: {
        workspaceId,
        suiteId,
        status,
      },
    });
  }

  async getReports(workspaceId: string, suiteId: string) {
    return this.prisma.contractReport.findMany({
      where: {
        workspaceId,
        suiteId,
      },
      orderBy: {
        runAt: 'desc',
      },
    });
  }
}
