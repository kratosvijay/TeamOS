import { Controller, Post, Body, Param, Headers, UseGuards, Req } from '@nestjs/common';
import { SprintService } from './sprint.service';
import { JwtStrategy } from '../auth/jwt.strategy';

@Controller('sprints')
export class SprintController {
  constructor(
    private sprintService: SprintService,
    private jwtStrategy: JwtStrategy,
  ) {}

  @Post()
  async createSprint(
    @Headers('authorization') authHeader: string,
    @Body()
    body: {
      projectId: string;
      name: string;
      goal?: string;
      startDate?: string;
      endDate?: string;
    },
  ) {
    const user = await this.jwtStrategy.validateToken(authHeader);
    return this.sprintService.createSprint(
      body.projectId,
      body.name,
      body.goal,
      body.startDate ? new Date(body.startDate) : undefined,
      body.endDate ? new Date(body.endDate) : undefined,
      user.id,
    );
  }

  @Post(':id/start')
  async startSprint(
    @Headers('authorization') authHeader: string,
    @Param('id') id: string,
  ) {
    const user = await this.jwtStrategy.validateToken(authHeader);
    return this.sprintService.startSprint(id, user.id);
  }

  @Post(':id/complete')
  async completeSprint(
    @Headers('authorization') authHeader: string,
    @Param('id') id: string,
    @Body()
    body: {
      retrospective?: string;
      retrospectiveActionItems?: any;
      moveToSprintId?: string;
    },
  ) {
    const user = await this.jwtStrategy.validateToken(authHeader);
    return this.sprintService.completeSprint(id, user.id, body);
  }
}
