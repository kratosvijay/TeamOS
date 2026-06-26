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


// Phase 20 Developer Portal screens
import '../features/developer/presentation/api_keys_screen.dart';
import '../features/developer/presentation/api_usage_screen.dart';
import '../features/developer/presentation/cli_download_screen.dart';
import '../features/developer/presentation/developer_analytics_screen.dart';
import '../features/developer/presentation/developer_portal_screen.dart';
import '../features/developer/presentation/event_bus_screen.dart';
import '../features/developer/presentation/extension_details_screen.dart';
import '../features/developer/presentation/extension_store_screen.dart';
import '../features/developer/presentation/extensions_screen.dart';
import '../features/developer/presentation/graphql_explorer_screen.dart';
import '../features/developer/presentation/marketplace_review_screen.dart';
import '../features/developer/presentation/oauth_apps_screen.dart';
import '../features/developer/presentation/sdk_documentation_screen.dart';
import '../features/developer/presentation/webhook_console_screen.dart';
import '../features/developer/presentation/widget_builder_screen.dart';

// Phase 21 DevOps screens
import '../features/devops/presentation/devops_screens.dart';
import '../features/devops/presentation/infrastructure_dashboard_screen.dart';

// Phase 22 Enterprise AI Platform screens
import '../features/ai/presentation/agent_analytics_screen.dart';
import '../features/ai/presentation/agent_builder_screen.dart';
import '../features/ai/presentation/agent_debugger_screen.dart';
import '../features/ai/presentation/agent_execution_screen.dart';
import '../features/ai/presentation/agent_marketplace_screen.dart';
import '../features/ai/presentation/agent_memory_screen.dart';
import '../features/ai/presentation/agent_monitor_screen.dart';
import '../features/ai/presentation/agent_observability_screen.dart';
import '../features/ai/presentation/agent_skills_screen.dart';
import '../features/ai/presentation/ai_governance_screen.dart';
import '../features/ai/presentation/ai_home_screen.dart';
import '../features/ai/presentation/ai_policy_screen.dart';
import '../features/ai/presentation/conversation_history_screen.dart';
import '../features/ai/presentation/datasets_screen.dart';
import '../features/ai/presentation/devops_ai_screen.dart';
import '../features/ai/presentation/document_ai_screen.dart';
import '../features/ai/presentation/executive_ai_screen.dart';
import '../features/ai/presentation/experiments_screen.dart';
import '../features/ai/presentation/finance_ai_screen.dart';
import '../features/ai/presentation/hr_ai_screen.dart';
import '../features/ai/presentation/knowledge_graph_screen.dart';
import '../features/ai/presentation/knowledge_sources_screen.dart';
import '../features/ai/presentation/meeting_ai_screen.dart';
import '../features/ai/presentation/memory_explorer_screen.dart';
import '../features/ai/presentation/project_ai_screen.dart';
import '../features/ai/presentation/prompt_evaluation_screen.dart';
import '../features/ai/presentation/prompt_studio_screen.dart';
import '../features/ai/presentation/rag_pipeline_screen.dart';
import '../features/ai/presentation/sales_ai_screen.dart';
import '../features/ai/presentation/security_ai_screen.dart';
import '../features/ai/presentation/semantic_search_screen.dart';
import '../features/ai/presentation/tool_registry_screen.dart';
import '../features/ai/presentation/workflow_ai_screen.dart';

// Phase 23 Digital Twin & Decision Intelligence screens
import '../features/digital_twin/presentation/bottleneck_analysis_screen.dart';
import '../features/digital_twin/presentation/business_process_map_screen.dart';
import '../features/digital_twin/presentation/capacity_optimization_screen.dart';
import '../features/digital_twin/presentation/confidence_calibration_screen.dart';
import '../features/digital_twin/presentation/decision_history_screen.dart';
import '../features/digital_twin/presentation/digital_twin_dashboard_screen.dart';
import '../features/digital_twin/presentation/enterprise_health_screen.dart';
import '../features/digital_twin/presentation/enterprise_map_screen.dart';
import '../features/digital_twin/presentation/enterprise_maturity_screen.dart';
import '../features/digital_twin/presentation/enterprise_metrics_screen.dart';
import '../features/digital_twin/presentation/enterprise_overview_screen.dart';
import '../features/digital_twin/presentation/enterprise_time_machine_screen.dart';
import '../features/digital_twin/presentation/event_replay_screen.dart';
import '../features/digital_twin/presentation/event_stream_screen.dart';
import '../features/digital_twin/presentation/executive_briefing_screen.dart';
import '../features/digital_twin/presentation/executive_decision_center_screen.dart';
import '../features/digital_twin/presentation/executive_scorecard_screen.dart';
import '../features/digital_twin/presentation/initiative_dependencies_screen.dart';
import '../features/digital_twin/presentation/investment_planning_screen.dart';
import '../features/digital_twin/presentation/kpi_dependency_graph_screen.dart';
import '../features/digital_twin/presentation/optimization_constraints_screen.dart';
import '../features/digital_twin/presentation/optimization_dashboard_screen.dart';
import '../features/digital_twin/presentation/optimization_marketplace_screen.dart';
import '../features/digital_twin/presentation/organization_simulator_screen.dart';
import '../features/digital_twin/presentation/prediction_dashboard_screen.dart';
import '../features/digital_twin/presentation/process_benchmark_screen.dart';
import '../features/digital_twin/presentation/process_mining_screen.dart';
import '../features/digital_twin/presentation/process_variants_screen.dart';
import '../features/digital_twin/presentation/recommendation_approval_screen.dart';
import '../features/digital_twin/presentation/recommendation_center_screen.dart';
import '../features/digital_twin/presentation/risk_heatmap_screen.dart';
import '../features/digital_twin/presentation/root_cause_screen.dart';
import '../features/digital_twin/presentation/scenario_branching_screen.dart';
import '../features/digital_twin/presentation/scenario_comparison_screen.dart';
import '../features/digital_twin/presentation/simulation_builder_screen.dart';
import '../features/digital_twin/presentation/simulation_dashboard_screen.dart';
import '../features/digital_twin/presentation/simulation_replay_screen.dart';
import '../features/digital_twin/presentation/simulation_results_screen.dart';
import '../features/digital_twin/presentation/simulation_templates_screen.dart';
import '../features/digital_twin/presentation/sla_analysis_screen.dart';
import '../features/digital_twin/presentation/strategic_initiatives_screen.dart';
import '../features/digital_twin/presentation/strategy_map_screen.dart';
import '../features/digital_twin/presentation/value_stream_screen.dart';

