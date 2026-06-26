import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class SharingAgreementService {
  constructor(private readonly prisma: PrismaService) {}

  async createAgreement(workspaceId: string, partyA: string, partyB: string, datasetId: string) {
    return this.prisma.sharingAgreement.create({
      data: {
        workspaceId,
        partyA,
        partyB,
        datasetId,
        isActive: true,
      },
    });
  }

  async defineSharingPolicy(workspaceId: string, agreementId: string, policyJson: string) {
    return this.prisma.sharingPolicy.create({
      data: {
        workspaceId,
        agreementId,
        policyJson,
      },
    });
  }

  async applyLicense(workspaceId: string, datasetId: string, licenseType: string, terms: string) {
    return this.prisma.dataLicense.create({
      data: {
        workspaceId,
        datasetId,
        licenseType,
        terms,
      },
    });
  }
}
