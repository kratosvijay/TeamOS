import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Import feature screens
import '../features/auth/presentation/splash_screen.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/signup_screen.dart';
import '../features/auth/presentation/forgot_password_screen.dart';
import '../features/workspace/presentation/workspace_setup_screen.dart';
import '../features/workspace/presentation/workspace_selection_screen.dart';
import '../features/dashboard/presentation/dashboard_screen.dart';
import '../features/projects/presentation/project_list_screen.dart';
import '../features/projects/presentation/project_create_screen.dart';
import '../features/projects/presentation/project_details_screen.dart';
import '../features/tasks/presentation/chat_home_screen.dart';
import '../features/tasks/presentation/channel_screen.dart';
import '../features/tasks/presentation/dm_screen.dart';
import '../features/tasks/presentation/thread_screen.dart';
import '../features/tasks/presentation/voice_room_screen.dart';
import '../features/tasks/presentation/chat_search_screen.dart';
import '../features/tasks/presentation/mentions_screen.dart';
import '../features/tasks/presentation/pinned_messages_screen.dart';
import '../features/meetings/presentation/meeting_home_screen.dart';
import '../features/meetings/presentation/meeting_room_screen.dart';
import '../features/meetings/presentation/meeting_scheduler_screen.dart';
import '../features/meetings/presentation/meeting_details_screen.dart';
import '../features/meetings/presentation/meeting_notes_screen.dart';
import '../features/meetings/presentation/meeting_recordings_screen.dart';
import '../features/meetings/presentation/calendar_screen.dart';
import '../features/meetings/presentation/meeting_action_items_screen.dart';
import '../features/meetings/presentation/meeting_decisions_screen.dart';
import '../features/meetings/presentation/meeting_transcript_screen.dart';
import '../features/meetings/presentation/waiting_room_screen.dart';
import '../features/meetings/presentation/breakout_room_screen.dart';
import '../features/meetings/presentation/meeting_analytics_screen.dart';

// Import AI Workspace screens
import '../features/ai_assistant/presentation/ai_home_screen.dart';
import '../features/ai_assistant/presentation/ai_chat_screen.dart';
import '../features/ai_assistant/presentation/ai_search_screen.dart';
import '../features/ai_assistant/presentation/ai_reports_screen.dart';
import '../features/ai_assistant/presentation/ai_automations_screen.dart';
import '../features/ai_assistant/presentation/project_health_screen.dart';
import '../features/ai_assistant/presentation/ai_prompt_registry_screen.dart';
import '../features/ai_assistant/presentation/ai_artifacts_screen.dart';
import '../features/ai_assistant/presentation/ai_artifact_details_screen.dart';
import '../features/ai_assistant/presentation/ai_feedback_screen.dart';
import '../features/ai_assistant/presentation/ai_evaluations_screen.dart';
import '../features/ai_assistant/presentation/ai_learning_dashboard_screen.dart';
import '../features/ai_assistant/presentation/ai_governance_screen.dart';
import '../features/ai_assistant/presentation/ai_model_policy_screen.dart';
import '../features/ai_assistant/presentation/ai_agents_screen.dart';
import '../features/ai_assistant/presentation/ai_workflows_screen.dart';
import '../features/ai_assistant/presentation/ai_pending_actions_screen.dart';
import '../features/ai_assistant/presentation/ai_memory_screen.dart';
import '../features/ai_assistant/presentation/ai_usage_screen.dart';
import '../features/ai_assistant/presentation/ai_budget_screen.dart';

