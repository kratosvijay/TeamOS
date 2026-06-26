import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class LakehouseService {
  constructor(private readonly prisma: PrismaService) {}

  async registerLakehouseDataset(workspaceId: string, name: string, format: string) {
    return this.prisma.lakehouseDataset.create({
      data: {
        workspaceId,
        name,
        format, // PARQUET, ICEBERG, DELTA
      },
    });
  }

  async recordParquetSnapshot(workspaceId: string, datasetId: string, filePath: string) {
    return this.prisma.parquetSnapshot.create({
      data: {
        workspaceId,
        datasetId,
        filePath,
      },
    });
  }

  async catalogIcebergTable(workspaceId: string, tableName: string, metadataPath: string) {
    return this.prisma.icebergTable.create({
      data: {
        workspaceId,
        tableName,
        metadataPath,
      },
    });
  }
}
