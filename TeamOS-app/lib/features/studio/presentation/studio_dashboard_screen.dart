import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StudioDashboardScreen extends StatelessWidget {
  const StudioDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> sections = [
      {'title': 'Applications List', 'path': '/studio/applications', 'desc': 'Manage active low-code applications.'},
      {'title': 'Application Details', 'path': '/studio/application-details', 'desc': 'Configure app attributes.'},
      {'title': 'Application Versions', 'path': '/studio/application-versions', 'desc': 'Track package revision history.'},
      {'title': 'Application Packages', 'path': '/studio/application-packages', 'desc': 'Bundle and export apps.'},
      {'title': 'Page Designer', 'path': '/studio/page-designer', 'desc': 'Edit routes and canvas layouts.'},
      {'title': 'Component Designer', 'path': '/studio/component-designer', 'desc': 'Configure parameter widgets.'},
      {'title': 'Layout Designer', 'path': '/studio/layout-designer', 'desc': 'Tune grid and spacing options.'},
      {'title': 'Navigation Designer', 'path': '/studio/navigation-designer', 'desc': 'Manage menus and sidebar items.'},
      {'title': 'Workflow Designer', 'path': '/studio/workflow-designer', 'desc': 'Drag & drop business process flows.'},
      {'title': 'Rule Designer', 'path': '/studio/rule-designer', 'desc': 'Edit logic rules and expressions.'},
      {'title': 'Theme Designer', 'path': '/studio/theme-designer', 'desc': 'Customize palettes and typography.'},
      {'title': 'Datasource Config', 'path': '/studio/datasource', 'desc': 'Register remote end-point connectors.'},
      {'title': 'API Designer', 'path': '/studio/api-designer', 'desc': 'Plan custom REST endpoint pathways.'},
      {'title': 'GraphQL Designer', 'path': '/studio/graphql-designer', 'desc': 'Edit GraphQL API queries.'},
      {'title': 'Permissions Editor', 'path': '/studio/permissions-designer', 'desc': 'Map roles to EAP actions.'},
      {'title': 'Runtime Monitor', 'path': '/studio/runtime-monitor', 'desc': 'Track latency and memory speed.'},
      {'title': 'Metadata Viewer', 'path': '/studio/metadata-viewer', 'desc': 'View raw application JSON configuration.'},
      {'title': 'Validation Center', 'path': '/studio/validation-center', 'desc': 'Check routes and schemas consistency.'},
      {'title': 'Package Signer', 'path': '/studio/package-manager', 'desc': 'Cryptographic signing operations.'},
      {'title': 'Application Store', 'path': '/studio/application-store', 'desc': 'Browse Low-Code blueprints marketplace.'},
      {'title': 'Publish Application', 'path': '/studio/publish-application', 'desc': 'Register apps in store.'},
      {'title': 'Application Reviews', 'path': '/studio/application-reviews', 'desc': 'Track user feedback logs.'},
      {'title': 'AI Builder Workspace', 'path': '/studio/ai-application-builder', 'desc': 'Design apps with AI assistance.'},
      {'title': 'Prompt-to-App Generator', 'path': '/studio/prompt-to-app', 'desc': 'Natural language app generation.'},
      {'title': 'Dashboard Generator', 'path': '/studio/dashboard-generator', 'desc': 'Generate analytical KPI panels.'},
      {'title': 'Application Analytics', 'path': '/studio/application-analytics', 'desc': 'Telemetry reports logs.'},
      {'title': 'Usage Dashboard', 'path': '/studio/usage-dashboard', 'desc': 'Graph sessions and active user rates.'},
      {'title': 'Performance Dashboard', 'path': '/studio/performance-dashboard', 'desc': 'Latency trace telemetry.'},
      {'title': 'Branding Center', 'path': '/studio/branding', 'desc': 'Select corporate logos and icons.'},
      {'title': 'Theme Gallery', 'path': '/studio/theme-gallery', 'desc': 'Browse visual brand profiles catalog.'},
      {'title': 'Localization', 'path': '/studio/localization', 'desc': 'Languages and translations mapping.'},
      {'title': 'Component Library', 'path': '/studio/component-library', 'desc': 'Catalog of standard Flutter widgets.'},
      {'title': 'Custom Widget Editor', 'path': '/studio/custom-widget', 'desc': 'Develop and preview custom widgets.'},
      {'title': 'Plugin Bindings', 'path': '/studio/plugin-bindings', 'desc': 'Register platform channel bindings.'},
      {'title': 'Direct Metadata Editor', 'path': '/studio/metadata-editor', 'desc': 'Override raw configuration JSON.'},
      {'title': 'Expression Builder', 'path': '/studio/expression-builder', 'desc': 'Create logical conditions.'},
      {'title': 'Formula Builder', 'path': '/studio/formula-builder', 'desc': 'Configure math formulas solvers.'},
      {'title': 'Test Runner', 'path': '/studio/test-runner', 'desc': 'Run automated metadata integration tests.'},
      {'title': 'Deployment Center', 'path': '/studio/deployment-center', 'desc': 'Publish and promote workspaces.'},
      {'title': 'Release Manager', 'path': '/studio/release-manager', 'desc': 'Tag versions and rollback packages.'},
      {'title': 'Studio Settings', 'path': '/studio/studio-settings', 'desc': 'Visual Studio custom console options.'},
      {'title': 'Entity Designer', 'path': '/studio/entity-designer', 'desc': 'Design custom tables and database schema.'},
      {'title': 'Relationship Designer', 'path': '/studio/relationship-designer', 'desc': 'Map database foreign keys and links.'},
      {'title': 'Form Builder', 'path': '/studio/form-builder', 'desc': 'Visual grid form designer editor.'},
      {'title': 'Query Builder', 'path': '/studio/query-builder', 'desc': 'Design custom joins and filter projections.'},
      {'title': 'Dashboard Builder', 'path': '/studio/dashboard-builder', 'desc': 'Drag & drop dashboard widgets.'},
      {'title': 'Live Device Preview', 'path': '/studio/live-preview', 'desc': 'Preview in phone, tablet and desktop frames.'},
      {'title': 'Git Diff Viewer', 'path': '/studio/metadata-diff', 'desc': 'Inspect schema difference reports.'},
      {'title': 'Commit History', 'path': '/studio/metadata-history', 'desc': 'View commit logs history tree.'},
      {'title': 'Git Branches & Staging', 'path': '/studio/git-branches', 'desc': 'Branching, merging, and staging.'},
      {'title': 'Runtime Debugger', 'path': '/studio/runtime-debugger', 'desc': 'Trace event execution in live apps.'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('EAP Low-Code Studio', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Visual Designer Workspace', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Welcome to the Enterprise Application Platform (EAP) Low-Code Studio. Build metadata-driven apps securely.', style: TextStyle(color: Color(0xFFE0E7FF), fontSize: 14)),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text('Designer Modules', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.4,
              ),
              itemCount: sections.length,
              itemBuilder: (context, index) {
                final section = sections[index];
                return InkWell(
                  onTap: () => context.push(section['path']!),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF334155)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(section['title']!, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Expanded(
                          child: Text(section['desc']!, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11), maxLines: 3, overflow: TextOverflow.ellipsis),
                        ),
                        const SizedBox(height: 4),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(Icons.arrow_forward_rounded, color: Color(0xFF6366F1), size: 16),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
