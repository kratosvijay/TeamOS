import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class DataContractsService {
  constructor(private readonly prisma: PrismaService) {}

  async createContract(workspaceId: string, name: string) {
    return this.prisma.dataContract.create({
      data: {
        workspaceId,
        name,
        status: 'DRAFT',
      },
    });
  }

  async addVersion(contractId: string, workspaceId: string, version: string, schemaJson: string) {
    return this.prisma.dataContractVersion.create({
      data: {
        contractId,
        workspaceId,
        version,
        schemaJson,
        isActive: true,
      },
    });
  }

  async validatePayload(workspaceId: string, contractId: string, payload: any) {
    const activeVersion = await this.prisma.dataContractVersion.findFirst({
      where: { contractId, workspaceId, isActive: true },
    });
    if (!activeVersion) {
      throw new Error('No active version found for this contract');
    }

    let isValid = true;
    let errorsJson = '';

    // Mock validation logic
    try {
      const schema = JSON.parse(activeVersion.schemaJson);
      for (const key of Object.keys(schema)) {
        if (schema[key].required && payload[key] === undefined) {
          isValid = false;
          errorsJson = `Field ${key} is required but missing`;
          break;
        }
      }
    } catch (e) {
      isValid = false;
      errorsJson = 'Invalid contract schema format';
    }

    const validation = await this.prisma.contractValidation.create({
      data: {
        workspaceId,
        contractId,
        versionId: activeVersion.id,
        payloadId: payload.id || 'N/A',
        isValid,
        errorsJson: isValid ? null : errorsJson,
      },
    });

    return validation;
  }
}
