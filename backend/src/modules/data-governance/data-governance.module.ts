import { Module } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { DataGovernanceService } from './data-governance.service';
import { DataQualityEngineService } from './data-quality-engine.service';
import { DataPrivacyService } from './data-privacy.service';
import { DataObservabilityService } from './data-observability.service';
import { DataProductService } from './data-product.service';
import { RetentionService } from './retention.service';
import { DataMarketplaceService } from './data-marketplace.service';
import { DataMeshService } from './data-mesh.service';
import { LakehouseService } from './lakehouse.service';
import { SemanticLayerService } from './semantic-layer.service';
import { MetadataDiscoveryService } from './metadata-discovery.service';
import { DataApiService } from './data-api.service';
import { SharingAgreementService } from './sharing-agreement.service';
import { DataFinopsService } from './data-finops.service';
import { DataReliabilityService } from './data-reliability.service';
import { FeatureStoreService } from './feature-store.service';
import { QueryPlannerService } from './query-planner.service';
import { UniversalSearchService } from './universal-search.service';
import { DataFederationService } from './data-federation.service';
import { ContractTestingService } from './contract-testing.service';
import { DatasetSlaService } from './dataset-sla.service';
import { UsageAnalyticsService } from './usage-analytics.service';

@Module({
  providers: [
    PrismaService,
    DataGovernanceService,
    DataQualityEngineService,
    DataPrivacyService,
    DataObservabilityService,
    DataProductService,
    RetentionService,
    DataMarketplaceService,
    DataMeshService,
    LakehouseService,
    SemanticLayerService,
    MetadataDiscoveryService,
    DataApiService,
    SharingAgreementService,
    DataFinopsService,
    DataReliabilityService,
    FeatureStoreService,
    QueryPlannerService,
    UniversalSearchService,
    DataFederationService,
    ContractTestingService,
    DatasetSlaService,
    UsageAnalyticsService,
  ],
  exports: [
    DataGovernanceService,
    DataQualityEngineService,
    DataPrivacyService,
    DataObservabilityService,
    DataProductService,
    RetentionService,
    DataMarketplaceService,
    DataMeshService,
    LakehouseService,
    SemanticLayerService,
    MetadataDiscoveryService,
    DataApiService,
    SharingAgreementService,
    DataFinopsService,
    DataReliabilityService,
    FeatureStoreService,
    QueryPlannerService,
    UniversalSearchService,
    DataFederationService,
    ContractTestingService,
    DatasetSlaService,
    UsageAnalyticsService,
  ],
})
export class DataGovernanceModule {}