// Phase 24 Enterprise Data Platform screens
import '../features/data_platform/presentation/ai_auto_lineage_screen.dart';
import '../features/data_platform/presentation/ai_data_mapping_screen.dart';
import '../features/data_platform/presentation/ai_steward_assistant_screen.dart';
import '../features/data_platform/presentation/business_glossary_screen.dart';
import '../features/data_platform/presentation/cdc_registry_screen.dart';
import '../features/data_platform/presentation/classification_screen.dart';
import '../features/data_platform/presentation/connection_manager_screen.dart';
import '../features/data_platform/presentation/connector_marketplace_screen.dart';
import '../features/data_platform/presentation/consumer_groups_screen.dart';
import '../features/data_platform/presentation/contract_testing_screen.dart';
import '../features/data_platform/presentation/data_api_developer_portal_screen.dart';
import '../features/data_platform/presentation/data_catalog_screen.dart';
import '../features/data_platform/presentation/data_contracts_screen.dart';
import '../features/data_platform/presentation/data_federation_explorer_screen.dart';
import '../features/data_platform/presentation/data_finops_dashboard_screen.dart';
import '../features/data_platform/presentation/data_health_score_screen.dart';
import '../features/data_platform/presentation/data_lineage_screen.dart';
import '../features/data_platform/presentation/data_marketplace_screen.dart';
import '../features/data_platform/presentation/data_mesh_screen.dart';
import '../features/data_platform/presentation/data_observability_screen.dart';
import '../features/data_platform/presentation/data_privacy_screen.dart';
import '../features/data_platform/presentation/data_products_screen.dart';
import '../features/data_platform/presentation/data_quality_ai_screen.dart';
import '../features/data_platform/presentation/data_quality_screen.dart';
import '../features/data_platform/presentation/data_reliability_scorecard_screen.dart';
import '../features/data_platform/presentation/data_search_explorer_screen.dart';
import '../features/data_platform/presentation/data_stewardship_screen.dart';
import '../features/data_platform/presentation/dataset_registry_screen.dart';
import '../features/data_platform/presentation/dataset_sla_manager_screen.dart';
import '../features/data_platform/presentation/dataset_versions_screen.dart';
import '../features/data_platform/presentation/duplicate_resolution_screen.dart';
import '../features/data_platform/presentation/enterprise_data_overview_screen.dart';
import '../features/data_platform/presentation/entity_merge_screen.dart';
import '../features/data_platform/presentation/etl_dashboard_screen.dart';
import '../features/data_platform/presentation/event_stream_screen.dart';
import '../features/data_platform/presentation/feature_store_screen.dart';
import '../features/data_platform/presentation/golden_records_screen.dart';
import '../features/data_platform/presentation/governance_scorecard_screen.dart';
import '../features/data_platform/presentation/integration_analytics_screen.dart';
import '../features/data_platform/presentation/integration_dashboard_screen.dart';
import '../features/data_platform/presentation/integration_logs_screen.dart';
import '../features/data_platform/presentation/integration_recommendations_screen.dart';
import '../features/data_platform/presentation/integration_sandbox_screen.dart';
import '../features/data_platform/presentation/lakehouse_explorer_screen.dart';
import '../features/data_platform/presentation/master_data_dashboard_screen.dart';
import '../features/data_platform/presentation/metadata_discovery_screen.dart';
import '../features/data_platform/presentation/metadata_explorer_screen.dart';
import '../features/data_platform/presentation/pipeline_builder_screen.dart';
import '../features/data_platform/presentation/pipeline_execution_screen.dart';
import '../features/data_platform/presentation/pipeline_optimizer_screen.dart';
import '../features/data_platform/presentation/pipeline_templates_screen.dart';
import '../features/data_platform/presentation/platform_data_settings_screen.dart';
import '../features/data_platform/presentation/platform_sla_screen.dart';
import '../features/data_platform/presentation/query_planner_screen.dart';
import '../features/data_platform/presentation/reconciliation_center_screen.dart';
import '../features/data_platform/presentation/relationship_graph_screen.dart';
import '../features/data_platform/presentation/replay_center_screen.dart';
import '../features/data_platform/presentation/retention_policies_screen.dart';
import '../features/data_platform/presentation/reverse_etl_screen.dart';
import '../features/data_platform/presentation/schema_drift_screen.dart';
import '../features/data_platform/presentation/semantic_layer_screen.dart';
import '../features/data_platform/presentation/sharing_agreements_screen.dart';
import '../features/data_platform/presentation/stream_dashboard_screen.dart';
import '../features/data_platform/presentation/sync_jobs_screen.dart';
import '../features/data_platform/presentation/topic_manager_screen.dart';
import '../features/data_platform/presentation/transformation_rules_screen.dart';
import '../features/data_platform/presentation/universal_search_index_screen.dart';
import '../features/data_platform/presentation/usage_analytics_screen.dart';
import '../features/data_platform/presentation/webhook_manager_screen.dart';

// Phase 25 Low-Code Studio screens
import '../features/studio/presentation/ai_application_builder_screen.dart';
import '../features/studio/presentation/api_designer_screen.dart';
import '../features/studio/presentation/application_analytics_screen.dart';
import '../features/studio/presentation/application_details_screen.dart';
import '../features/studio/presentation/application_packages_screen.dart';
import '../features/studio/presentation/application_reviews_screen.dart';
import '../features/studio/presentation/application_store_screen.dart';
import '../features/studio/presentation/application_versions_screen.dart';
import '../features/studio/presentation/applications_screen.dart';
import '../features/studio/presentation/branding_screen.dart';
import '../features/studio/presentation/component_designer_screen.dart';
import '../features/studio/presentation/component_library_screen.dart';
import '../features/studio/presentation/custom_widget_screen.dart';
import '../features/studio/presentation/dashboard_builder_screen.dart';
import '../features/studio/presentation/dashboard_generator_screen.dart';
import '../features/studio/presentation/datasource_screen.dart';
import '../features/studio/presentation/deployment_center_screen.dart';
import '../features/studio/presentation/entity_designer_screen.dart';
import '../features/studio/presentation/expression_builder_screen.dart';
import '../features/studio/presentation/form_builder_screen.dart';
import '../features/studio/presentation/formula_builder_screen.dart';
import '../features/studio/presentation/git_branches_screen.dart';
import '../features/studio/presentation/graphql_designer_screen.dart';
import '../features/studio/presentation/layout_designer_screen.dart';
import '../features/studio/presentation/live_preview_screen.dart';
import '../features/studio/presentation/localization_screen.dart';
import '../features/studio/presentation/metadata_diff_screen.dart';
import '../features/studio/presentation/metadata_editor_screen.dart';
import '../features/studio/presentation/metadata_history_screen.dart';
import '../features/studio/presentation/metadata_viewer_screen.dart';
import '../features/studio/presentation/navigation_designer_screen.dart';
import '../features/studio/presentation/package_manager_screen.dart';
import '../features/studio/presentation/page_designer_screen.dart';
import '../features/studio/presentation/performance_dashboard_screen.dart';
import '../features/studio/presentation/permissions_designer_screen.dart';
import '../features/studio/presentation/plugin_bindings_screen.dart';
import '../features/studio/presentation/prompt_to_app_screen.dart';
import '../features/studio/presentation/publish_application_screen.dart';
import '../features/studio/presentation/query_builder_screen.dart';
import '../features/studio/presentation/relationship_designer_screen.dart';
import '../features/studio/presentation/release_manager_screen.dart';
import '../features/studio/presentation/rule_designer_screen.dart';
import '../features/studio/presentation/runtime_debugger_screen.dart';
import '../features/studio/presentation/runtime_monitor_screen.dart';
import '../features/studio/presentation/studio_dashboard_screen.dart';
import '../features/studio/presentation/studio_settings_screen.dart';
import '../features/studio/presentation/test_runner_screen.dart';
import '../features/studio/presentation/theme_designer_screen.dart';
import '../features/studio/presentation/theme_gallery_screen.dart';
import '../features/studio/presentation/usage_dashboard_screen.dart';
import '../features/studio/presentation/validation_center_screen.dart';
import '../features/studio/presentation/workflow_designer_screen.dart';

