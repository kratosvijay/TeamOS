import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class MetadataDiscoveryService {
  constructor(private readonly prisma: PrismaService) {}

  async createScanner(workspaceId: string, scannerName: string, connectionId: string) {
    return this.prisma.schemaScanner.create({
      data: {
        workspaceId,
        scannerName,
        connectionId,
        isActive: true,
      },
    });
  }

  async runDiscoveryScan(workspaceId: string, scannerId: string) {
    const scanner = await this.prisma.schemaScanner.findUnique({
      where: { id: scannerId },
    });
    if (!scanner) throw new Error('Scanner not found');

    const driftAlerts = [];
    const driftDetected = Math.random() > 0.5;

    if (driftDetected) {
      const alert = await this.prisma.driftAlert.create({
        data: {
          workspaceId,
          scannerId,
          tableName: 'ExternalUsers',
          driftType: 'COLUMN_ADDED',
        },
      });
      driftAlerts.push(alert);
    }

    return {
      scannerId,
      scanStatus: 'COMPLETED',
      driftAlerts,
    };
  }
}
