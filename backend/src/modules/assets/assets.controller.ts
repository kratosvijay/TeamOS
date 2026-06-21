import { Controller, Get, Post, Body, Headers, BadRequestException } from '@nestjs/common';
import { AssetsService } from './assets.service';

@Controller('assets')
export class AssetsController {
  constructor(private assetsService: AssetsService) {}

  @Get()
  async getAssets(@Headers('x-workspace-id') workspaceId: string) {
    if (!workspaceId) {
      throw new BadRequestException('Workspace ID is required');
    }
    return this.assetsService.getAssets(workspaceId);
  }

  @Post()
  async createAsset(
    @Headers('x-workspace-id') workspaceId: string,
    @Body() body: { name: string; category: string; value: number },
  ) {
    if (!workspaceId) {
      throw new BadRequestException('Workspace ID is required');
    }
    if (!body.name || !body.category || body.value === undefined) {
      throw new BadRequestException('name, category, and value are required');
    }
    return this.assetsService.createAsset(workspaceId, body.name, body.category, body.value);
  }

  @Post('maintenance')
  async scheduleMaintenance(
    @Body() body: { assetId: string; title: string; scheduledDate: string },
  ) {
    if (!body.assetId || !body.title || !body.scheduledDate) {
      throw new BadRequestException('assetId, title, and scheduledDate are required');
    }
    return this.assetsService.scheduleMaintenance(body.assetId, body.title, new Date(body.scheduledDate));
  }
}
