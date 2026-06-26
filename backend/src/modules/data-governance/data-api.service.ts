import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class DataApiService {
  constructor(private readonly prisma: PrismaService) {}

  async registerApi(workspaceId: string, name: string, path: string, method: string) {
    return this.prisma.dataApi.create({
      data: {
        workspaceId,
        name,
        path,
        method,
        status: 'ACTIVE',
      },
    });
  }

  async addApiVersion(workspaceId: string, apiId: string, version: string, schemaJson: string) {
    return this.prisma.dataApiVersion.create({
      data: {
        workspaceId,
        apiId,
        version,
        schemaJson,
      },
    });
  }

  async authorizeConsumer(workspaceId: string, apiId: string, consumerName: string, token: string) {
    return this.prisma.apiConsumer.create({
      data: {
        workspaceId,
        apiId,
        consumerName,
        token,
      },
    });
  }

  async logCallMetric(workspaceId: string, apiId: string, consumerId: string, responseTime: number, statusCode: number) {
    return this.prisma.apiUsageMetric.create({
      data: {
        workspaceId,
        apiId,
        consumerId,
        responseTime,
        statusCode,
      },
    });
  }
}
