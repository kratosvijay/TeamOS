import { Controller, Post, Body, Headers, HttpCode, HttpStatus } from '@nestjs/common';
import { IntegrationEventBus } from '../integration/integration-event-bus.service';

@Controller('integrations/github')
export class GitHubWebhookController {
  constructor(private readonly eventBus: IntegrationEventBus) {}

  @Post('webhook')
  @HttpCode(HttpStatus.OK)
  async handleWebhook(
    @Headers('x-github-event') eventType: string,
    @Headers('x-github-delivery') deliveryId: string,
    @Body() payload: any,
  ) {
    // In production: validate request signature using github secret
    console.log(`GitHub Webhook: Received event ${eventType} (Delivery: ${deliveryId})`);

    // Normalize webhook payloads
    let resourceId = 'unknown';
    let workspaceId = payload.state || payload.workspaceId || 'mock-workspace-id';

    if (eventType === 'pull_request') {
      const prAction = payload.action; // opened, closed, merged
      resourceId = payload.pull_request?.number?.toString() || 'unknown';
      
      await this.eventBus.publish({
        provider: 'github',
        eventType: `pull_request.${prAction}`,
        resourceId,
        workspaceId,
        payload: payload.pull_request || payload,
      });
    } else if (eventType === 'push') {
      resourceId = payload.head_commit?.id || 'unknown';
      await this.eventBus.publish({
        provider: 'github',
        eventType: 'push',
        resourceId,
        workspaceId,
        payload: payload.head_commit || payload,
      });
    }

    return { received: true };
  }
}
