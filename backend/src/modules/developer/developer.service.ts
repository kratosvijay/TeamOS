import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class DeveloperService {
  constructor(private readonly prisma: PrismaService) {}

  async getApps() {
    return this.prisma.developerApp.findMany();
  }

  async createApp(data: {
    name: string;
    slug: string;
    description: string;
    version: string;
    author: string;
    category: string;
    icon?: string;
    bannerImage?: string;
  }) {
    return this.prisma.developerApp.create({
      data: {
        name: data.name,
        slug: data.slug,
        description: data.description,
        version: data.version,
        author: data.author,
        category: data.category,
        icon: data.icon || null,
        bannerImage: data.bannerImage || null,
        status: 'DRAFT',
      },
    });
  }

  async updateApp(
    id: string,
    data: {
      name?: string;
      description?: string;
      version?: string;
      status?: string;
      category?: string;
      icon?: string;
      bannerImage?: string;
    },
  ) {
    return this.prisma.developerApp.update({
      where: { id },
      data: {
        name: data.name,
        description: data.description,
        version: data.version,
        status: data.status,
        category: data.category,
        icon: data.icon,
        bannerImage: data.bannerImage,
      },
    });
  }

  async deleteApp(id: string) {
    return this.prisma.developerApp.delete({
      where: { id },
    });
  }

  async getAnalytics(id: string) {
    const analytics = await this.prisma.extensionAnalytics.findFirst({
      where: { extensionId: id },
    });

    if (analytics) return analytics;

    return {
      id: 'mock-id',
      extensionId: id,
      installs: 10,
      activeUsers: 8,
      crashes: 0,
      averageExecutionTime: 12.5,
      errors: 1,
    };
  }
}
