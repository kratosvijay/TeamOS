import { Controller, Get, Query, UseGuards, Headers } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { WorkspaceAuthGuard } from '../../common/guards/workspace-auth.guard';

@Controller('activity')
@UseGuards(WorkspaceAuthGuard)
export class ActivityController {
  constructor(private readonly prisma: PrismaService) {}

  @Get('timeline')
  async getTimeline(
    @Headers('x-workspace-id') workspaceId: string,
    @Query('limit') limitStr?: string,
    @Query('offset') offsetStr?: string,
  ) {
    const limit = limitStr ? parseInt(limitStr, 10) : 50;
    const offset = offsetStr ? parseInt(offsetStr, 10) : 0;

    const auditTrails = await this.prisma.auditTrail.findMany({
      where: workspaceId ? { workspaceId } : {},
      include: {
        actor: {
          select: {
            id: true,
            fullName: true,
            email: true,
          },
        },
      },
      orderBy: { createdAt: 'desc' },
      take: limit,
      skip: offset,
    });

    const timeline = auditTrails.map((trail) => ({
      id: trail.id,
      type: 'AUDIT',
      action: trail.action,
      entityType: trail.entityType,
      entityId: trail.entityId,
      oldValue: trail.oldValue,
      newValue: trail.newValue,
      actor: trail.actor,
      createdAt: trail.createdAt,
    }));

    return timeline;
  }
}
