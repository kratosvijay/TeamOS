import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { PrismaModule } from './modules/prisma/prisma.module';
import { AuthModule } from './modules/auth/auth.module';
import { WorkspaceModule } from './modules/workspace/workspace.module';
import { WorkspaceSettingsModule } from './modules/workspace-settings/workspace-settings.module';
import { FeatureFlagModule } from './modules/feature-flag/feature-flag.module';
import { ProjectModule } from './modules/project/project.module';
import { EventModule } from './modules/event/event.module';
import { ChatModule } from './modules/chat/chat.module';
import { MeetingModule } from './modules/meeting/meeting.module';
import { DocumentModule } from './modules/document/document.module';
import { DeviceModule } from './modules/device/device.module';
import { NotificationModule } from './modules/notification/notification.module';
import { MentionModule } from './modules/mention/mention.module';
import { WatcherModule } from './modules/watcher/watcher.module';
import { DashboardModule } from './modules/dashboard/dashboard.module';
import { SearchModule } from './modules/search/search.module';
import { QueueModule } from './modules/queue/queue.module';
import { AIModule } from './modules/ai/ai.module';
import { StorageModule } from './modules/storage/storage.module';
import { TaskModule } from './modules/task/task.module';
import { SprintModule } from './modules/sprint/sprint.module';
import { CustomFieldModule } from './modules/custom-field/custom-field.module';
import { SavedFilterModule } from './modules/saved-filter/saved-filter.module';
import { AuditModule } from './modules/audit/audit.module';
import { TaskTemplateModule } from './modules/task-template/task-template.module';
import { ReportingModule } from './modules/reporting/reporting.module';
import { LiveKitModule } from './modules/livekit/livekit.module';
import { OfflineModule } from './modules/offline/offline.module';
import { SecretVaultModule } from './modules/secret-vault/secret-vault.module';
import { OAuthModule } from './modules/oauth/oauth.module';
import { WebhookModule } from './modules/webhook/webhook.module';
import { IntegrationModule } from './modules/integration/integration.module';
import { GitHubModule } from './modules/github/github.module';
import { GoogleModule } from './modules/google/google.module';
import { MarketplaceModule } from './modules/marketplace/marketplace.module';
import { BillingModule } from './modules/billing/billing.module';
import { OrganizationModule } from './modules/organization/organization.module';
import { SSOModule } from './modules/sso/sso.module';
import { SCIMModule } from './modules/scim/scim.module';
import { SecurityModule } from './modules/security/security.module';
import { ComplianceModule } from './modules/compliance/compliance.module';
import { RetentionModule } from './modules/retention/retention.module';
import { DLPModule } from './modules/dlp/dlp.module';
import { AdminCenterModule } from './modules/admin-center/admin-center.module';
import { WarehouseModule } from './modules/data-warehouse/warehouse.module';
import { PortfolioModule } from './modules/portfolio/portfolio.module';
import { OKRModule } from './modules/okr/okr.module';
import { BusinessIntelligenceModule } from './modules/business-intelligence/business-intelligence.module';
import { ForecastingModule } from './modules/forecasting/forecasting.module';
import { ResourcePlanningModule } from './modules/resource-planning/resource-planning.module';
import { ExecutiveDashboardModule } from './modules/executive-dashboard/executive-dashboard.module';
import { CustomDashboardModule } from './modules/custom-dashboard/custom-dashboard.module';
import { WorkflowModule } from './modules/workflow/workflow.module';
import { FormsModule } from './modules/forms/forms.module';
import { ApprovalModule } from './modules/approval/approval.module';
import { RulesEngineModule } from './modules/rules-engine/rules-engine.module';
import { WorkflowMarketplaceModule } from './modules/workflow-marketplace/workflow-marketplace.module';
import { HRMSModule } from './modules/hrms/hrms.module';
import { CRMModule } from './modules/crm/crm.module';
import { ProcurementModule } from './modules/procurement/procurement.module';
import { InventoryModule } from './modules/inventory/inventory.module';
import { AssetsModule } from './modules/assets/assets.module';
import { FinanceModule } from './modules/finance/finance.module';
import { HelpdeskModule } from './modules/helpdesk/helpdesk.module';

// Phase 20 developer ecosystem modules
import { DeveloperModule } from './modules/developer/developer.module';
import { SdkModule } from './modules/sdk/sdk.module';
import { TeamOSGraphQLModule } from './modules/graphql/graphql.module';
import { ApiGatewayModule } from './modules/api-gateway/api-gateway.module';
import { ExtensionRuntimeModule } from './modules/extension-runtime/extension-runtime.module';
import { EventBusModule } from './modules/event-bus/event-bus.module';
import { CliModule } from './modules/cli/cli.module';

// Phase 21 DevOps / Observability modules
import { ObservabilityModule } from './modules/observability/observability.module';
import { LoggingModule } from './modules/logging/logging.module';
import { HealthModule } from './modules/health/health.module';
import { BackupModule } from './modules/backup/backup.module';
import { ClusterModule } from './modules/cluster/cluster.module';

