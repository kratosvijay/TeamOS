import { Controller, Get, Post, Body, Param, Query, BadRequestException } from '@nestjs/common';
import { PortfolioService } from './portfolio.service';

@Controller('portfolio')
export class PortfolioController {
  constructor(private portfolioService: PortfolioService) {}

  @Post()
  async createPortfolio(
    @Body() body: { name: string; description?: string; workspaceIds?: string[] },
  ) {
    if (!body.name) {
      throw new BadRequestException('Portfolio name is required');
    }
    return this.portfolioService.createPortfolio(body.name, body.description, body.workspaceIds || []);
  }

  @Get()
  async getPortfolios() {
    return this.portfolioService.getPortfolios();
  }

  @Get(':id')
  async getPortfolio(@Param('id') id: string) {
    return this.portfolioService.getPortfolio(id);
  }
}

@Controller('program')
export class ProgramController {
  constructor(private portfolioService: PortfolioService) {}

  @Post()
  async createProgram(
    @Body() body: { portfolioId: string; name: string; description?: string; startDate?: string; endDate?: string },
  ) {
    if (!body.portfolioId || !body.name) {
      throw new BadRequestException('Portfolio ID and Program name are required');
    }
    return this.portfolioService.createProgram(
      body.portfolioId,
      body.name,
      body.description,
      body.startDate,
      body.endDate,
    );
  }

  @Get()
  async getPrograms(@Query('portfolioId') portfolioId?: string) {
    return this.portfolioService.getPrograms(portfolioId);
  }
}
