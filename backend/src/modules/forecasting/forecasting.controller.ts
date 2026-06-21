import { Controller, Get, Post, Body, Headers, Query, BadRequestException } from '@nestjs/common';
import { ForecastingService } from './forecasting.service';

@Controller('forecasting')
export class ForecastingController {
  constructor(private forecastingService: ForecastingService) {}

  @Post('generate')
  async generateForecast(
    @Headers('x-workspace-id') workspaceIdHeader: string,
    @Body() body: { workspaceId?: string; forecastType: 'DELIVERY' | 'CAPACITY' | 'REVENUE' | 'BUDGET' | 'RISK' },
  ) {
    const workspaceId = body.workspaceId || workspaceIdHeader;
    if (!workspaceId || !body.forecastType) {
      throw new BadRequestException('Workspace ID and forecastType are required');
    }
    return this.forecastingService.generateForecast(workspaceId, body.forecastType);
  }

  @Get()
  async getForecasts(
    @Headers('x-workspace-id') workspaceIdHeader: string,
    @Query('workspaceId') workspaceIdQuery?: string,
  ) {
    const workspaceId = workspaceIdQuery || workspaceIdHeader;
    if (!workspaceId) {
      throw new BadRequestException('Workspace ID is required');
    }
    return this.forecastingService.getForecasts(workspaceId);
  }
}
