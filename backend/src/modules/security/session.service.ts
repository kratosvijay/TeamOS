import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class SessionService {
  constructor(private prisma: PrismaService) {}

  async createSession(
    userId: string,
    deviceInfo: { browser: string; os: string; isNewDevice?: boolean; isVPN?: boolean; impossibleTravel?: boolean },
    ipAddress: string,
    failedLoginCount = 0,
  ) {
    let riskScore = 0;
    if (deviceInfo.isNewDevice) riskScore += 20;
    if (deviceInfo.isVPN) riskScore += 40;
    if (deviceInfo.impossibleTravel) riskScore += 60;
    if (failedLoginCount >= 3) riskScore += 30;

    // Cap risk score at 100
    riskScore = Math.min(riskScore, 100);

    return this.prisma.userSession.create({
      data: {
        userId,
        deviceInfo: JSON.parse(JSON.stringify(deviceInfo)),
        ipAddress,
        riskScore,
        createdAt: new Date(),
        expiresAt: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000), // 30 days default
      },
    });
  }

  async getSessions(userId: string) {
    return this.prisma.userSession.findMany({
      where: { userId },
      orderBy: { createdAt: 'desc' },
    });
  }

  async getActiveSessionsCount(workspaceId: string): Promise<number> {
    // Get all user sessions in workspace members
    const members = await this.prisma.workspaceMember.findMany({
      where: { workspaceId },
      select: { userId: true },
    });
    const userIds = members.map((m) => m.userId);

    return this.prisma.userSession.count({
      where: {
        userId: { in: userIds },
        expiresAt: { gt: new Date() },
      },
    });
  }

  async terminateSession(sessionId: string) {
    return this.prisma.userSession.delete({
      where: { id: sessionId },
    });
  }

  async terminateAllSessions(userId: string) {
    return this.prisma.userSession.deleteMany({
      where: { userId },
    });
  }
}
