import { Controller, Post, Param, Req, Headers } from '@nestjs/common';
import { WatcherService } from './watcher.service';
import { JwtStrategy } from '../auth/jwt.strategy';

@Controller('watchers')
export class WatcherController {
  constructor(
    private watcherService: WatcherService,
    private jwtStrategy: JwtStrategy,
  ) {}

  @Post(':taskId/watch')
  async watch(
    @Headers('authorization') authHeader: string,
    @Param('taskId') taskId: string,
  ) {
    const user = await this.jwtStrategy.validateToken(authHeader);
    return this.watcherService.watchTask(taskId, user.id);
  }

  @Post(':taskId/unwatch')
  async unwatch(
    @Headers('authorization') authHeader: string,
    @Param('taskId') taskId: string,
  ) {
    const user = await this.jwtStrategy.validateToken(authHeader);
    return this.watcherService.unwatchTask(taskId, user.id);
  }
}
