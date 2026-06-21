import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

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
    return this.prisma.auditTrail.create({
      data: {
        workspaceId,
        actorId,
        action,
        entityType,
        entityId,
        oldValue: oldValue ? JSON.parse(JSON.stringify(oldValue)) : null,
        newValue: newValue ? JSON.parse(JSON.stringify(newValue)) : null,
        ipAddress,
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
