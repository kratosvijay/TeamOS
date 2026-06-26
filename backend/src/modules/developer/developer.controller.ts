import { Controller, Get, Post, Put, Delete, Body, Param } from '@nestjs/common';
import { DeveloperService } from './developer.service';

@Controller('developer/apps')
export class DeveloperController {
  constructor(private readonly developerService: DeveloperService) {}

  @Get()
  async getApps() {
    return this.developerService.getApps();
  }

  @Post()
  async createApp(
    @Body()
    body: {
      name: string;
      slug: string;
      description: string;
      version: string;
      author: string;
      category: string;
      icon?: string;
      bannerImage?: string;
    },
  ) {
    return this.developerService.createApp(body);
  }

  @Put(':id')
  async updateApp(
    @Param('id') id: string,
    @Body()
    body: {
      name?: string;
      description?: string;
      version?: string;
      status?: string;
      category?: string;
      icon?: string;
      bannerImage?: string;
    },
  ) {
    return this.developerService.updateApp(id, body);
  }

  @Delete(':id')
  async deleteApp(@Param('id') id: string) {
    return this.developerService.deleteApp(id);
  }

  @Get(':id/analytics')
  async getAnalytics(@Param('id') id: string) {
    return this.developerService.getAnalytics(id);
  }
}
