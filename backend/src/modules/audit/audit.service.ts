import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import * as crypto from 'crypto';

@Injectable()
export class AuditService {
  constructor(private prisma: PrismaService) {}

  async logAction(
    workspaceId: string,
    actorId: string,
    action: string,
    entityType: string,
    entityId: string,
    oldValue: any = null,
    newValue: any = null,
    ipAddress?: string,
  ) {
    // Retrieve the latest audit log in the workspace to get the previous hash
    const lastAudit = await this.prisma.auditTrail.findFirst({
      where: { workspaceId },
      orderBy: { createdAt: 'desc' },
    });

    const previousHash = lastAudit?.currentHash || '0000000000000000000000000000000000000000000000000000000000000000';
    const recordId = crypto.randomUUID();

    // Compute cryptographic hash chain
    const payloadString = `${recordId}-${workspaceId}-${actorId}-${action}-${entityType}-${entityId}-${previousHash}`;
    const currentHash = crypto.createHash('sha256').update(payloadString).digest('hex');

    return this.prisma.auditTrail.create({
      data: {
        id: recordId,
        workspaceId,
        actorId,
        action,
        entityType,
        entityId,
        oldValue: oldValue ? JSON.parse(JSON.stringify(oldValue)) : null,
        newValue: newValue ? JSON.parse(JSON.stringify(newValue)) : null,
        ipAddress,
        previousHash,
        currentHash,
      },
    });
  }

  async getAuditLogs(workspaceId: string, limit = 100, offset = 0) {
    return this.prisma.auditTrail.findMany({
      where: { workspaceId },
      include: {
        actor: {
          select: {
            id: true,
            fullName: true,
            email: true,
            avatarUrl: true,
          },
        },
      },
      orderBy: { createdAt: 'desc' },
      take: limit,
      skip: offset,
    });
  }
}
