import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class DataMeshService {
  constructor(private readonly prisma: PrismaService) {}

  async assignDomainOwner(workspaceId: string, domainName: string, userId: string) {
    return this.prisma.dataDomainOwner.create({
      data: {
        workspaceId,
        domainName,
        userId,
      },
    });
  }

  async createDomainPolicy(workspaceId: string, domainName: string, policyRule: string) {
    return this.prisma.domainPolicy.create({
      data: {
        workspaceId,
        domainName,
        policyRule,
      },
    });
  }

  async bindDomainContract(workspaceId: string, domainName: string, contractId: string) {
    return this.prisma.domainContract.create({
      data: {
        workspaceId,
        domainName,
        contractId,
      },
    });
  }
}
