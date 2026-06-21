import { Module } from '@nestjs/common';
import { GitHubService } from './github.service';
import { GitHubController } from './github.controller';
import { GitHubWebhookController } from './github.webhook';
import { OAuthModule } from '../oauth/oauth.module';
import { AIModule } from '../ai/ai.module';
import { IntegrationModule } from '../integration/integration.module';
import { AuthModule } from '../auth/auth.module';

@Module({
  imports: [OAuthModule, AIModule, IntegrationModule, AuthModule],
  controllers: [GitHubController, GitHubWebhookController],
  providers: [GitHubService],
  exports: [GitHubService],
})
export class GitHubModule {}
