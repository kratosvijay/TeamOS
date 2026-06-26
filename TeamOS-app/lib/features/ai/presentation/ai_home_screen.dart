import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EnterpriseAIHomeScreen extends StatelessWidget {
  const EnterpriseAIHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Enterprise AI Platform', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                  colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('AI Control Plane Dashboard', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Active agent lifecycles, knowledge graph nodes, and policy logs are operational.', style: TextStyle(color: Color(0xFFE0E7FF), fontSize: 14)),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // SRE Telemetry & Metrics Row
            const Text('AI SRE Telemetry & Observability', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildTelemetryGrid(context),
            const SizedBox(height: 32),

            // Command Control Sub-screens
            const Text('Platform Execution Modules', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildPlatformModulesGrid(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTelemetryGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: MediaQuery.of(context).size.width > 900 ? 6 : 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.3,
      children: [
        _buildStatCard('Active Agents', '12', Colors.indigoAccent),
        _buildStatCard('Running Executions', '4', Colors.greenAccent),
        _buildStatCard('Token Spend Today', '\$14.20', Colors.cyanAccent),
        _buildStatCard('Monthly AI Cost', '\$412.50', Colors.pinkAccent),
        _buildStatCard('Avg Response Time', '1.2s', Colors.amberAccent),
        _buildStatCard('Graph Size', '1,420 Nodes', Colors.purpleAccent),
        _buildStatCard('Cache Hit Rate', '42%', Colors.tealAccent),
        _buildStatCard('Memory Usage', '128 MB', Colors.blueAccent),
        _buildStatCard('Approval Queue', '3 Pending', Colors.redAccent),
        _buildStatCard('Safety Violations', '0', Colors.greenAccent),
        _buildStatCard('Hallucination %', '0.02%', Colors.cyanAccent),
        _buildStatCard('Confidence Score', '94.2%', Colors.limeAccent),
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

  Widget _buildPlatformModulesGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: MediaQuery.of(context).size.width > 900 ? 5 : 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.4,
      children: [
        _buildModuleLink(context, 'Marketplace', Icons.storefront_rounded, '/ai/marketplace', Colors.indigoAccent),
        _buildModuleLink(context, 'Agent Builder', Icons.build_rounded, '/ai/builder', Colors.cyanAccent),
        _buildModuleLink(context, 'Knowledge Graph', Icons.grain_rounded, '/ai/graph', Colors.greenAccent),
        _buildModuleLink(context, 'Semantic Search', Icons.search_rounded, '/ai/search', Colors.orangeAccent),
        _buildModuleLink(context, 'Prompt Studio', Icons.terminal_rounded, '/ai/prompts', Colors.pinkAccent),
        _buildModuleLink(context, 'Agent Memory', Icons.save_rounded, '/ai/memory', Colors.blueAccent),
        _buildModuleLink(context, 'Executions Log', Icons.history_rounded, '/ai/executions', Colors.tealAccent),
        _buildModuleLink(context, 'Agent Monitor', Icons.insights_rounded, '/ai/monitor', Colors.purpleAccent),
        _buildModuleLink(context, 'Cost Analytics', Icons.analytics_outlined, '/ai/analytics', Colors.limeAccent),
        _buildModuleLink(context, 'Chat Console', Icons.chat_rounded, '/ai/chat/new', Colors.amberAccent),
        _buildModuleLink(context, 'Executive AI', Icons.leaderboard_rounded, '/ai/executive', Colors.redAccent),
        _buildModuleLink(context, 'Document Helper', Icons.article_rounded, '/ai/document', Colors.indigoAccent),
        _buildModuleLink(context, 'Meeting Analyzer', Icons.video_camera_back_rounded, '/ai/meeting', Colors.pinkAccent),
        _buildModuleLink(context, 'Project Forecast', Icons.trending_up_rounded, '/ai/project', Colors.greenAccent),
        _buildModuleLink(context, 'Finance Auditing', Icons.account_balance_rounded, '/ai/finance', Colors.orangeAccent),
        _buildModuleLink(context, 'HR Evaluator', Icons.people_rounded, '/ai/hr', Colors.tealAccent),
        _buildModuleLink(context, 'Sales Sequence', Icons.email_rounded, '/ai/sales', Colors.blueAccent),
        _buildModuleLink(context, 'DevOps Diagnostician', Icons.dns_rounded, '/ai/devops', Colors.purpleAccent),
        _buildModuleLink(context, 'Security Scanner', Icons.security_rounded, '/ai/security', Colors.redAccent),
        _buildModuleLink(context, 'Workflow Studio', Icons.route_rounded, '/ai/workflow', Colors.amberAccent),
        _buildModuleLink(context, 'Knowledge Sources', Icons.cloud_download_rounded, '/ai/sources', Colors.indigoAccent),
        _buildModuleLink(context, 'RAG Pipeline', Icons.settings_input_component_rounded, '/ai/rag', Colors.cyanAccent),
        _buildModuleLink(context, 'Policy & Governance', Icons.gavel_rounded, '/ai/governance', Colors.orangeAccent),
        _buildModuleLink(context, 'Prompt Evaluator', Icons.fact_check_rounded, '/ai/evaluation', Colors.pinkAccent),
        _buildModuleLink(context, 'Tool Registry', Icons.construction_rounded, '/ai/tools', Colors.greenAccent),
        _buildModuleLink(context, 'Skills Directory', Icons.psychology_rounded, '/ai/skills', Colors.tealAccent),
        _buildModuleLink(context, 'SRE Telemetry', Icons.query_stats_rounded, '/ai/observability', Colors.purpleAccent),
        _buildModuleLink(context, 'Policy Editor', Icons.policy_rounded, '/ai/policy', Colors.redAccent),
        _buildModuleLink(context, 'Memory Explorer', Icons.inventory_2_rounded, '/ai/memory-explorer', Colors.limeAccent),
        _buildModuleLink(context, 'Agent Debugger', Icons.bug_report_rounded, '/ai/debugger', Colors.amberAccent),
        _buildModuleLink(context, 'Golden Datasets', Icons.dataset_rounded, '/ai/datasets', Colors.blueAccent),
        _buildModuleLink(context, 'AB Test Labs', Icons.science_rounded, '/ai/experiments', Colors.indigoAccent),
      ],
    );
  }

  Widget _buildModuleLink(BuildContext context, String title, IconData icon, String route, Color accentColor) {
    return InkWell(
      onTap: () => context.push(route),
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
            Icon(icon, color: accentColor, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
