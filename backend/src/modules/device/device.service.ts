import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class DeviceService {
  constructor(private prisma: PrismaService) {}

  async registerDevice(userId: string, deviceId: string, platform: string, fcmToken: string) {
    return this.prisma.device.upsert({
      where: {
        userId_deviceId: { userId, deviceId },
      },
      update: {
        platform,
        fcmToken,
        lastSeenAt: new Date(),
      },
      create: {
        userId,
        deviceId,
        platform,
        fcmToken,
      },
    });
  }

  async unregisterDevice(userId: string, deviceId: string) {
    return this.prisma.device.deleteMany({
      where: {
        userId,
        deviceId,
      },
    });
  }
}
