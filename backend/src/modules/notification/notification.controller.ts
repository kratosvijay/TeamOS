import { Controller, Get, Post, Param, Query, Req, UseGuards, Headers } from '@nestjs/common';
import { NotificationService } from './notification.service';
import { JwtStrategy } from '../auth/jwt.strategy';

@Controller('notifications')
export class NotificationController {
  constructor(
    private notificationService: NotificationService,
    private jwtStrategy: JwtStrategy,
  ) {}

  @Get()
  async getNotifications(
    @Headers('authorization') authHeader: string,
    @Query('limit') limit = '20',
    @Query('offset') offset = '0',
  ) {
    const user = await this.jwtStrategy.validateToken(authHeader);
    return this.notificationService.listNotifications(
      user.id,
      parseInt(limit),
      parseInt(offset),
    );
  }

  @Get('unread')
  async getUnreadCount(@Headers('authorization') authHeader: string) {
    const user = await this.jwtStrategy.validateToken(authHeader);
    return this.notificationService.getUnreadCount(user.id);
  }

  @Post(':notificationId/read')
  async readSingle(
    @Headers('authorization') authHeader: string,
    @Param('notificationId') notificationId: string,
  ) {
    const user = await this.jwtStrategy.validateToken(authHeader);
    return this.notificationService.markAsRead(notificationId, user.id);
  }

  @Post('read-all')
  async readAll(@Headers('authorization') authHeader: string) {
    const user = await this.jwtStrategy.validateToken(authHeader);
    return this.notificationService.markAllAsRead(user.id);
  }
}
