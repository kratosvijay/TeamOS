import { Module } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { IntegrationFabricService } from './integration-fabric.service';
import { DataContractsService } from './data-contracts.service';
import { CdcRegistryService } from './cdc-registry.service';
import { IntegrationAnalyticsService } from './integration-analytics.service';
import { IntegrationSandboxService } from './integration-sandbox.service';

@Module({
  providers: [
    PrismaService,
    IntegrationFabricService,
    DataContractsService,
    CdcRegistryService,
    IntegrationAnalyticsService,
    IntegrationSandboxService,
  ],
  exports: [
    IntegrationFabricService,
    DataContractsService,
    CdcRegistryService,
    IntegrationAnalyticsService,
    IntegrationSandboxService,
  ],
})
export class IntegrationFabricModule {}