// Import Desktop Power User screens
import '../features/desktop/presentation/command_palette_screen.dart';
import '../features/desktop/presentation/global_search_screen.dart';
import '../features/desktop/presentation/workspace_launcher_screen.dart';
import '../features/desktop/presentation/activity_timeline_screen.dart';
import '../features/desktop/presentation/productivity_analytics_screen.dart';
import '../features/desktop/presentation/desktop_settings_screen.dart';
import '../features/desktop/presentation/shortcuts_screen.dart';
import '../features/desktop/presentation/offline_sync_screen.dart';
import '../features/desktop/presentation/integrations_home_screen.dart';
import '../features/desktop/presentation/integration_details_screen.dart';
import '../features/desktop/presentation/integration_install_screen.dart';
import '../features/desktop/presentation/github_integration_screen.dart';
import '../features/desktop/presentation/gitlab_integration_screen.dart';
import '../features/desktop/presentation/bitbucket_integration_screen.dart';
import '../features/desktop/presentation/google_workspace_screen.dart';
import '../features/desktop/presentation/microsoft365_screen.dart';
import '../features/desktop/presentation/slack_integration_screen.dart';
import '../features/desktop/presentation/teams_integration_screen.dart';
import '../features/desktop/presentation/cicd_integrations_screen.dart';
import '../features/desktop/presentation/cloud_integrations_screen.dart';
import '../features/desktop/presentation/webhooks_screen.dart';
import '../features/desktop/presentation/secret_vault_screen.dart';
import '../features/desktop/presentation/marketplace_screen.dart';
import '../features/desktop/presentation/integration_logs_screen.dart';
import '../features/desktop/presentation/pricing_plans_screen.dart';
import '../features/desktop/presentation/subscription_management_screen.dart';
import '../features/desktop/presentation/usage_billing_screen.dart';
import '../features/desktop/presentation/invoice_history_screen.dart';
import '../features/desktop/presentation/checkout_success_screen.dart';
import '../features/desktop/presentation/checkout_cancel_screen.dart';

// Import Enterprise Admin screens
import '../features/admin/presentation/admin_dashboard_screen.dart';
import '../features/admin/presentation/security_center_screen.dart';
import '../features/admin/presentation/compliance_center_screen.dart';
import '../features/admin/presentation/sso_configuration_screen.dart';
import '../features/admin/presentation/scim_screen.dart';
import '../features/admin/presentation/session_management_screen.dart';
import '../features/admin/presentation/retention_policy_screen.dart';
import '../features/admin/presentation/dlp_policy_screen.dart';
import '../features/admin/presentation/legal_hold_screen.dart';
import '../features/admin/presentation/audit_export_screen.dart';
import '../features/admin/presentation/organization_hierarchy_screen.dart';
import '../features/admin/presentation/department_management_screen.dart';
import '../features/admin/presentation/enterprise_settings_screen.dart';

// Import Phase 16 BI & Portfolio screens
import '../features/bi/presentation/portfolio_dashboard_screen.dart';
import '../features/bi/presentation/program_management_screen.dart';
import '../features/bi/presentation/okr_dashboard_screen.dart';
import '../features/bi/presentation/objective_details_screen.dart';
import '../features/bi/presentation/kpi_builder_screen.dart';
import '../features/bi/presentation/forecast_dashboard_screen.dart';
import '../features/bi/presentation/executive_dashboard_screen.dart';
import '../features/bi/presentation/resource_planning_screen.dart';
import '../features/bi/presentation/capacity_planning_screen.dart';
import '../features/bi/presentation/business_intelligence_screen.dart';
import '../features/bi/presentation/custom_dashboard_screen.dart';
import '../features/bi/presentation/department_analytics_screen.dart';
import '../features/bi/presentation/portfolio_health_screen.dart';

// Import Phase 17 Automation & Dynamic Forms screens
import '../features/automation/presentation/workflow_dashboard_screen.dart';
import '../features/automation/presentation/workflow_builder_screen.dart';
import '../features/automation/presentation/workflow_execution_screen.dart';
import '../features/automation/presentation/workflow_analytics_screen.dart';
import '../features/automation/presentation/forms_builder_screen.dart';
import '../features/automation/presentation/forms_submission_screen.dart';
import '../features/automation/presentation/approval_center_screen.dart';
import '../features/automation/presentation/automation_marketplace_screen.dart';
import '../features/automation/presentation/sla_dashboard_screen.dart';

