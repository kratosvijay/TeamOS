import { Injectable, NotFoundException, ForbiddenException, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class SavedFilterService {
  constructor(private prisma: PrismaService) {}

  async createFilter(
    userId: string,
    workspaceId: string,
    name: string,
    filterJson: any,
    isShared = false,
  ) {
    try {
      return await this.prisma.savedFilter.create({
        data: {
          userId,
          workspaceId,
          name,
          filterJson,
          isShared,
        },
      });
    } catch (error) {
      // Handle unique constraint violation on userId + name
      if (error.code === 'P2002') {
        throw new BadRequestException('A filter with this name already exists for this user');
      }
      throw error;
    }
  }

  async getFilters(userId: string, workspaceId: string) {
    return this.prisma.savedFilter.findMany({
      where: {
        workspaceId,
        OR: [
          { userId },
          { isShared: true },
        ],
      },
      orderBy: { createdAt: 'desc' },
    });
  }

  async updateFilter(
    id: string,
    userId: string,
    data: {
      name?: string;
      filterJson?: any;
      isShared?: boolean;
    },
  ) {
    const filter = await this.prisma.savedFilter.findUnique({
      where: { id },
    });

    if (!filter) {
      throw new NotFoundException('Saved filter not found');
    }

    if (filter.userId !== userId) {
      throw new ForbiddenException('You do not have permission to update this filter');
    }

    try {
      return await this.prisma.savedFilter.update({
        where: { id },
        data,
      });
    } catch (error) {
      if (error.code === 'P2002') {
        throw new BadRequestException('A filter with this name already exists for this user');
      }
      throw error;
    }
  }

  async deleteFilter(id: string, userId: string) {
    const filter = await this.prisma.savedFilter.findUnique({
      where: { id },
    });

    if (!filter) {
      throw new NotFoundException('Saved filter not found');
    }

    if (filter.userId !== userId) {
      throw new ForbiddenException('You do not have permission to delete this filter');
    }

    await this.prisma.savedFilter.delete({
      where: { id },
    });

    return { success: true };
  }
}
