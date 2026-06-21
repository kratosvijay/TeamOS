import { Test, TestingModule } from '@nestjs/testing';
import { GitHubService } from '../github.service';
import { OAuthService } from '../../oauth/oauth.service';
import { AIService } from '../../ai/ai.service';
import { IntegrationEventBus } from '../../integration/integration-event-bus.service';

describe('GitHubService', () => {
  let service: GitHubService;
  let oauth: OAuthService;
  let ai: AIService;

  const mockOAuth = {
    connectProvider: jest.fn(),
    getCredentials: jest.fn(),
  };

  const mockAI = {
    generateSummary: jest.fn().mockResolvedValue('Mocked summary'),
  };

  const mockEventBus = {
    publish: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        GitHubService,
        { provide: OAuthService, useValue: mockOAuth },
        { provide: AIService, useValue: mockAI },
        { provide: IntegrationEventBus, useValue: mockEventBus },
      ],
    }).compile();

    service = module.get<GitHubService>(GitHubService);
    oauth = module.get<OAuthService>(OAuthService);
    ai = module.get<AIService>(AIService);
  });

  it('should get repos listing successfully', async () => {
    mockOAuth.getCredentials.mockResolvedValue({ accessToken: 'gh_access_token' });
    const repos = await service.getRepositories('workspace-1');
    expect(repos).toHaveLength(3);
    expect(repos[0].name).toBe('teamos-core');
  });

  it('should call AIService to generate PR summaries', async () => {
    const summary = await service.summarizePR('pr-1', 'Add authentication flow');
    expect(summary).toBe('Mocked summary');
    expect(ai.generateSummary).toHaveBeenCalled();
  });
});
