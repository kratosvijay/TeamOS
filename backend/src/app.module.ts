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
  ],
})
export class AppModule {}

