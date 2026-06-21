import { Controller, Post, Get, Put, Delete, Body, Param, UseGuards, Headers, Req } from '@nestjs/common';
import { SavedFilterService } from './saved-filter.service';
import { WorkspaceAuthGuard } from '../../common/guards/workspace-auth.guard';

@Controller('saved-filters')
@UseGuards(WorkspaceAuthGuard)
export class SavedFilterController {
  constructor(private savedFilterService: SavedFilterService) {}

  @Post()
  async createFilter(
    @Req() req: any,
    @Headers('x-workspace-id') workspaceId: string,
    @Body() body: { name: string; filterJson: any; isShared?: boolean },
  ) {
    const userId = req.user.id;
    return this.savedFilterService.createFilter(userId, workspaceId, body.name, body.filterJson, body.isShared);
  }

  @Get()
  async getFilters(
    @Req() req: any,
    @Headers('x-workspace-id') workspaceId: string,
  ) {
    const userId = req.user.id;
    return this.savedFilterService.getFilters(userId, workspaceId);
  }

  @Put(':id')
  async updateFilter(
    @Req() req: any,
    @Param('id') id: string,
    @Body() body: { name?: string; filterJson?: any; isShared?: boolean },
  ) {
    const userId = req.user.id;
    return this.savedFilterService.updateFilter(id, userId, body);
  }

  @Delete(':id')
  async deleteFilter(
    @Req() req: any,
    @Param('id') id: string,
  ) {
    const userId = req.user.id;
    return this.savedFilterService.deleteFilter(id, userId);
  }
}
