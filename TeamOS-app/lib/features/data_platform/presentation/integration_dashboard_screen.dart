import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class IntegrationDashboardScreen extends StatelessWidget {
  const IntegrationDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Enterprise Data Platform', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
            // Welcome Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0EA5E9), Color(0xFF2563EB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Enterprise Data Hub', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Managing unified data integration, governance, master records, and data virtualisation.', style: TextStyle(color: Color(0xFFE0F2FE), fontSize: 14)),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Telemetry Grid
            const Text('Data Platform Telemetry', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildTelemetryGrid(context),
            const SizedBox(height: 32),

            // Navigation Grid
            const Text('Operational Modules', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildModulesGrid(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTelemetryGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: MediaQuery.of(context).size.width > 900 ? 4 : 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.3,
      children: [
        _buildStatCard('Sync Status', 'OPERATIONAL', Colors.greenAccent),
        _buildStatCard('CDC Rate', '125 rec/sec', Colors.cyanAccent),
        _buildStatCard('SLA Compliance', '94.8%', Colors.amberAccent),
        _buildStatCard('Data Health', 'A+ / 98.2', Colors.greenAccent),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildModulesGrid(BuildContext context) {
    final modules = [
      _Module('Connector Marketplace', Icons.storefront, '/data-platform/connectors', Colors.blueAccent),
      _Module('Connection Manager', Icons.power, '/data-platform/connections', Colors.cyanAccent),
      _Module('Sync Jobs Log', Icons.sync, '/data-platform/sync-jobs', Colors.greenAccent),
      _Module('Pipeline Builder', Icons.device_hub, '/data-platform/pipeline-builder', Colors.orangeAccent),
      _Module('Pipeline Execution', Icons.play_arrow, '/data-platform/pipeline-execution', Colors.pinkAccent),
      _Module('Integration Logs', Icons.receipt_long, '/data-platform/integration-logs', Colors.redAccent),
      _Module('Webhook Manager', Icons.webhook, '/data-platform/webhooks', Colors.purpleAccent),
      _Module('Event Stream Ingestion', Icons.stream, '/data-platform/event-stream', Colors.tealAccent),
      _Module('Master Data Dashboard', Icons.dns, '/data-platform/master-data', Colors.indigoAccent),
      _Module('Golden Records', Icons.verified, '/data-platform/golden-records', Colors.amberAccent),
      _Module('Duplicate Resolution', Icons.copy_all, '/data-platform/duplicate-resolution', Colors.deepOrangeAccent),
      _Module('Entity Merge', Icons.call_merge, '/data-platform/entity-merge', Colors.lightGreenAccent),
      _Module('Relationship Graph', Icons.schema, '/data-platform/relationship-graph', Colors.blueAccent),
      _Module('Data Catalog', Icons.menu_book, '/data-platform/data-catalog', Colors.cyanAccent),
      _Module('Business Glossary',Icons.translate, '/data-platform/business-glossary', Colors.purpleAccent),
      _Module('Metadata Explorer', Icons.explore, '/data-platform/metadata-explorer', Colors.greenAccent),
      _Module('Classification Console', Icons.security, '/data-platform/classification', Colors.redAccent),
      _Module('Data Quality Reports', Icons.fact_check, '/data-platform/data-quality', Colors.tealAccent),
      _Module('Data Lineage Tracer', Icons.timeline, '/data-platform/data-lineage', Colors.indigoAccent),
      _Module('ETL Dashboard', Icons.analytics, '/data-platform/etl-dashboard', Colors.amberAccent),
      _Module('Pipeline Templates', Icons.copy, '/data-platform/pipeline-templates', Colors.orangeAccent),
      _Module('Dataset Registry', Icons.folder, '/data-platform/dataset-registry', Colors.blueAccent),
      _Module('Dataset Versions', Icons.history, '/data-platform/dataset-versions', Colors.cyanAccent),
      _Module('Transformation Rules', Icons.transform, '/data-platform/transformation-rules', Colors.pinkAccent),
      _Module('Stream Dashboard', Icons.show_chart, '/data-platform/stream-dashboard', Colors.greenAccent),
      _Module('Topic Manager', Icons.queue, '/data-platform/topic-manager', Colors.tealAccent),
      _Module('Consumer Groups', Icons.groups, '/data-platform/consumer-groups', Colors.indigoAccent),
      _Module('Replay Center', Icons.replay, '/data-platform/replay-center', Colors.redAccent),
      _Module('AI Data Mapping', Icons.auto_awesome, '/data-platform/ai-data-mapping', Colors.amberAccent),
      _Module('Schema Drift Alerts', Icons.warning, '/data-platform/schema-drift', Colors.orangeAccent),
      _Module('Pipeline Optimizer', Icons.speed, '/data-platform/pipeline-optimizer', Colors.purpleAccent),
      _Module('Integration Advice', Icons.lightbulb, '/data-platform/integration-recommendations', Colors.blueAccent),
      _Module('Data Quality AI', Icons.psychology, '/data-platform/data-quality-ai', Colors.cyanAccent),
      _Module('Enterprise Data Overview', Icons.dashboard, '/data-platform/overview', Colors.greenAccent),
      _Module('Data Health Score', Icons.favorite, '/data-platform/health-score', Colors.pinkAccent),
      _Module('Governance Scorecard', Icons.score, '/data-platform/governance-scorecard', Colors.tealAccent),
      _Module('Integration Analytics', Icons.bar_chart, '/data-platform/analytics', Colors.indigoAccent),
      _Module('Data Settings', Icons.settings, '/data-platform/settings', Colors.redAccent),
      _Module('Data Contracts', Icons.handshake, '/data-platform/contracts', Colors.blueAccent),
      _Module('CDC Registry', Icons.track_changes, '/data-platform/cdc-registry', Colors.cyanAccent),
      _Module('Stewardship Console', Icons.assignment_ind, '/data-platform/stewardship', Colors.greenAccent),
      _Module('Data Privacy Policies', Icons.privacy_tip, '/data-platform/privacy', Colors.redAccent),
      _Module('Data Observability', Icons.visibility, '/data-platform/observability', Colors.pinkAccent),
      _Module('Data Products', Icons.inventory, '/data-platform/products', Colors.tealAccent),
      _Module('Retention Policies', Icons.calendar_today, '/data-platform/retention-policies', Colors.amberAccent),
      _Module('Reconciliation Center', Icons.balance, '/data-platform/reconciliation-center', Colors.indigoAccent),
      _Module('Data Marketplace', Icons.shopping_bag, '/data-platform/marketplace', Colors.orangeAccent),
      _Module('Platform SLA', Icons.alarm, '/data-platform/sla', Colors.blueAccent),
      _Module('Data Mesh Governance', Icons.grid_view, '/data-platform/mesh', Colors.cyanAccent),
      _Module('Lakehouse Explorer', Icons.waves, '/data-platform/lakehouse-explorer', Colors.greenAccent),
      _Module('Semantic Layer', Icons.layers, '/data-platform/semantic-layer', Colors.purpleAccent),
      _Module('Metadata Discovery', Icons.manage_search, '/data-platform/metadata-discovery', Colors.pinkAccent),
      _Module('Integration Sandbox', Icons.science, '/data-platform/sandbox', Colors.tealAccent),
      _Module('Data API Portal', Icons.api, '/data-platform/api-portal', Colors.indigoAccent),
      _Module('Sharing Agreements', Icons.draw, '/data-platform/sharing-agreements', Colors.amberAccent),
      _Module('FinOps Cost Tracker', Icons.monetization_on, '/data-platform/finops', Colors.orangeAccent),
      _Module('Reliability Scorecard', Icons.check_circle, '/data-platform/reliability-scorecard', Colors.redAccent),
      _Module('AI Steward Assistant', Icons.support_agent, '/data-platform/steward-assistant', Colors.cyanAccent),
      _Module('Data Federation', Icons.hub, '/data-platform/federation', Colors.blueAccent),
      _Module('Contract Testing', Icons.flaky, '/data-platform/contract-testing', Colors.pinkAccent),
      _Module('Dataset SLA Manager', Icons.notifications_active, '/data-platform/dataset-sla', Colors.greenAccent),
      _Module('Usage Analytics', Icons.insights, '/data-platform/usage-analytics', Colors.purpleAccent),
      _Module('AI Auto-Lineage', Icons.bubble_chart, '/data-platform/auto-lineage', Colors.tealAccent),
      _Module('Reverse ETL Sync', Icons.swap_horiz, '/data-platform/reverse-etl', Colors.amberAccent),
      _Module('Feature Store', Icons.storage, '/data-platform/feature-store', Colors.indigoAccent),
      _Module('Query Planner Graph', Icons.route_outlined, '/data-platform/query-planner', Colors.blueAccent),
      _Module('Universal Search Index', Icons.search_off, '/data-platform/search-index', Colors.orangeAccent),
      _Module('Enterprise Search', Icons.search, '/data-platform/search-explorer', Colors.pinkAccent),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 900 ? 6 : 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.4,
      ),
      itemCount: modules.length,
      itemBuilder: (context, index) {
        final m = modules[index];
        return InkWell(
          onTap: () => context.push(m.route),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(m.icon, color: m.color, size: 24),
                const SizedBox(height: 8),
                Text(
                  m.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Module {
  final String name;
  final IconData icon;
  final String route;
  final Color color;

  _Module(this.name, this.icon, this.route, this.color);
}
