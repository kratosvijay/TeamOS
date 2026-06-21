import { Controller, Get, Post, Body, Query, Headers, UseGuards } from '@nestjs/common';
import { GitHubService } from './github.service';
import { WorkspaceAuthGuard } from '../../common/guards/workspace-auth.guard';

@Controller('integrations/github')
@UseGuards(WorkspaceAuthGuard)
export class GitHubController {
  constructor(private readonly githubService: GitHubService) {}

  @Post('connect')
  async connectGitHub(
    @Headers('x-workspace-id') workspaceId: string,
    @Body('code') code: string,
  ) {
    return this.githubService.connectGitHub(workspaceId, code);
  }

  @Get('repos')
  async getRepositories(@Headers('x-workspace-id') workspaceId: string) {
    return this.githubService.getRepositories(workspaceId);
  }

  @Get('prs')
  async getPullRequests(
    @Headers('x-workspace-id') workspaceId: string,
    @Query('repo') repo: string,
  ) {
    return this.githubService.getPullRequests(workspaceId, repo);
  }

  @Post('pr-summary')
  async getPRSummary(
    @Body('prId') prId: string,
    @Body('body') body: string,
  ) {
    const summary = await this.githubService.summarizePR(prId, body);
    return { summary };
  }
}
