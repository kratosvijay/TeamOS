import { Module } from '@nestjs/common';
import { IntegrationService } from './integration.service';
import { IntegrationController } from './integration.controller';
import { IntegrationSyncService } from './integration-sync.service';
import { IntegrationEventBus } from './integration-event-bus.service';
import { AIModule } from '../ai/ai.module';
import { AuthModule } from '../auth/auth.module';

@Module({
  imports: [AIModule, AuthModule],
  controllers: [IntegrationController],
  providers: [IntegrationService, IntegrationSyncService, IntegrationEventBus],
  exports: [IntegrationService, IntegrationSyncService, IntegrationEventBus],
})
export class IntegrationModule {}