// Import Phase 18 ERP screens
import '../features/erp/hrms/employee_directory_screen.dart';
import '../features/erp/hrms/attendance_dashboard_screen.dart';
import '../features/erp/hrms/leave_management_screen.dart';
import '../features/erp/hrms/recruitment_pipeline_screen.dart';
import '../features/erp/hrms/payroll_dashboard_screen.dart';
import '../features/erp/crm/crm_dashboard_screen.dart';
import '../features/erp/crm/leads_screen.dart';
import '../features/erp/crm/opportunities_screen.dart';
import '../features/erp/crm/accounts_screen.dart';
import '../features/erp/crm/sales_pipeline_screen.dart';
import '../features/erp/procurement/procurement_dashboard_screen.dart';
import '../features/erp/procurement/vendor_management_screen.dart';
import '../features/erp/procurement/purchase_request_screen.dart';
import '../features/erp/procurement/purchase_order_screen.dart';
import '../features/erp/inventory/inventory_dashboard_screen.dart';
import '../features/erp/inventory/warehouse_screen.dart';
import '../features/erp/inventory/stock_transfer_screen.dart';
import '../features/erp/inventory/inventory_adjustment_screen.dart';
import '../features/erp/assets/assets_dashboard_screen.dart';
import '../features/erp/assets/asset_registry_screen.dart';
import '../features/erp/assets/maintenance_screen.dart';
import '../features/erp/finance/finance_dashboard_screen.dart';
import '../features/erp/finance/expenses_screen.dart';
import '../features/erp/finance/invoices_screen.dart';
import '../features/erp/finance/budget_screen.dart';
import '../features/erp/helpdesk/helpdesk_dashboard_screen.dart';
import '../features/erp/helpdesk/ticket_queue_screen.dart';
import '../features/erp/helpdesk/customer_portal_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/workspace-setup',
      builder: (context, state) => const WorkspaceSetupScreen(),
    ),
    GoRoute(
      path: '/workspaces',
      builder: (context, state) => const WorkspaceSelectionScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/projects',
      builder: (context, state) => const ProjectListScreen(),
    ),
    GoRoute(
      path: '/projects/create',
      builder: (context, state) => const ProjectCreateScreen(),
    ),
    GoRoute(
      path: '/projects/details/:projectId',
      builder: (context, state) {
        final projectId = state.pathParameters['projectId'] ?? '';
        return ProjectDetailsScreen(projectId: projectId);
      },
    ),
    GoRoute(
      path: '/chat',
      builder: (context, state) => const ChatHomeScreen(),
    ),
    GoRoute(
      path: '/chat/search',
      builder: (context, state) => const ChatSearchScreen(),
    ),
    GoRoute(
      path: '/chat/mentions',
      builder: (context, state) => const MentionsScreen(),
    ),
    GoRoute(
      path: '/chat/channel/:channelName',
      builder: (context, state) {
        final channelName = state.pathParameters['channelName'] ?? '';
        return ChannelScreen(channelName: channelName);
      },
    ),
    GoRoute(
      path: '/chat/channel/:channelName/pins',
      builder: (context, state) {
        final channelName = state.pathParameters['channelName'] ?? '';
        return PinnedMessagesScreen(channelName: channelName);
      },
    ),
    GoRoute(
      path: '/chat/dm/:userName',
      builder: (context, state) {
        final userName = state.pathParameters['userName'] ?? '';
        return DmScreen(userName: userName);
      },
    ),
    GoRoute(
      path: '/chat/thread/:messageId',
      builder: (context, state) {
        final messageId = state.pathParameters['messageId'] ?? '';
        return ThreadScreen(messageId: messageId);
      },
    ),
    GoRoute(
      path: '/chat/voice/:huddleId',
      builder: (context, state) {
        final huddleId = state.pathParameters['huddleId'] ?? '';
        return VoiceRoomScreen(huddleId: huddleId);
      },
    ),
    GoRoute(
      path: '/meetings',
      builder: (context, state) => const MeetingHomeScreen(),
    ),
    GoRoute(
      path: '/meetings/room/:meetingId',
      builder: (context, state) {
        final meetingId = state.pathParameters['meetingId'] ?? '';
        return MeetingRoomScreen(meetingId: meetingId);
      },
    ),
    GoRoute(
      path: '/meetings/schedule/new',
      builder: (context, state) => const MeetingSchedulerScreen(),
    ),
    GoRoute(
      path: '/meetings/details/:meetingId',
      builder: (context, state) {
        final meetingId = state.pathParameters['meetingId'] ?? '';
        return MeetingDetailsScreen(meetingId: meetingId);
      },
    ),
    GoRoute(
      path: '/meetings/notes/:meetingId',
      builder: (context, state) {
        final meetingId = state.pathParameters['meetingId'] ?? '';
        return MeetingNotesScreen(meetingId: meetingId);
      },
    ),
    GoRoute(
      path: '/meetings/recordings',
      builder: (context, state) => const MeetingRecordingsScreen(),
    ),
    GoRoute(
      path: '/meetings/calendar',
      builder: (context, state) => const CalendarScreen(),
    ),
    GoRoute(
      path: '/meetings/action-items/:meetingId',
      builder: (context, state) {
        final meetingId = state.pathParameters['meetingId'] ?? '';
        return MeetingActionItemsScreen(meetingId: meetingId);
      },
    ),
    GoRoute(
      path: '/meetings/decisions/:meetingId',
      builder: (context, state) {
        final meetingId = state.pathParameters['meetingId'] ?? '';
        return MeetingDecisionsScreen(meetingId: meetingId);
      },
    ),
    GoRoute(
      path: '/meetings/transcript/:meetingId',
      builder: (context, state) {
        final meetingId = state.pathParameters['meetingId'] ?? '';
        return MeetingTranscriptScreen(meetingId: meetingId);
      },
    ),
    GoRoute(
      path: '/meetings/waiting-room/:meetingId',
      builder: (context, state) {
        final meetingId = state.pathParameters['meetingId'] ?? '';
        return WaitingRoomScreen(meetingId: meetingId);
      },
    ),
    GoRoute(
      path: '/meetings/breakout-rooms/:meetingId',
      builder: (context, state) {
        final meetingId = state.pathParameters['meetingId'] ?? '';
        return BreakoutRoomScreen(meetingId: meetingId);
      },
    ),
    GoRoute(
      path: '/meetings/analytics/:meetingId',
      builder: (context, state) {
        final meetingId = state.pathParameters['meetingId'] ?? '';
        return MeetingAnalyticsScreen(meetingId: meetingId);
      },
    ),
    // AI Workspace Platform routes
    GoRoute(
      path: '/ai',
      builder: (context, state) => const AIHomeScreen(),
    ),
    GoRoute(
      path: '/ai/chat/:conversationId',
      builder: (context, state) {
        final conversationId = state.pathParameters['conversationId'] ?? '';
        return AIChatScreen(conversationId: conversationId);
      },
    ),
    GoRoute(
      path: '/ai/search',
      builder: (context, state) => const AISearchScreen(),
    ),
    GoRoute(
      path: '/ai/reports',
      builder: (context, state) => const AIReportsScreen(),
    ),
    GoRoute(
      path: '/ai/automations',
      builder: (context, state) => const AIAutomationsScreen(),
    ),
    GoRoute(
      path: '/projects/health/:projectId',
      builder: (context, state) {
        final projectId = state.pathParameters['projectId'] ?? '';
        return ProjectHealthScreen(projectId: projectId);
      },
    ),
    GoRoute(
      path: '/ai/agents',
      builder: (context, state) => const AIAgentsScreen(),
    ),
    GoRoute(
      path: '/ai/workflows',
      builder: (context, state) => const AIWorkflowsScreen(),
    ),
    GoRoute(
      path: '/ai/approvals',
      builder: (context, state) => const AIPendingActionsScreen(),
    ),
    GoRoute(
      path: '/ai/memory',
      builder: (context, state) => const AIMemoryScreen(),
    ),
    GoRoute(
      path: '/ai/usage',
      builder: (context, state) => const AIUsageScreen(),
    ),
    GoRoute(
      path: '/ai/budget',
      builder: (context, state) => const AIBudgetScreen(),
    ),
    GoRoute(
      path: '/ai/prompts',
      builder: (context, state) => const AIPromptRegistryScreen(),
    ),
    GoRoute(
      path: '/ai/artifacts',
      builder: (context, state) => const AIArtifactsScreen(),
    ),
    GoRoute(
      path: '/ai/artifact-details/:artifactId',
      builder: (context, state) {
        final artifactId = state.pathParameters['artifactId'] ?? '';
        return AIArtifactDetailsScreen(artifactId: artifactId);
      },
    ),
    GoRoute(
      path: '/ai/feedback',
      builder: (context, state) => const AIFeedbackScreen(),
    ),
    GoRoute(
      path: '/ai/evaluations',
      builder: (context, state) => const AIEvaluationsScreen(),
    ),
    GoRoute(
      path: '/ai/learning-dashboard',
      builder: (context, state) => const AILearningDashboardScreen(),
    ),
    GoRoute(
      path: '/ai/governance',
      builder: (context, state) => const AIGovernanceScreen(),
    ),
    GoRoute(
      path: '/ai/model-policies',
      builder: (context, state) => const AIModelPolicyScreen(),
    ),
    GoRoute(
      path: '/command-palette',
      builder: (context, state) => const CommandPaletteScreen(),
    ),
    GoRoute(
      path: '/global-search',
      builder: (context, state) => const GlobalSearchScreen(),
    ),
    GoRoute(
      path: '/launcher',
      builder: (context, state) => const WorkspaceLauncherScreen(),
    ),
    GoRoute(
      path: '/activity-timeline',
      builder: (context, state) => const ActivityTimelineScreen(),
    ),
    GoRoute(
      path: '/productivity-analytics',
      builder: (context, state) => const ProductivityAnalyticsScreen(),
    ),
    GoRoute(
      path: '/desktop-settings',
      builder: (context, state) => const DesktopSettingsScreen(),
    ),
    GoRoute(
      path: '/shortcuts-config',
      builder: (context, state) => const ShortcutsScreen(),
    ),
    GoRoute(
      path: '/sync-status',
      builder: (context, state) => const OfflineSyncScreen(),
    ),
    GoRoute(
      path: '/integrations',
      builder: (context, state) => const IntegrationsHomeScreen(),
    ),
    GoRoute(
      path: '/integrations/details/:integrationId',
      builder: (context, state) {
        final integrationId = state.pathParameters['integrationId'] ?? '';
        return IntegrationDetailsScreen(integrationId: integrationId);
      },
    ),
    GoRoute(
      path: '/integrations/install/:integrationId',
      builder: (context, state) {
        final integrationId = state.pathParameters['integrationId'] ?? '';
        return IntegrationInstallScreen(integrationId: integrationId);
      },
    ),
    GoRoute(
      path: '/integrations/github',
      builder: (context, state) => const GitHubIntegrationScreen(),
    ),
    GoRoute(
      path: '/integrations/gitlab',
      builder: (context, state) => const GitLabIntegrationScreen(),
    ),
    GoRoute(
      path: '/integrations/bitbucket',
      builder: (context, state) => const BitBucketIntegrationScreen(),
    ),
    GoRoute(
      path: '/integrations/google',
      builder: (context, state) => const GoogleWorkspaceScreen(),
    ),
    GoRoute(
      path: '/integrations/microsoft',
      builder: (context, state) => const Microsoft365Screen(),
    ),
    GoRoute(
      path: '/integrations/slack',
      builder: (context, state) => const SlackIntegrationScreen(),
    ),
    GoRoute(
      path: '/integrations/teams',
      builder: (context, state) => const TeamsIntegrationScreen(),
    ),
    GoRoute(
      path: '/integrations/cicd',
      builder: (context, state) => const CicdIntegrationsScreen(),
    ),
    GoRoute(
      path: '/integrations/cloud',
      builder: (context, state) => const CloudIntegrationsScreen(),
    ),
    GoRoute(
      path: '/integrations/webhooks',
      builder: (context, state) => const WebhooksScreen(),
    ),
    GoRoute(
      path: '/integrations/secret-vault',
      builder: (context, state) => const SecretVaultScreen(),
    ),
    GoRoute(
      path: '/integrations/marketplace',
      builder: (context, state) => const MarketplaceScreen(),
    ),
    GoRoute(
      path: '/integrations/logs',
      builder: (context, state) => const IntegrationLogsScreen(),
    ),
    GoRoute(
      path: '/billing/plans',
      builder: (context, state) => const PricingPlansScreen(),
    ),
    GoRoute(
      path: '/billing/subscription',
      builder: (context, state) => const SubscriptionManagementScreen(),
    ),
    GoRoute(
      path: '/billing/usage',
      builder: (context, state) => const UsageBillingScreen(),
    ),
    GoRoute(
      path: '/billing/invoices',
      builder: (context, state) => const InvoiceHistoryScreen(),
    ),
    GoRoute(
      path: '/billing/success',
      builder: (context, state) => const CheckoutSuccessScreen(),
    ),
    GoRoute(
      path: '/billing/cancel',
      builder: (context, state) => const CheckoutCancelScreen(),
    ),
    GoRoute(
      path: '/admin',
      builder: (context, state) => const AdminDashboardScreen(),
    ),
    GoRoute(
      path: '/admin/security',
      builder: (context, state) => const SecurityCenterScreen(),
    ),
    GoRoute(
      path: '/admin/compliance',
      builder: (context, state) => const ComplianceCenterScreen(),
    ),
    GoRoute(
      path: '/admin/sso',
      builder: (context, state) => const SsoConfigurationScreen(),
    ),
    GoRoute(
      path: '/admin/scim',
      builder: (context, state) => const ScimScreen(),
    ),
    GoRoute(
      path: '/admin/sessions',
      builder: (context, state) => const SessionManagementScreen(),
    ),
    GoRoute(
      path: '/admin/retention',
      builder: (context, state) => const RetentionPolicyScreen(),
    ),
    GoRoute(
      path: '/admin/dlp',
      builder: (context, state) => const DlpPolicyScreen(),
    ),
    GoRoute(
      path: '/admin/legal-hold',
      builder: (context, state) => const LegalHoldScreen(),
    ),
    GoRoute(
      path: '/admin/audit',
      builder: (context, state) => const AuditExportScreen(),
    ),
    GoRoute(
      path: '/admin/organization',
      builder: (context, state) => const OrganizationHierarchyScreen(),
    ),
    GoRoute(
      path: '/admin/organization/departments',
      builder: (context, state) => const DepartmentManagementScreen(),
    ),
    GoRoute(
      path: '/admin/settings',
      builder: (context, state) => const EnterpriseSettingsScreen(),
    ),
    GoRoute(
      path: '/portfolio',
      builder: (context, state) => const PortfolioDashboardScreen(),
    ),
    GoRoute(
      path: '/portfolio/health',
      builder: (context, state) => const PortfolioHealthScreen(),
    ),
    GoRoute(
      path: '/programs',
      builder: (context, state) => const ProgramManagementScreen(),
    ),
    GoRoute(
      path: '/okr',
      builder: (context, state) => const OKRDashboardScreen(),
    ),
    GoRoute(
      path: '/okr/objectives/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return ObjectiveDetailsScreen(objectiveId: id);
      },
    ),
    GoRoute(
      path: '/kpis',
      builder: (context, state) => const KPIBuilderScreen(),
    ),
    GoRoute(
      path: '/forecasts',
      builder: (context, state) => const ForecastDashboardScreen(),
    ),
    GoRoute(
      path: '/executive',
      builder: (context, state) => const ExecutiveDashboardScreen(),
    ),
    GoRoute(
      path: '/resources',
      builder: (context, state) => const ResourcePlanningScreen(),
    ),
    GoRoute(
      path: '/resources/capacity',
      builder: (context, state) => const CapacityPlanningScreen(),
    ),
    GoRoute(
      path: '/business-intelligence',
      builder: (context, state) => const BusinessIntelligenceScreen(),
    ),
    GoRoute(
      path: '/business-intelligence/departments',
      builder: (context, state) => const DepartmentAnalyticsScreen(),
    ),
    GoRoute(
      path: '/dashboards',
      builder: (context, state) => const CustomDashboardScreen(),
    ),
    GoRoute(
      path: '/workflows',
      builder: (context, state) => const WorkflowDashboardScreen(),
    ),
    GoRoute(
      path: '/workflows/builder',
      builder: (context, state) => const WorkflowBuilderScreen(),
    ),
    GoRoute(
      path: '/workflows/executions',
      builder: (context, state) => const WorkflowExecutionScreen(),
    ),
    GoRoute(
      path: '/workflows/analytics',
      builder: (context, state) => const WorkflowAnalyticsScreen(),
    ),
    GoRoute(
      path: '/workflows/marketplace',
      builder: (context, state) => const AutomationMarketplaceScreen(),
    ),
    GoRoute(
      path: '/forms',
      builder: (context, state) => const FormsSubmissionScreen(),
    ),
    GoRoute(
      path: '/forms/builder',
      builder: (context, state) => const FormsBuilderScreen(),
    ),
    GoRoute(
      path: '/forms/submissions',
      builder: (context, state) => const FormsSubmissionScreen(),
    ),
    GoRoute(
      path: '/approvals',
      builder: (context, state) => const ApprovalCenterScreen(),
    ),
    GoRoute(
      path: '/sla-dashboard',
      builder: (context, state) => const SLADashboardScreen(),
    ),
    GoRoute(
      path: '/hrms/employees',
      builder: (context, state) => const EmployeeDirectoryScreen(),
    ),
    GoRoute(
      path: '/hrms/attendance',
      builder: (context, state) => const AttendanceDashboardScreen(),
    ),
    GoRoute(
      path: '/hrms/leaves',
      builder: (context, state) => const LeaveManagementScreen(),
    ),
    GoRoute(
      path: '/hrms/recruitment',
      builder: (context, state) => const RecruitmentPipelineScreen(),
    ),
    GoRoute(
      path: '/hrms/payroll',
      builder: (context, state) => const PayrollDashboardScreen(),
    ),
    GoRoute(
      path: '/crm',
      builder: (context, state) => const CrmDashboardScreen(),
    ),
    GoRoute(
      path: '/crm/leads',
      builder: (context, state) => const LeadsScreen(),
    ),
    GoRoute(
      path: '/crm/opportunities',
      builder: (context, state) => const OpportunitiesScreen(),
    ),
    GoRoute(
      path: '/crm/accounts',
      builder: (context, state) => const AccountsScreen(),
    ),
    GoRoute(
      path: '/crm/pipeline',
      builder: (context, state) => const SalesPipelineScreen(),
    ),
    GoRoute(
      path: '/procurement',
      builder: (context, state) => const ProcurementDashboardScreen(),
    ),
    GoRoute(
      path: '/procurement/vendors',
      builder: (context, state) => const VendorManagementScreen(),
    ),
    GoRoute(
      path: '/procurement/requests',
      builder: (context, state) => const PurchaseRequestScreen(),
    ),
    GoRoute(
      path: '/procurement/orders',
      builder: (context, state) => const PurchaseOrderScreen(),
    ),
    GoRoute(
      path: '/inventory',
      builder: (context, state) => const InventoryDashboardScreen(),
    ),
    GoRoute(
      path: '/inventory/warehouses',
      builder: (context, state) => const WarehouseScreen(),
    ),
    GoRoute(
      path: '/inventory/transfers',
      builder: (context, state) => const StockTransferScreen(),
    ),
    GoRoute(
      path: '/inventory/adjustments',
      builder: (context, state) => const InventoryAdjustmentScreen(),
    ),
    GoRoute(
      path: '/assets',
      builder: (context, state) => const AssetsDashboardScreen(),
    ),
    GoRoute(
      path: '/assets/registry',
      builder: (context, state) => const AssetRegistryScreen(),
    ),
    GoRoute(
      path: '/assets/maintenance',
      builder: (context, state) => const MaintenanceScreen(),
    ),
    GoRoute(
      path: '/finance',
      builder: (context, state) => const FinanceDashboardScreen(),
    ),
    GoRoute(
      path: '/finance/expenses',
      builder: (context, state) => const ExpensesScreen(),
    ),
    GoRoute(
      path: '/finance/invoices',
      builder: (context, state) => const InvoicesScreen(),
    ),
    GoRoute(
      path: '/finance/budget',
      builder: (context, state) => const BudgetScreen(),
    ),
    GoRoute(
      path: '/helpdesk',
      builder: (context, state) => const HelpdeskDashboardScreen(),
    ),
    GoRoute(
      path: '/helpdesk/queue',
      builder: (context, state) => const TicketQueueScreen(),
    ),
    GoRoute(
      path: '/helpdesk/portal',
      builder: (context, state) => const CustomerPortalScreen(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(child: Text('Page not found: ${state.uri}')),
  ),
);
