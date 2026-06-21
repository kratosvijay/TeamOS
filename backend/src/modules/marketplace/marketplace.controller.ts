import { Controller, Get, Post, Body, Headers, Req, UseGuards } from '@nestjs/common';
import { MarketplaceService } from './marketplace.service';
import { WorkspaceAuthGuard } from '../../common/guards/workspace-auth.guard';
import { IntegrationPermission } from '@prisma/client';

@Controller('marketplace')
@UseGuards(WorkspaceAuthGuard)
export class MarketplaceController {
  constructor(private readonly marketplaceService: MarketplaceService) {}

  @Get()
  async getCatalog() {
    return this.marketplaceService.getCatalog();
  }

  @Post('install')
  async install(
    @Headers('x-workspace-id') workspaceId: string,
    @Req() req: any,
    @Body('provider') provider: string,
    @Body('permission') permission?: IntegrationPermission,
  ) {
    const userId = req.user.id;
    return this.marketplaceService.installMarketplaceIntegration(
      workspaceId,
      userId,
      provider,
      permission || IntegrationPermission.READ_ONLY,
    );
  }
}
