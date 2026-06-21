import { Controller, Post, Body, Req, UnauthorizedException, BadRequestException } from '@nestjs/common';
import { DeviceService } from './device.service';
import { JwtStrategy } from '../auth/jwt.strategy';

@Controller('devices')
export class DeviceController {
  constructor(
    private deviceService: DeviceService,
    private jwtStrategy: JwtStrategy,
  ) {}

  @Post('register')
  async register(
    @Headers('authorization') authHeader: string,
    @Body() body: { deviceId: string; platform: string; fcmToken: string },
  ) {
    const user = await this.jwtStrategy.validateToken(authHeader);
    if (!body.deviceId || !body.platform || !body.fcmToken) {
      throw new BadRequestException('deviceId, platform, and fcmToken are required');
    }
    return this.deviceService.registerDevice(user.id, body.deviceId, body.platform, body.fcmToken);
  }

  @Post('unregister')
  async unregister(
    @Headers('authorization') authHeader: string,
    @Body() body: { deviceId: string },
  ) {
    const user = await this.jwtStrategy.validateToken(authHeader);
    if (!body.deviceId) {
      throw new BadRequestException('deviceId is required');
    }
    return this.deviceService.unregisterDevice(user.id, body.deviceId);
  }
}

// Inline helper for Header mapping decorator
import { Headers } from '@nestjs/common';
