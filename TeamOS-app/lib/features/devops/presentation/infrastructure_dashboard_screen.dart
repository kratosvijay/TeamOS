import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InfrastructureDashboardScreen extends StatelessWidget {
  const InfrastructureDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Live Operations Center Dashboard', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/dashboard'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'DevOps & SRE Command Center',
              style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: MediaQuery.of(context).size.width > 900 ? 5 : 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.3,
              children: const [
                OpsOverviewCard(title: 'Reliability Score', value: '99.99%', color: Color(0xFF10B981), icon: Icons.network_check),
                OpsOverviewCard(title: 'Active Alerts', value: '3 Firing', color: Color(0xFFEF4444), icon: Icons.notifications_active),
                OpsOverviewCard(title: 'Readiness Score', value: '98%', color: Color(0xFF3B82F6), icon: Icons.check_circle_outline),
                OpsOverviewCard(title: 'Active Nodes', value: '3 Ready', color: Color(0xFF8B5CF6), icon: Icons.dns),
                OpsOverviewCard(title: 'Remaining Budget', value: '83.5%', color: Color(0xFFEC4899), icon: Icons.pie_chart),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              'Platform Operations Modules',
              style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 900 ? 3 : 1,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 3.5,
              ),
              itemCount: devopsModules.length,
              itemBuilder: (context, index) {
                final module = devopsModules[index];
                return Card(
                  color: const Color(0xFF1E293B),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    leading: CircleAvatar(
                      backgroundColor: module.color.withOpacity(0.2),
                      child: Icon(module.icon, color: module.color),
                    ),
                    title: Text(module.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: Text(module.subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    onTap: () => context.push(module.route),
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

class OpsOverviewCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  const OpsOverviewCard({
    super.key,
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class DevopsModuleInfo {
  final String title;
  final String subtitle;
  final String route;
  final IconData icon;
  final Color color;

  const DevopsModuleInfo({
    required this.title,
    required this.subtitle,
    required this.route,
    required this.icon,
    required this.color,
  });
}

const List<DevopsModuleInfo> devopsModules = [
  DevopsModuleInfo(title: 'Cluster Manager', subtitle: 'Manage nodes, namespaces, and pods', route: '/devops/cluster', icon: Icons.dns, color: Colors.blue),
  DevopsModuleInfo(title: 'Service Catalog', subtitle: 'List microservices, owners, and repositories', route: '/devops/catalog', icon: Icons.list_alt, color: Colors.teal),
  DevopsModuleInfo(title: 'Developer Portal', subtitle: 'Ownerships, CI/CD status, and API docs', route: '/devops/portal', icon: Icons.developer_mode, color: Colors.purple),
  DevopsModuleInfo(title: 'Architecture Decisions (ADR)', subtitle: 'Read and update architecture logs', route: '/devops/adr', icon: Icons.menu_book, color: Colors.orange),
  DevopsModuleInfo(title: 'Jobs Dashboard', subtitle: 'CronJobs, worker nodes, BullMQ queues', route: '/devops/jobs', icon: Icons.work_outline, color: Colors.green),
  DevopsModuleInfo(title: 'Deployment History', subtitle: 'Canaries releases and active rollbacks', route: '/devops/deployments', icon: Icons.history, color: Colors.indigo),
  DevopsModuleInfo(title: 'Monitoring Dashboard', subtitle: 'Prometheus metrics and CPU/Memory gauges', route: '/devops/monitoring', icon: Icons.insights, color: Colors.tealAccent),
  DevopsModuleInfo(title: 'Golden Signals', subtitle: 'Google\'s 4 signals: Latency, Traffic, Errors, Saturation', route: '/devops/goldensignals', icon: Icons.signal_cellular_alt, color: Colors.amber),
  DevopsModuleInfo(title: 'Logs Explorer', subtitle: 'Structured logs console and correlation search', route: '/devops/logs', icon: Icons.receipt_long, color: Colors.deepPurpleAccent),
  DevopsModuleInfo(title: 'Distributed Tracing', subtitle: 'OpenTelemetry spans and query details', route: '/devops/tracing', icon: Icons.lan, color: Colors.pink),
  DevopsModuleInfo(title: 'Backup Center', subtitle: 'Automated schedules and workspace files storage', route: '/devops/backup', icon: Icons.backup, color: Colors.greenAccent),
  DevopsModuleInfo(title: 'Disaster Recovery', subtitle: 'PITR backups and simulated restore validations', route: '/devops/dr', icon: Icons.restore_page, color: Colors.cyan),
  DevopsModuleInfo(title: 'DR Drills Manager', subtitle: 'Simulate region, database, or cache failure drills', route: '/devops/drills', icon: Icons.model_training, color: Colors.redAccent),
  DevopsModuleInfo(title: 'Environment Config', subtitle: 'Staging, production, multi-cloud clusters', route: '/devops/env', icon: Icons.settings_applications, color: Colors.yellow),
  DevopsModuleInfo(title: 'Secrets Management', subtitle: 'TLS certificates expiration and renewals', route: '/devops/secrets', icon: Icons.vpn_key_sharp, color: Colors.deepOrange),
  DevopsModuleInfo(title: 'Autoscaling Rules', subtitle: 'HPA configuration, target metrics, limits', route: '/devops/autoscaling', icon: Icons.trending_up, color: Colors.lightGreen),
  DevopsModuleInfo(title: 'Cost Monitor', subtitle: 'Workspace cost allocation and cost tracking', route: '/devops/costs', icon: Icons.monetization_on, color: Colors.cyanAccent),
  DevopsModuleInfo(title: 'FinOps Dashboard', subtitle: 'Spot vm, rightsizing, savings plan optimization', route: '/devops/finops', icon: Icons.attach_money_rounded, color: Colors.green),
  DevopsModuleInfo(title: 'Tenant Operations', subtitle: 'Multi-tenant sessions, CPU, and token costs', route: '/devops/tenant', icon: Icons.groups, color: Colors.blueAccent),
  DevopsModuleInfo(title: 'Service Mesh Health', subtitle: 'Istio routing topology and STRICT mTLS indicators', route: '/devops/servicehealth', icon: Icons.hub, color: Colors.blueGrey),
  DevopsModuleInfo(title: 'Dependency Graph', subtitle: 'Blast-radius analyzer of microservices', route: '/devops/dependencies', icon: Icons.account_tree_sharp, color: Colors.lightBlueAccent),
  DevopsModuleInfo(title: 'API Compatibility', subtitle: 'REST/GraphQL deprecations and breaking alerts', route: '/devops/apicompatibility', icon: Icons.compare_arrows_rounded, color: Colors.orangeAccent),
  DevopsModuleInfo(title: 'Policy Center', subtitle: 'Compliance rules check: region, rootless, TLS v1.3', route: '/devops/policy', icon: Icons.policy, color: Colors.purpleAccent),
  DevopsModuleInfo(title: 'Feature Flags', subtitle: 'Percentage rollouts and global kill switches', route: '/devops/featureflags', icon: Icons.toggle_on, color: Colors.lightGreenAccent),
  DevopsModuleInfo(title: 'Release Management', subtitle: 'Deploy plans, manual approval, gating steps', route: '/devops/release', icon: Icons.cloud_done, color: Colors.red),
  DevopsModuleInfo(title: 'Release Calendar', subtitle: 'Scheduled rollout freeze periods, canary rollout phases', route: '/devops/calendar', icon: Icons.calendar_month, color: Colors.amberAccent),
  DevopsModuleInfo(title: 'Release Risk Analyzer', subtitle: 'Compute release risk index using DB & coverages', route: '/devops/releaserisk', icon: Icons.security_update_warning, color: Colors.pinkAccent),
  DevopsModuleInfo(title: 'Runbooks Library', subtitle: 'Markdown incident recovery guides & suggestions', route: '/devops/runbooks', icon: Icons.library_books, color: Colors.lightGreen),
  DevopsModuleInfo(title: 'Alert Center', subtitle: 'Firing alarms and Prometheus Alertmanager rules', route: '/devops/alerts', icon: Icons.warning, color: Colors.red),
  DevopsModuleInfo(title: 'Incident Center', subtitle: 'Track incident timeline events and linked alerts', route: '/devops/incidents', icon: Icons.crisis_alert, color: Colors.redAccent),
  DevopsModuleInfo(title: 'Operations Timeline', subtitle: 'Postmortem searchable audit timeline logs', route: '/devops/timeline', icon: Icons.timeline, color: Colors.teal),
  DevopsModuleInfo(title: 'Digital Twin platform', subtitle: 'Live digital twin of databases, caches, queues', route: '/devops/digitaltwin', icon: Icons.view_in_ar, color: Colors.indigoAccent),
  DevopsModuleInfo(title: 'Maintenance Center', subtitle: 'Scheduled window configuration, notifications', route: '/devops/maintenance', icon: Icons.access_time, color: Colors.grey),
  DevopsModuleInfo(title: 'Platform Scorecard', subtitle: 'KPIs dashboard: MTTR, success, error budget', route: '/devops/scorecard', icon: Icons.score, color: Colors.amber),
  DevopsModuleInfo(title: 'Executive Dashboard', subtitle: 'Operations availability, business impact logs', route: '/devops/executive', icon: Icons.business, color: Colors.lightBlue),
  DevopsModuleInfo(title: 'Operations AI Assistant', subtitle: 'AI Failure explanations, root-cause recommendations', route: '/devops/ai', icon: Icons.assistant, color: Colors.purpleAccent),
  DevopsModuleInfo(title: 'Platform Upgrade', subtitle: 'Zero-downtime upgrades and compatibility metrics', route: '/devops/upgrade', icon: Icons.upgrade, color: Colors.tealAccent),
  DevopsModuleInfo(title: 'Platform Readiness', subtitle: 'Pre-flight checklists and ready score status', route: '/devops/readiness', icon: Icons.done_all, color: Colors.green),
  DevopsModuleInfo(title: 'DevOps Settings', subtitle: 'Configure alert manager integrations and thresholds', route: '/devops/settings', icon: Icons.settings, color: Colors.blueGrey),
];

extension MainChildAxisCount on SliverGridDelegateWithFixedCrossAxisCount {
  double get mainChildAspectRatio => childAspectRatio;
}
