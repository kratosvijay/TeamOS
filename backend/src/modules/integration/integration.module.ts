import { Module } from '@nestjs/common';
import { IntegrationService } from './integration.service';
import { IntegrationController } from './integration.controller';
import { IntegrationSyncService } from './integration-sync.service';
import { IntegrationEventBus } from './integration-event-bus.service';
import { ConnectorService } from './connector.service';
import { ConnectorRuntimeService } from './connector-runtime.service';
import { ConnectorHealthService } from './connector-health.service';
import { ConnectorMarketplaceService } from './connector-marketplace.service';
import { ConnectorSdkService } from './connector-sdk.service';
import { ConnectorGeneratorService } from './connector-generator.service';
import { ConnectorValidatorService } from './connector-validator.service';
import { IntegrationRegistryService } from './integration-registry.service';
import { IntegrationGovernanceService } from './integration-governance.service';
import { SecretsManagerService } from './secrets-manager.service';
import { IntegrationTestService } from './integration-test.service';
import { IntegrationAiService } from './integration-ai.service';
import { AIModule } from '../ai/ai.module';
import { AuthModule } from '../auth/auth.module';
import { PrismaModule } from '../prisma/prisma.module';

@Module({
  imports: [AIModule, AuthModule, PrismaModule],
  controllers: [IntegrationController],
  providers: [
    IntegrationService,
    IntegrationSyncService,
    IntegrationEventBus,
    ConnectorService,
    ConnectorRuntimeService,
    ConnectorHealthService,
    ConnectorMarketplaceService,
    ConnectorSdkService,
    ConnectorGeneratorService,
    ConnectorValidatorService,
    IntegrationRegistryService,
    IntegrationGovernanceService,
    SecretsManagerService,
    IntegrationTestService,
    IntegrationAiService,
  ],
  exports: [
    IntegrationService,
    IntegrationSyncService,
    IntegrationEventBus,
    ConnectorService,
    ConnectorRuntimeService,
    ConnectorHealthService,
    ConnectorMarketplaceService,
    ConnectorSdkService,
    ConnectorGeneratorService,
    ConnectorValidatorService,
    IntegrationRegistryService,
    IntegrationGovernanceService,
    SecretsManagerService,
    IntegrationTestService,
    IntegrationAiService,
  ],
})
export class IntegrationModule {}