// Phase 26 Integration & iPaaS screens
import '../features/integration/presentation/api_analytics_screen.dart';
import '../features/integration/presentation/api_consumers_screen.dart';
import '../features/integration/presentation/api_gateway_screen.dart';
import '../features/integration/presentation/api_keys_screen.dart';
import '../features/integration/presentation/api_products_screen.dart';
import '../features/integration/presentation/api_usage_screen.dart';
import '../features/integration/presentation/as2_configuration_screen.dart';
import '../features/integration/presentation/automation_assets_screen.dart';
import '../features/integration/presentation/bot_builder_screen.dart';
import '../features/integration/presentation/browser_automation_screen.dart';
import '../features/integration/presentation/connector_details_screen.dart';
import '../features/integration/presentation/connector_health_screen.dart';
import '../features/integration/presentation/connector_logs_screen.dart';
import '../features/integration/presentation/connector_marketplace_screen.dart';
import '../features/integration/presentation/connector_usage_screen.dart';
import '../features/integration/presentation/dead_letter_queue_screen.dart';
import '../features/integration/presentation/desktop_automation_screen.dart';
import '../features/integration/presentation/document_classification_screen.dart';
import '../features/integration/presentation/document_templates_screen.dart';
import '../features/integration/presentation/edi_batches_screen.dart';
import '../features/integration/presentation/edi_messages_screen.dart';
import '../features/integration/presentation/event_consumers_screen.dart';
import '../features/integration/presentation/event_messages_screen.dart';
import '../features/integration/presentation/event_replay_screen.dart';
import '../features/integration/presentation/event_topics_screen.dart';
import '../features/integration/presentation/flow_builder_screen.dart';
import '../features/integration/presentation/flow_debugger_screen.dart';
import '../features/integration/presentation/flow_designer_screen.dart';
import '../features/integration/presentation/flow_execution_screen.dart';
import '../features/integration/presentation/flow_history_screen.dart';
import '../features/integration/presentation/flow_templates_screen.dart';
import '../features/integration/presentation/installed_connectors_screen.dart';
import '../features/integration/presentation/integration_ai_screen.dart';
import '../features/integration/presentation/integration_analytics_screen.dart';
import '../features/integration/presentation/integration_cost_screen.dart';
import '../features/integration/presentation/integration_dashboard_screen.dart';
import '../features/integration/presentation/integration_performance_screen.dart';
import '../features/integration/presentation/integration_settings_screen.dart';
import '../features/integration/presentation/invoice_parser_screen.dart';
import '../features/integration/presentation/mapping_designer_screen.dart';
import '../features/integration/presentation/ocr_dashboard_screen.dart';
import '../features/integration/presentation/partner_connections_screen.dart';
import '../features/integration/presentation/partners_screen.dart';
import '../features/integration/presentation/pipeline_builder_screen.dart';
import '../features/integration/presentation/pipeline_dashboard_screen.dart';
import '../features/integration/presentation/pipeline_runs_screen.dart';
import '../features/integration/presentation/receipt_parser_screen.dart';
import '../features/integration/presentation/rpa_dashboard_screen.dart';
import '../features/integration/presentation/sync_analytics_screen.dart';
import '../features/integration/presentation/sync_conflicts_screen.dart';
import '../features/integration/presentation/sync_dashboard_screen.dart';
import '../features/integration/presentation/sync_jobs_screen.dart';
import '../features/integration/presentation/sync_resolution_screen.dart';
import '../features/integration/presentation/transformation_designer_screen.dart';
import '../features/integration/presentation/validation_rules_screen.dart';

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

    // Phase 20 Developer Portal routes
    GoRoute(
      path: '/developer/api-keys',
      builder: (context, state) => const ApiKeysScreen(),
    ),
    GoRoute(
      path: '/developer/api-usage',
      builder: (context, state) => const ApiUsageScreen(),
    ),
    GoRoute(
      path: '/developer/cli-download',
      builder: (context, state) => const CliDownloadScreen(),
    ),
    GoRoute(
      path: '/developer/developer-analytics',
      builder: (context, state) => const DeveloperAnalyticsScreen(),
    ),
    GoRoute(
      path: '/developer/developer-portal',
      builder: (context, state) => const DeveloperPortalScreen(),
    ),
    GoRoute(
      path: '/developer/event-bus',
      builder: (context, state) => const EventBusScreen(),
    ),
    GoRoute(
      path: '/developer/extension-details/:extensionId',
      builder: (context, state) => ExtensionDetailsScreen(
        extensionId: state.pathParameters['extensionId'] ?? '',
      ),
    ),
    GoRoute(
      path: '/developer/extension-store',
      builder: (context, state) => const ExtensionStoreScreen(),
    ),
    GoRoute(
      path: '/developer/extensions',
      builder: (context, state) => const ExtensionsScreen(),
    ),
    GoRoute(
      path: '/developer/graphql-explorer',
      builder: (context, state) => const GraphqlExplorerScreen(),
    ),
    GoRoute(
      path: '/developer/marketplace-review',
      builder: (context, state) => const MarketplaceReviewScreen(),
    ),
    GoRoute(
      path: '/developer/oauth-apps',
      builder: (context, state) => const OauthAppsScreen(),
    ),
    GoRoute(
      path: '/developer/sdk-documentation',
      builder: (context, state) => const SdkDocumentationScreen(),
    ),
    GoRoute(
      path: '/developer/webhook-console',
      builder: (context, state) => const WebhookConsoleScreen(),
    ),
    GoRoute(
      path: '/developer/widget-builder',
      builder: (context, state) => const WidgetBuilderScreen(),
    ),

    // Phase 21 DevOps routes
    GoRoute(
      path: '/devops/home',
      builder: (context, state) => const DevopsBaseScaffold(
        title: 'DevOps',
        body: SizedBox.shrink(),
      ),
    ),
    GoRoute(
      path: '/devops/infrastructure-dashboard',
      builder: (context, state) => const InfrastructureDashboardScreen(),
    ),

    // Phase 22 Enterprise AI Platform routes
    GoRoute(
      path: '/ai-platform/agent-analytics',
      builder: (context, state) => const EnterpriseAgentAnalyticsScreen(),
    ),
    GoRoute(
      path: '/ai-platform/agent-builder',
      builder: (context, state) => const EnterpriseAgentBuilderScreen(),
    ),
    GoRoute(
      path: '/ai-platform/agent-debugger',
      builder: (context, state) => const EnterpriseAgentDebuggerScreen(),
    ),
    GoRoute(
      path: '/ai-platform/agent-execution',
      builder: (context, state) => const EnterpriseAgentExecutionScreen(),
    ),
    GoRoute(
      path: '/ai-platform/agent-marketplace',
      builder: (context, state) => const EnterpriseAgentMarketplaceScreen(),
    ),
    GoRoute(
      path: '/ai-platform/agent-memory',
      builder: (context, state) => const EnterpriseAgentMemoryScreen(),
    ),
    GoRoute(
      path: '/ai-platform/agent-monitor',
      builder: (context, state) => const EnterpriseAgentMonitorScreen(),
    ),
    GoRoute(
      path: '/ai-platform/agent-observability',
      builder: (context, state) => const EnterpriseAgentObservabilityScreen(),
    ),
    GoRoute(
      path: '/ai-platform/agent-skills',
      builder: (context, state) => const EnterpriseAgentSkillsScreen(),
    ),
    GoRoute(
      path: '/ai-platform/ai-governance',
      builder: (context, state) => const EnterpriseAIGovernanceScreen(),
    ),
    GoRoute(
      path: '/ai-platform/ai-home',
      builder: (context, state) => const EnterpriseAIHomeScreen(),
    ),
    GoRoute(
      path: '/ai-platform/ai-policy',
      builder: (context, state) => const EnterpriseAIPolicyScreen(),
    ),
    GoRoute(
      path: '/ai-platform/conversation-history',
      builder: (context, state) => const EnterpriseConversationHistoryScreen(),
    ),
    GoRoute(
      path: '/ai-platform/datasets',
      builder: (context, state) => const EnterpriseDatasetsScreen(),
    ),
    GoRoute(
      path: '/ai-platform/devops-ai',
      builder: (context, state) => const EnterpriseDevOpsAIScreen(),
    ),
    GoRoute(
      path: '/ai-platform/document-ai',
      builder: (context, state) => const EnterpriseDocumentAIScreen(),
    ),
    GoRoute(
      path: '/ai-platform/executive-ai',
      builder: (context, state) => const EnterpriseExecutiveAIScreen(),
    ),
    GoRoute(
      path: '/ai-platform/experiments',
      builder: (context, state) => const EnterpriseExperimentsScreen(),
    ),
    GoRoute(
      path: '/ai-platform/finance-ai',
      builder: (context, state) => const EnterpriseFinanceAIScreen(),
    ),
    GoRoute(
      path: '/ai-platform/hr-ai',
      builder: (context, state) => const EnterpriseHRAIScreen(),
    ),
    GoRoute(
      path: '/ai-platform/knowledge-graph',
      builder: (context, state) => const EnterpriseKnowledgeGraphScreen(),
    ),
    GoRoute(
      path: '/ai-platform/knowledge-sources',
      builder: (context, state) => const EnterpriseKnowledgeSourcesScreen(),
    ),
    GoRoute(
      path: '/ai-platform/meeting-ai',
      builder: (context, state) => const EnterpriseMeetingAIScreen(),
    ),
    GoRoute(
      path: '/ai-platform/memory-explorer',
      builder: (context, state) => const EnterpriseMemoryExplorerScreen(),
    ),
    GoRoute(
      path: '/ai-platform/project-ai',
      builder: (context, state) => const EnterpriseProjectAIScreen(),
    ),
    GoRoute(
      path: '/ai-platform/prompt-evaluation',
      builder: (context, state) => const EnterprisePromptEvaluationScreen(),
    ),
    GoRoute(
      path: '/ai-platform/prompt-studio',
      builder: (context, state) => const EnterprisePromptStudioScreen(),
    ),
    GoRoute(
      path: '/ai-platform/rag-pipeline',
      builder: (context, state) => const EnterpriseRAGPipelineScreen(),
    ),
    GoRoute(
      path: '/ai-platform/sales-ai',
      builder: (context, state) => const EnterpriseSalesAIScreen(),
    ),
    GoRoute(
      path: '/ai-platform/security-ai',
      builder: (context, state) => const EnterpriseSecurityAIScreen(),
    ),
    GoRoute(
      path: '/ai-platform/semantic-search',
      builder: (context, state) => const EnterpriseSemanticSearchScreen(),
    ),
    GoRoute(
      path: '/ai-platform/tool-registry',
      builder: (context, state) => const EnterpriseToolRegistryScreen(),
    ),
    GoRoute(
      path: '/ai-platform/workflow-ai',
      builder: (context, state) => const EnterpriseWorkflowAIScreen(),
    ),

    // Phase 23 Digital Twin & Decision Intelligence routes
    GoRoute(
      path: '/digital-twin/bottleneck-analysis',
      builder: (context, state) => const BottleneckAnalysisScreen(),
    ),
    GoRoute(
      path: '/digital-twin/business-process-map',
      builder: (context, state) => const BusinessProcessMapScreen(),
    ),
    GoRoute(
      path: '/digital-twin/capacity-optimization',
      builder: (context, state) => const CapacityOptimizationScreen(),
    ),
    GoRoute(
      path: '/digital-twin/confidence-calibration',
      builder: (context, state) => const ConfidenceCalibrationScreen(),
    ),
    GoRoute(
      path: '/digital-twin/decision-history',
      builder: (context, state) => const DecisionHistoryScreen(),
    ),
    GoRoute(
      path: '/digital-twin/digital-twin-dashboard',
      builder: (context, state) => const DigitalTwinDashboardScreen(),
    ),
    GoRoute(
      path: '/digital-twin/enterprise-health',
      builder: (context, state) => const EnterpriseHealthScreen(),
    ),
    GoRoute(
      path: '/digital-twin/enterprise-map',
      builder: (context, state) => const EnterpriseMapScreen(),
    ),
    GoRoute(
      path: '/digital-twin/enterprise-maturity',
      builder: (context, state) => const EnterpriseMaturityScreen(),
    ),
    GoRoute(
      path: '/digital-twin/enterprise-metrics',
      builder: (context, state) => const EnterpriseMetricsScreen(),
    ),
    GoRoute(
      path: '/digital-twin/enterprise-overview',
      builder: (context, state) => const EnterpriseOverviewScreen(),
    ),
    GoRoute(
      path: '/digital-twin/enterprise-time-machine',
      builder: (context, state) => const EnterpriseTimeMachineScreen(),
    ),
    GoRoute(
      path: '/digital-twin/event-replay',
      builder: (context, state) => const EventReplayScreen(),
    ),
    GoRoute(
      path: '/digital-twin/event-stream',
      builder: (context, state) => const EventStreamScreen(),
    ),
    GoRoute(
      path: '/digital-twin/executive-briefing',
      builder: (context, state) => const ExecutiveBriefingScreen(),
    ),
    GoRoute(
      path: '/digital-twin/executive-decision-center',
      builder: (context, state) => const ExecutiveDecisionCenterScreen(),
    ),
    GoRoute(
      path: '/digital-twin/executive-scorecard',
      builder: (context, state) => const ExecutiveScorecardScreen(),
    ),
    GoRoute(
      path: '/digital-twin/initiative-dependencies',
      builder: (context, state) => const InitiativeDependenciesScreen(),
    ),
    GoRoute(
      path: '/digital-twin/investment-planning',
      builder: (context, state) => const InvestmentPlanningScreen(),
    ),
    GoRoute(
      path: '/digital-twin/kpi-dependency-graph',
      builder: (context, state) => const KpiDependencyGraphScreen(),
    ),
    GoRoute(
      path: '/digital-twin/optimization-constraints',
      builder: (context, state) => const OptimizationConstraintsScreen(),
    ),
    GoRoute(
      path: '/digital-twin/optimization-dashboard',
      builder: (context, state) => const OptimizationDashboardScreen(),
    ),
    GoRoute(
      path: '/digital-twin/optimization-marketplace',
      builder: (context, state) => const OptimizationMarketplaceScreen(),
    ),
    GoRoute(
      path: '/digital-twin/organization-simulator',
      builder: (context, state) => const OrganizationSimulatorScreen(),
    ),
    GoRoute(
      path: '/digital-twin/prediction-dashboard',
      builder: (context, state) => const PredictionDashboardScreen(),
    ),
    GoRoute(
      path: '/digital-twin/process-benchmark',
      builder: (context, state) => const ProcessBenchmarkScreen(),
    ),
    GoRoute(
      path: '/digital-twin/process-mining',
      builder: (context, state) => const ProcessMiningScreen(),
    ),
    GoRoute(
      path: '/digital-twin/process-variants',
      builder: (context, state) => const ProcessVariantsScreen(),
    ),
    GoRoute(
      path: '/digital-twin/recommendation-approval',
      builder: (context, state) => const RecommendationApprovalScreen(),
    ),
    GoRoute(
      path: '/digital-twin/recommendation-center',
      builder: (context, state) => const RecommendationCenterScreen(),
    ),
    GoRoute(
      path: '/digital-twin/risk-heatmap',
      builder: (context, state) => const RiskHeatmapScreen(),
    ),
    GoRoute(
      path: '/digital-twin/root-cause',
      builder: (context, state) => const RootCauseScreen(),
    ),
    GoRoute(
      path: '/digital-twin/scenario-branching',
      builder: (context, state) => const ScenarioBranchingScreen(),
    ),
    GoRoute(
      path: '/digital-twin/scenario-comparison',
      builder: (context, state) => const ScenarioComparisonScreen(),
    ),
    GoRoute(
      path: '/digital-twin/simulation-builder',
      builder: (context, state) => const SimulationBuilderScreen(),
    ),
    GoRoute(
      path: '/digital-twin/simulation-dashboard',
      builder: (context, state) => const SimulationDashboardScreen(),
    ),
    GoRoute(
      path: '/digital-twin/simulation-replay',
      builder: (context, state) => const SimulationReplayScreen(),
    ),
    GoRoute(
      path: '/digital-twin/simulation-results',
      builder: (context, state) => const SimulationResultsScreen(),
    ),
    GoRoute(
      path: '/digital-twin/simulation-templates',
      builder: (context, state) => const SimulationTemplatesScreen(),
    ),
    GoRoute(
      path: '/digital-twin/sla-analysis',
      builder: (context, state) => const SlaAnalysisScreen(),
    ),
    GoRoute(
      path: '/digital-twin/strategic-initiatives',
      builder: (context, state) => const StrategicInitiativesScreen(),
    ),
    GoRoute(
      path: '/digital-twin/strategy-map',
      builder: (context, state) => const StrategyMapScreen(),
    ),
    GoRoute(
      path: '/digital-twin/value-stream',
      builder: (context, state) => const ValueStreamScreen(),
    ),

    // Phase 24 Enterprise Data Platform routes
    GoRoute(
      path: '/data-platform/ai-auto-lineage',
      builder: (context, state) => const AiAutoLineageScreen(),
    ),
    GoRoute(
      path: '/data-platform/ai-data-mapping',
      builder: (context, state) => const AiDataMappingScreen(),
    ),
    GoRoute(
      path: '/data-platform/ai-steward-assistant',
      builder: (context, state) => const AiStewardAssistantScreen(),
    ),
    GoRoute(
      path: '/data-platform/business-glossary',
      builder: (context, state) => const BusinessGlossaryScreen(),
    ),
    GoRoute(
      path: '/data-platform/cdc-registry',
      builder: (context, state) => const CdcRegistryScreen(),
    ),
    GoRoute(
      path: '/data-platform/classification',
      builder: (context, state) => const ClassificationScreen(),
    ),
    GoRoute(
      path: '/data-platform/connection-manager',
      builder: (context, state) => const ConnectionManagerScreen(),
    ),
    GoRoute(
      path: '/data-platform/connector-marketplace',
      builder: (context, state) => const ConnectorMarketplaceScreen(),
    ),
    GoRoute(
      path: '/data-platform/consumer-groups',
      builder: (context, state) => const ConsumerGroupsScreen(),
    ),
    GoRoute(
      path: '/data-platform/contract-testing',
      builder: (context, state) => const ContractTestingScreen(),
    ),
    GoRoute(
      path: '/data-platform/data-api-developer-portal',
      builder: (context, state) => const DataApiDeveloperPortalScreen(),
    ),
    GoRoute(
      path: '/data-platform/data-catalog',
      builder: (context, state) => const DataCatalogScreen(),
    ),
    GoRoute(
      path: '/data-platform/data-contracts',
      builder: (context, state) => const DataContractsScreen(),
    ),
    GoRoute(
      path: '/data-platform/data-federation-explorer',
      builder: (context, state) => const DataFederationExplorerScreen(),
    ),
    GoRoute(
      path: '/data-platform/data-finops-dashboard',
      builder: (context, state) => const DataFinopsDashboardScreen(),
    ),
    GoRoute(
      path: '/data-platform/data-health-score',
      builder: (context, state) => const DataHealthScoreScreen(),
    ),
    GoRoute(
      path: '/data-platform/data-lineage',
      builder: (context, state) => const DataLineageScreen(),
    ),
    GoRoute(
      path: '/data-platform/data-marketplace',
      builder: (context, state) => const DataMarketplaceScreen(),
    ),
    GoRoute(
      path: '/data-platform/data-mesh',
      builder: (context, state) => const DataMeshScreen(),
    ),
    GoRoute(
      path: '/data-platform/data-observability',
      builder: (context, state) => const DataObservabilityScreen(),
    ),
    GoRoute(
      path: '/data-platform/data-privacy',
      builder: (context, state) => const DataPrivacyScreen(),
    ),
    GoRoute(
      path: '/data-platform/data-products',
      builder: (context, state) => const DataProductsScreen(),
    ),
    GoRoute(
      path: '/data-platform/data-quality-ai',
      builder: (context, state) => const DataQualityAiScreen(),
    ),
    GoRoute(
      path: '/data-platform/data-quality',
      builder: (context, state) => const DataQualityScreen(),
    ),
    GoRoute(
      path: '/data-platform/data-reliability-scorecard',
      builder: (context, state) => const DataReliabilityScorecardScreen(),
    ),
    GoRoute(
      path: '/data-platform/data-search-explorer',
      builder: (context, state) => const DataSearchExplorerScreen(),
    ),
    GoRoute(
      path: '/data-platform/data-stewardship',
      builder: (context, state) => const DataStewardshipScreen(),
    ),
    GoRoute(
      path: '/data-platform/dataset-registry',
      builder: (context, state) => const DatasetRegistryScreen(),
    ),
    GoRoute(
      path: '/data-platform/dataset-sla-manager',
      builder: (context, state) => const DatasetSlaManagerScreen(),
    ),
    GoRoute(
      path: '/data-platform/dataset-versions',
      builder: (context, state) => const DatasetVersionsScreen(),
    ),
    GoRoute(
      path: '/data-platform/duplicate-resolution',
      builder: (context, state) => const DuplicateResolutionScreen(),
    ),
    GoRoute(
      path: '/data-platform/enterprise-data-overview',
      builder: (context, state) => const EnterpriseDataOverviewScreen(),
    ),
    GoRoute(
      path: '/data-platform/entity-merge',
      builder: (context, state) => const EntityMergeScreen(),
    ),
    GoRoute(
      path: '/data-platform/etl-dashboard',
      builder: (context, state) => const EtlDashboardScreen(),
    ),
    GoRoute(
      path: '/data-platform/event-stream',
      builder: (context, state) => const PlatformEventStreamScreen(),
    ),
    GoRoute(
      path: '/data-platform/feature-store',
      builder: (context, state) => const FeatureStoreScreen(),
    ),
    GoRoute(
      path: '/data-platform/golden-records',
      builder: (context, state) => const GoldenRecordsScreen(),
    ),
    GoRoute(
      path: '/data-platform/governance-scorecard',
      builder: (context, state) => const GovernanceScorecardScreen(),
    ),
    GoRoute(
      path: '/data-platform/integration-analytics',
      builder: (context, state) => const IntegrationAnalyticsScreen(),
    ),
    GoRoute(
      path: '/data-platform/integration-dashboard',
      builder: (context, state) => const IntegrationDashboardScreen(),
    ),
    GoRoute(
      path: '/data-platform/integration-logs',
      builder: (context, state) => const PlatformIntegrationLogsScreen(),
    ),
    GoRoute(
      path: '/data-platform/integration-recommendations',
      builder: (context, state) => const IntegrationRecommendationsScreen(),
    ),
    GoRoute(
      path: '/data-platform/integration-sandbox',
      builder: (context, state) => const IntegrationSandboxScreen(),
    ),
    GoRoute(
      path: '/data-platform/lakehouse-explorer',
      builder: (context, state) => const LakehouseExplorerScreen(),
    ),
    GoRoute(
      path: '/data-platform/master-data-dashboard',
      builder: (context, state) => const MasterDataDashboardScreen(),
    ),
    GoRoute(
      path: '/data-platform/metadata-discovery',
      builder: (context, state) => const MetadataDiscoveryScreen(),
    ),
    GoRoute(
      path: '/data-platform/metadata-explorer',
      builder: (context, state) => const MetadataExplorerScreen(),
    ),
    GoRoute(
      path: '/data-platform/pipeline-builder',
      builder: (context, state) => const PipelineBuilderScreen(),
    ),
    GoRoute(
      path: '/data-platform/pipeline-execution',
      builder: (context, state) => const PipelineExecutionScreen(),
    ),
    GoRoute(
      path: '/data-platform/pipeline-optimizer',
      builder: (context, state) => const PipelineOptimizerScreen(),
    ),
    GoRoute(
      path: '/data-platform/pipeline-templates',
      builder: (context, state) => const PipelineTemplatesScreen(),
    ),
    GoRoute(
      path: '/data-platform/platform-data-settings',
      builder: (context, state) => const PlatformDataSettingsScreen(),
    ),
    GoRoute(
      path: '/data-platform/platform-sla',
      builder: (context, state) => const PlatformSlaScreen(),
    ),
    GoRoute(
      path: '/data-platform/query-planner',
      builder: (context, state) => const QueryPlannerScreen(),
    ),
    GoRoute(
      path: '/data-platform/reconciliation-center',
      builder: (context, state) => const ReconciliationCenterScreen(),
    ),
    GoRoute(
      path: '/data-platform/relationship-graph',
      builder: (context, state) => const RelationshipGraphScreen(),
    ),
    GoRoute(
      path: '/data-platform/replay-center',
      builder: (context, state) => const ReplayCenterScreen(),
    ),
    GoRoute(
      path: '/data-platform/retention-policies',
      builder: (context, state) => const RetentionPoliciesScreen(),
    ),
    GoRoute(
      path: '/data-platform/reverse-etl',
      builder: (context, state) => const ReverseEtlScreen(),
    ),
    GoRoute(
      path: '/data-platform/schema-drift',
      builder: (context, state) => const SchemaDriftScreen(),
    ),
    GoRoute(
      path: '/data-platform/semantic-layer',
      builder: (context, state) => const SemanticLayerScreen(),
    ),
    GoRoute(
      path: '/data-platform/sharing-agreements',
      builder: (context, state) => const SharingAgreementsScreen(),
    ),
    GoRoute(
      path: '/data-platform/stream-dashboard',
      builder: (context, state) => const StreamDashboardScreen(),
    ),
    GoRoute(
      path: '/data-platform/sync-jobs',
      builder: (context, state) => const SyncJobsScreen(),
    ),
    GoRoute(
      path: '/data-platform/topic-manager',
      builder: (context, state) => const TopicManagerScreen(),
    ),
    GoRoute(
      path: '/data-platform/transformation-rules',
      builder: (context, state) => const TransformationRulesScreen(),
    ),
    GoRoute(
      path: '/data-platform/universal-search-index',
      builder: (context, state) => const UniversalSearchIndexScreen(),
    ),
    GoRoute(
      path: '/data-platform/usage-analytics',
      builder: (context, state) => const UsageAnalyticsScreen(),
    ),
    GoRoute(
      path: '/data-platform/webhook-manager',
      builder: (context, state) => const WebhookManagerScreen(),
    ),

    // Phase 25 Low-Code Studio routes
    GoRoute(
      path: '/studio/ai-application-builder',
      builder: (context, state) => const AiApplicationBuilderScreen(),
    ),
    GoRoute(
      path: '/studio/api-designer',
      builder: (context, state) => const ApiDesignerScreen(),
    ),
    GoRoute(
      path: '/studio/application-analytics',
      builder: (context, state) => const ApplicationAnalyticsScreen(),
    ),
    GoRoute(
      path: '/studio/application-details',
      builder: (context, state) => const ApplicationDetailsScreen(),
    ),
    GoRoute(
      path: '/studio/application-packages',
      builder: (context, state) => const ApplicationPackagesScreen(),
    ),
    GoRoute(
      path: '/studio/application-reviews',
      builder: (context, state) => const ApplicationReviewsScreen(),
    ),
    GoRoute(
      path: '/studio/application-store',
      builder: (context, state) => const ApplicationStoreScreen(),
    ),
    GoRoute(
      path: '/studio/application-versions',
      builder: (context, state) => const ApplicationVersionsScreen(),
    ),
    GoRoute(
      path: '/studio/applications',
      builder: (context, state) => const ApplicationsScreen(),
    ),
    GoRoute(
      path: '/studio/branding',
      builder: (context, state) => const BrandingScreen(),
    ),
    GoRoute(
      path: '/studio/component-designer',
      builder: (context, state) => const ComponentDesignerScreen(),
    ),
    GoRoute(
      path: '/studio/component-library',
      builder: (context, state) => const ComponentLibraryScreen(),
    ),
    GoRoute(
      path: '/studio/custom-widget',
      builder: (context, state) => const CustomWidgetScreen(),
    ),
    GoRoute(
      path: '/studio/dashboard-builder',
      builder: (context, state) => const DashboardBuilderScreen(),
    ),
    GoRoute(
      path: '/studio/dashboard-generator',
      builder: (context, state) => const DashboardGeneratorScreen(),
    ),
    GoRoute(
      path: '/studio/datasource',
      builder: (context, state) => const DatasourceScreen(),
    ),
    GoRoute(
      path: '/studio/deployment-center',
      builder: (context, state) => const DeploymentCenterScreen(),
    ),
    GoRoute(
      path: '/studio/entity-designer',
      builder: (context, state) => const EntityDesignerScreen(),
    ),
    GoRoute(
      path: '/studio/expression-builder',
      builder: (context, state) => const ExpressionBuilderScreen(),
    ),
    GoRoute(
      path: '/studio/form-builder',
      builder: (context, state) => const FormBuilderScreen(),
    ),
    GoRoute(
      path: '/studio/formula-builder',
      builder: (context, state) => const FormulaBuilderScreen(),
    ),
    GoRoute(
      path: '/studio/git-branches',
      builder: (context, state) => const GitBranchesScreen(),
    ),
    GoRoute(
      path: '/studio/graphql-designer',
      builder: (context, state) => const GraphqlDesignerScreen(),
    ),
    GoRoute(
      path: '/studio/layout-designer',
      builder: (context, state) => const LayoutDesignerScreen(),
    ),
    GoRoute(
      path: '/studio/live-preview',
      builder: (context, state) => const LivePreviewScreen(),
    ),
    GoRoute(
      path: '/studio/localization',
      builder: (context, state) => const LocalizationScreen(),
    ),
    GoRoute(
      path: '/studio/metadata-diff',
      builder: (context, state) => const MetadataDiffScreen(),
    ),
    GoRoute(
      path: '/studio/metadata-editor',
      builder: (context, state) => const MetadataEditorScreen(),
    ),
    GoRoute(
      path: '/studio/metadata-history',
      builder: (context, state) => const MetadataHistoryScreen(),
    ),
    GoRoute(
      path: '/studio/metadata-viewer',
      builder: (context, state) => const MetadataViewerScreen(),
    ),
    GoRoute(
      path: '/studio/navigation-designer',
      builder: (context, state) => const NavigationDesignerScreen(),
    ),
    GoRoute(
      path: '/studio/package-manager',
      builder: (context, state) => const PackageManagerScreen(),
    ),
    GoRoute(
      path: '/studio/page-designer',
      builder: (context, state) => const PageDesignerScreen(),
    ),
    GoRoute(
      path: '/studio/performance-dashboard',
      builder: (context, state) => const PerformanceDashboardScreen(),
    ),
    GoRoute(
      path: '/studio/permissions-designer',
      builder: (context, state) => const PermissionsDesignerScreen(),
    ),
    GoRoute(
      path: '/studio/plugin-bindings',
      builder: (context, state) => const PluginBindingsScreen(),
    ),
    GoRoute(
      path: '/studio/prompt-to-app',
      builder: (context, state) => const PromptToAppScreen(),
    ),
    GoRoute(
      path: '/studio/publish-application',
      builder: (context, state) => const PublishApplicationScreen(),
    ),
    GoRoute(
      path: '/studio/query-builder',
      builder: (context, state) => const QueryBuilderScreen(),
    ),
    GoRoute(
      path: '/studio/relationship-designer',
      builder: (context, state) => const RelationshipDesignerScreen(),
    ),
    GoRoute(
      path: '/studio/release-manager',
      builder: (context, state) => const ReleaseManagerScreen(),
    ),
    GoRoute(
      path: '/studio/rule-designer',
      builder: (context, state) => const RuleDesignerScreen(),
    ),
    GoRoute(
      path: '/studio/runtime-debugger',
      builder: (context, state) => const RuntimeDebuggerScreen(),
    ),
    GoRoute(
      path: '/studio/runtime-monitor',
      builder: (context, state) => const RuntimeMonitorScreen(),
    ),
    GoRoute(
      path: '/studio/studio-dashboard',
      builder: (context, state) => const StudioDashboardScreen(),
    ),
    GoRoute(
      path: '/studio/studio-settings',
      builder: (context, state) => const StudioSettingsScreen(),
    ),
    GoRoute(
      path: '/studio/test-runner',
      builder: (context, state) => const TestRunnerScreen(),
    ),
    GoRoute(
      path: '/studio/theme-designer',
      builder: (context, state) => const ThemeDesignerScreen(),
    ),
    GoRoute(
      path: '/studio/theme-gallery',
      builder: (context, state) => const ThemeGalleryScreen(),
    ),
    GoRoute(
      path: '/studio/usage-dashboard',
      builder: (context, state) => const UsageDashboardScreen(),
    ),
    GoRoute(
      path: '/studio/validation-center',
      builder: (context, state) => const ValidationCenterScreen(),
    ),
    GoRoute(
      path: '/studio/workflow-designer',
      builder: (context, state) => const WorkflowDesignerScreen(),
    ),

    // Phase 26 Integration & iPaaS routes
    GoRoute(
      path: '/integration/api-analytics',
      builder: (context, state) => const IpaasApiAnalyticsScreen(),
    ),
    GoRoute(
      path: '/integration/api-consumers',
      builder: (context, state) => const IpaasApiConsumersScreen(),
    ),
    GoRoute(
      path: '/integration/api-gateway',
      builder: (context, state) => const IpaasApiGatewayScreen(),
    ),
    GoRoute(
      path: '/integration/api-keys',
      builder: (context, state) => const IpaasApiKeysScreen(),
    ),
    GoRoute(
      path: '/integration/api-products',
      builder: (context, state) => const IpaasApiProductsScreen(),
    ),
    GoRoute(
      path: '/integration/api-usage',
      builder: (context, state) => const IpaasApiUsageScreen(),
    ),
    GoRoute(
      path: '/integration/as2-configuration',
      builder: (context, state) => const IpaasAs2ConfigurationScreen(),
    ),
    GoRoute(
      path: '/integration/automation-assets',
      builder: (context, state) => const IpaasAutomationAssetsScreen(),
    ),
    GoRoute(
      path: '/integration/bot-builder',
      builder: (context, state) => const IpaasBotBuilderScreen(),
    ),
    GoRoute(
      path: '/integration/browser-automation',
      builder: (context, state) => const IpaasBrowserAutomationScreen(),
    ),
    GoRoute(
      path: '/integration/connector-details',
      builder: (context, state) => const IpaasConnectorDetailsScreen(),
    ),
    GoRoute(
      path: '/integration/connector-health',
      builder: (context, state) => const IpaasConnectorHealthScreen(),
    ),
    GoRoute(
      path: '/integration/connector-logs',
      builder: (context, state) => const IpaasConnectorLogsScreen(),
    ),
    GoRoute(
      path: '/integration/connector-marketplace',
      builder: (context, state) => const IpaasConnectorMarketplaceScreen(),
    ),
    GoRoute(
      path: '/integration/connector-usage',
      builder: (context, state) => const IpaasConnectorUsageScreen(),
    ),
    GoRoute(
      path: '/integration/dead-letter-queue',
      builder: (context, state) => const IpaasDeadLetterQueueScreen(),
    ),
    GoRoute(
      path: '/integration/desktop-automation',
      builder: (context, state) => const IpaasDesktopAutomationScreen(),
    ),
    GoRoute(
      path: '/integration/document-classification',
      builder: (context, state) => const IpaasDocumentClassificationScreen(),
    ),
    GoRoute(
      path: '/integration/document-templates',
      builder: (context, state) => const IpaasDocumentTemplatesScreen(),
    ),
    GoRoute(
      path: '/integration/edi-batches',
      builder: (context, state) => const IpaasEdiBatchesScreen(),
    ),
    GoRoute(
      path: '/integration/edi-messages',
      builder: (context, state) => const IpaasEdiMessagesScreen(),
    ),
    GoRoute(
      path: '/integration/event-consumers',
      builder: (context, state) => const IpaasEventConsumersScreen(),
    ),
    GoRoute(
      path: '/integration/event-messages',
      builder: (context, state) => const IpaasEventMessagesScreen(),
    ),
    GoRoute(
      path: '/integration/event-replay',
      builder: (context, state) => const IpaasEventReplayScreen(),
    ),
    GoRoute(
      path: '/integration/event-topics',
      builder: (context, state) => const IpaasEventTopicsScreen(),
    ),
    GoRoute(
      path: '/integration/flow-builder',
      builder: (context, state) => const IpaasFlowBuilderScreen(),
    ),
    GoRoute(
      path: '/integration/flow-debugger',
      builder: (context, state) => const IpaasFlowDebuggerScreen(),
    ),
    GoRoute(
      path: '/integration/flow-designer',
      builder: (context, state) => const IpaasFlowDesignerScreen(),
    ),
    GoRoute(
      path: '/integration/flow-execution',
      builder: (context, state) => const IpaasFlowExecutionScreen(),
    ),
    GoRoute(
      path: '/integration/flow-history',
      builder: (context, state) => const IpaasFlowHistoryScreen(),
    ),
    GoRoute(
      path: '/integration/flow-templates',
      builder: (context, state) => const IpaasFlowTemplatesScreen(),
    ),
    GoRoute(
      path: '/integration/installed-connectors',
      builder: (context, state) => const IpaasInstalledConnectorsScreen(),
    ),
    GoRoute(
      path: '/integration/integration-ai',
      builder: (context, state) => const IpaasIntegrationAiScreen(),
    ),
    GoRoute(
      path: '/integration/integration-analytics',
      builder: (context, state) => const IpaasIntegrationAnalyticsScreen(),
    ),
    GoRoute(
      path: '/integration/integration-cost',
      builder: (context, state) => const IpaasIntegrationCostScreen(),
    ),
    GoRoute(
      path: '/integration/integration-dashboard',
      builder: (context, state) => const IpaasIntegrationDashboardScreen(),
    ),
    GoRoute(
      path: '/integration/integration-performance',
      builder: (context, state) => const IpaasIntegrationPerformanceScreen(),
    ),
    GoRoute(
      path: '/integration/integration-settings',
      builder: (context, state) => const IpaasIntegrationSettingsScreen(),
    ),
    GoRoute(
      path: '/integration/invoice-parser',
      builder: (context, state) => const IpaasInvoiceParserScreen(),
    ),
    GoRoute(
      path: '/integration/mapping-designer',
      builder: (context, state) => const IpaasMappingDesignerScreen(),
    ),
    GoRoute(
      path: '/integration/ocr-dashboard',
      builder: (context, state) => const IpaasOcrDashboardScreen(),
    ),
    GoRoute(
      path: '/integration/partner-connections',
      builder: (context, state) => const IpaasPartnerConnectionsScreen(),
    ),
    GoRoute(
      path: '/integration/partners',
      builder: (context, state) => const IpaasPartnersScreen(),
    ),
    GoRoute(
      path: '/integration/pipeline-builder',
      builder: (context, state) => const IpaasPipelineBuilderScreen(),
    ),
    GoRoute(
      path: '/integration/pipeline-dashboard',
      builder: (context, state) => const IpaasPipelineDashboardScreen(),
    ),
    GoRoute(
      path: '/integration/pipeline-runs',
      builder: (context, state) => const IpaasPipelineRunsScreen(),
    ),
    GoRoute(
      path: '/integration/receipt-parser',
      builder: (context, state) => const IpaasReceiptParserScreen(),
    ),
    GoRoute(
      path: '/integration/rpa-dashboard',
      builder: (context, state) => const IpaasRpaDashboardScreen(),
    ),
    GoRoute(
      path: '/integration/sync-analytics',
      builder: (context, state) => const IpaasSyncAnalyticsScreen(),
    ),
    GoRoute(
      path: '/integration/sync-conflicts',
      builder: (context, state) => const IpaasSyncConflictsScreen(),
    ),
    GoRoute(
      path: '/integration/sync-dashboard',
      builder: (context, state) => const IpaasSyncDashboardScreen(),
    ),
    GoRoute(
      path: '/integration/sync-jobs',
      builder: (context, state) => const IpaasSyncJobsScreen(),
    ),
    GoRoute(
      path: '/integration/sync-resolution',
      builder: (context, state) => const IpaasSyncResolutionScreen(),
    ),
    GoRoute(
      path: '/integration/transformation-designer',
      builder: (context, state) => const IpaasTransformationDesignerScreen(),
    ),
    GoRoute(
      path: '/integration/validation-rules',
      builder: (context, state) => const IpaasValidationRulesScreen(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(child: Text('Page not found: ${state.uri}')),
  ),
);
