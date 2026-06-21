import { Injectable, UnauthorizedException } from '@nestjs/common';
import { OAuthService } from '../oauth/oauth.service';
import { AIService } from '../ai/ai.service';
import { IntegrationEventBus } from '../integration/integration-event-bus.service';

@Injectable()
export class GitHubService {
  constructor(
    private readonly oauthService: OAuthService,
    private readonly aiService: AIService,
    private readonly eventBus: IntegrationEventBus,
  ) {}

  async connectGitHub(workspaceId: string, code: string) {
    return this.oauthService.connectProvider(workspaceId, 'GITHUB', code);
  }

  async getRepositories(workspaceId: string) {
    // In production: perform GET request to https://api.github.com/user/repos
    // using accessToken retrieved from oauthService
    const credentials = await this.oauthService.getCredentials(workspaceId, 'GITHUB');
    if (!credentials.accessToken) {
      throw new UnauthorizedException('Missing GitHub connection credentials');
    }

    // Mock response payload
    return [
      { id: 101, name: 'teamos-core', fullName: 'teamos/teamos-core', private: true },
      { id: 102, name: 'teamos-app', fullName: 'teamos/teamos-app', private: true },
      { id: 103, name: 'teamos-docs', fullName: 'teamos/teamos-docs', private: false },
    ];
  }

  async getPullRequests(workspaceId: string, repo: string) {
    const credentials = await this.oauthService.getCredentials(workspaceId, 'GITHUB');
    if (!credentials.accessToken) {
      throw new UnauthorizedException('Missing GitHub connection credentials');
    }

    return [
      { id: 41, title: 'feat: Add OAuth integration endpoints', status: 'OPEN', author: 'SarahConnor' },
      { id: 42, title: 'fix: Patch memory leaks in Yjs CRDT binary merge', status: 'MERGED', author: 'JohnDoe' },
    ];
  }

  async summarizePR(prId: string, prBody: string): Promise<string> {
    if (!prBody) return 'No description provided for summary.';
    // Call AI summary generator
    if (this.aiService.generateSummary) {
      return this.aiService.generateSummary(prBody);
    }
    return '[Fallback AI Summary] Optimizes database schema migrations and registers global modules.';
  }

  async generateReleaseNotes(commits: string[]): Promise<string> {
    const prompt = `Generate release notes for the following commits: ${commits.join(', ')}`;
    // Call AI service completion
    // We provide a mock completed response
    return `### TeamOS Release Notes\n\n- Optimized database lookups\n- Added oauth configurations\n- Resolved connection retries.`;
  }
}
