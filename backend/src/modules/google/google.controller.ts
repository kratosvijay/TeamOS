import { Controller, Post, Body, Headers, Req, UseGuards } from '@nestjs/common';
import { GoogleService } from './google.service';
import { WorkspaceAuthGuard } from '../../common/guards/workspace-auth.guard';

@Controller('integrations/google')
@UseGuards(WorkspaceAuthGuard)
export class GoogleController {
  constructor(private readonly googleService: GoogleService) {}

  @Post('connect')
  async connectGoogle(
    @Headers('x-workspace-id') workspaceId: string,
    @Body('code') code: string,
  ) {
    return this.googleService.connectGoogle(workspaceId, code);
  }

  @Post('sync-calendar')
  async syncCalendar(@Headers('x-workspace-id') workspaceId: string) {
    return this.googleService.syncCalendarEvents(workspaceId);
  }

  @Post('import-doc')
  async importDoc(
    @Headers('x-workspace-id') workspaceId: string,
    @Req() req: any,
    @Body('docId') docId: string,
    @Body('title') title: string,
  ) {
    const userId = req.user.id;
    return this.googleService.importGoogleDoc(workspaceId, userId, docId, title);
  }
}