// Phase 23 - Enterprise Digital Twin & Decision Intelligence Modules
import { DigitalTwinModule } from './modules/digital-twin/digital-twin.module';
import { EnterpriseEventBusModule } from './modules/enterprise-event-bus/enterprise-event-bus.module';
import { ProcessMiningModule } from './modules/process-mining/process-mining.module';
import { RootCauseAnalysisModule } from './modules/root-cause-analysis/root-cause-analysis.module';
import { SimulationModule } from './modules/simulation/simulation.module';
import { OptimizationModule } from './modules/optimization/optimization.module';
import { PredictionEngineModule } from './modules/prediction-engine/prediction-engine.module';
import { DecisionIntelligenceModule } from './modules/decision-intelligence/decision-intelligence.module';
import { StrategyModule } from './modules/strategy/strategy.module';
import { ExecutiveIntelligenceModule } from './modules/executive-intelligence/executive-intelligence.module';
import { EnterpriseDecisionEngineModule } from './modules/enterprise-decision-engine/enterprise-decision-engine.module';

// Phase 24 Enterprise Data Platform modules
import { IntegrationFabricModule } from './modules/integration-fabric/integration-fabric.module';
import { MasterDataModule } from './modules/master-data/master-data.module';
import { DataGovernanceModule } from './modules/data-governance/data-governance.module';
import { EtlEngineModule } from './modules/etl-engine/etl-engine.module';
import { StreamingPlatformModule } from './modules/streaming-platform/streaming-platform.module';
import { CanonicalMappingModule } from './modules/canonical-mapping/canonical-mapping.module';
import { StudioModule } from './modules/studio/studio.module';
import { RuntimeModule } from './modules/runtime/runtime.module';
import { IntegrationFlowModule } from './modules/integration-flow/integration-flow.module';
import { ApiManagementModule } from './modules/api-management/api-management.module';
import { EventStreamingModule } from './modules/event-streaming/event-streaming.module';
import { DataPipelineModule } from './modules/data-pipeline/data-pipeline.module';
import { IdpModule } from './modules/idp/idp.module';
import { RpaModule } from './modules/rpa/rpa.module';
import { B2bModule } from './modules/b2b/b2b.module';
import { SyncEngineModule } from './modules/sync-engine/sync-engine.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: ['.env', '.env.development'],
    }),
    PrismaModule,
    AuthModule,
    WorkspaceModule,
    WorkspaceSettingsModule,
    FeatureFlagModule,
    ProjectModule,
    EventModule,
    ChatModule,
    MeetingModule,
    DocumentModule,
    DeviceModule,
    NotificationModule,
    MentionModule,
    WatcherModule,
    DashboardModule,
    SearchModule,
    QueueModule,
    AIModule,
    StorageModule,
    TaskModule,
    SprintModule,
    CustomFieldModule,
    SavedFilterModule,
    AuditModule,
    TaskTemplateModule,
    ReportingModule,
    LiveKitModule,
    OfflineModule,
    SecretVaultModule,
    OAuthModule,
    WebhookModule,
    IntegrationModule,
    GitHubModule,
    GoogleModule,
    MarketplaceModule,
    BillingModule,
    OrganizationModule,
    SSOModule,
    SCIMModule,
    SecurityModule,
    ComplianceModule,
    RetentionModule,
    DLPModule,
    AdminCenterModule,
    WarehouseModule,
    PortfolioModule,
    OKRModule,
    BusinessIntelligenceModule,
    ForecastingModule,
    ResourcePlanningModule,
    ExecutiveDashboardModule,
    CustomDashboardModule,
    WorkflowModule,
    FormsModule,
    ApprovalModule,
    RulesEngineModule,
    WorkflowMarketplaceModule,
    HRMSModule,
    CRMModule,
    ProcurementModule,
    InventoryModule,
    AssetsModule,
    FinanceModule,
    HelpdeskModule,
    DeveloperModule,
    SdkModule,
    TeamOSGraphQLModule,
    ApiGatewayModule,
    ExtensionRuntimeModule,
    EventBusModule,
    CliModule,
    ObservabilityModule,
    LoggingModule,
    HealthModule,
    BackupModule,
    ClusterModule,
    DigitalTwinModule,
    EnterpriseEventBusModule,
    ProcessMiningModule,
    RootCauseAnalysisModule,
    SimulationModule,
    OptimizationModule,
    PredictionEngineModule,
    DecisionIntelligenceModule,
    StrategyModule,
    ExecutiveIntelligenceModule,
    EnterpriseDecisionEngineModule,
    IntegrationFabricModule,
    MasterDataModule,
    DataGovernanceModule,
    EtlEngineModule,
    StreamingPlatformModule,
    CanonicalMappingModule,
    StudioModule,
    RuntimeModule,
    IntegrationFlowModule,
    ApiManagementModule,
    EventStreamingModule,
    DataPipelineModule,
    IdpModule,
    RpaModule,
    B2bModule,
    SyncEngineModule,
  ],
})
export class AppModule {}


