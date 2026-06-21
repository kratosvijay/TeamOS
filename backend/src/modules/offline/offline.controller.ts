import { Controller, Post, Get, Body, Query, UseGuards, Req } from '@nestjs/common';
import { OfflineService, SyncBatch } from './offline.service';
import { WorkspaceAuthGuard } from '../../common/guards/workspace-auth.guard';

@Controller('offline')
@UseGuards(WorkspaceAuthGuard)
export class OfflineController {
  constructor(private readonly offlineService: OfflineService) {}

  @Get('sync-status')
  async getSyncStatus(@Query('deviceId') deviceId: string) {
    if (!deviceId) {
      return { error: 'deviceId query parameter is required' };
    }
    return this.offlineService.getSyncStatus(deviceId);
  }

  @Post('sync')
  async syncBatch(@Req() req: any, @Body() batch: SyncBatch) {
    const userId = req.user.id;
    return this.offlineService.processSyncBatch(userId, batch);
  }
}
