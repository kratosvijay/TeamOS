import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DigitalTwinDashboardScreen extends StatelessWidget {
  const DigitalTwinDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Digital Twin Platform', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                  Text('Digital Enterprise Operating System', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Observing, modeling, simulating, and optimizing the entire organization in real-time.', style: TextStyle(color: Color(0xFFE0E7FF), fontSize: 14)),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Stat Cards
            const Text('Digital Twin Telemetry', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildTelemetryGrid(context),
            const SizedBox(height: 32),

            // Modules Grid
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
      crossAxisCount: MediaQuery.of(context).size.width > 900 ? 4 : 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.3,
      children: [
        _buildStatCard('Twin Sync Status', 'SYNCHRONIZED', Colors.greenAccent),
        _buildStatCard('Event Bus Rate', '45 ev/sec', Colors.cyanAccent),
        _buildStatCard('SLA Compliance', '88.5%', Colors.amberAccent),
        _buildStatCard('Active Scenarios', '4 Simulated', Colors.pinkAccent),
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
        _buildModuleLink(context, 'Enterprise Map', Icons.account_tree_rounded, '/digital-twin/map', Colors.indigoAccent),
        _buildModuleLink(context, 'Org Simulator', Icons.sports_esports_rounded, '/digital-twin/simulator', Colors.cyanAccent),
        _buildModuleLink(context, 'Process Mining', Icons.analytics_rounded, '/digital-twin/process-mining', Colors.greenAccent),
        _buildModuleLink(context, 'Process Variants', Icons.difference_rounded, '/digital-twin/process-variants', Colors.orangeAccent),
        _buildModuleLink(context, 'Simulation List', Icons.list_alt_rounded, '/digital-twin/simulations', Colors.pinkAccent),
        _buildModuleLink(context, 'Simulation Builder', Icons.settings_rounded, '/digital-twin/simulation-builder', Colors.blueAccent),
        _buildModuleLink(context, 'Simulation Results', Icons.show_chart_rounded, '/digital-twin/simulation-results', Colors.tealAccent),
        _buildModuleLink(context, 'Optimization Viewer', Icons.calculate_rounded, '/digital-twin/optimization', Colors.purpleAccent),
        _buildModuleLink(context, 'Constraints Editor', Icons.gavel_rounded, '/digital-twin/optimization-constraints', Colors.limeAccent),
        _buildModuleLink(context, 'Executive Decision', Icons.domain_verification_rounded, '/digital-twin/decision-center', Colors.amberAccent),
        _buildModuleLink(context, 'Recommendation Center', Icons.tips_and_updates_rounded, '/digital-twin/recommendations', Colors.redAccent),
        _buildModuleLink(context, 'Enterprise Health', Icons.favorite_rounded, '/digital-twin/health', Colors.indigoAccent),
        _buildModuleLink(context, 'Strategic OKRs', Icons.flag_rounded, '/digital-twin/initiatives', Colors.pinkAccent),
        _buildModuleLink(context, 'KPI Metrics', Icons.speed_rounded, '/digital-twin/metrics', Colors.greenAccent),
        _buildModuleLink(context, 'Bottleneck Analysis', Icons.hourglass_bottom_rounded, '/digital-twin/bottlenecks', Colors.orangeAccent),
        _buildModuleLink(context, 'Value Stream Map', Icons.route_rounded, '/digital-twin/value-stream', Colors.tealAccent),
        _buildModuleLink(context, 'SLA Compliance', Icons.warning_amber_rounded, '/digital-twin/sla', Colors.blueAccent),
        _buildModuleLink(context, 'Workflow Timeline', Icons.timeline_rounded, '/digital-twin/process-map', Colors.purpleAccent),
        _buildModuleLink(context, 'Narrative Briefings', Icons.description_rounded, '/digital-twin/executive-briefing', Colors.redAccent),
        _buildModuleLink(context, 'Compare Scenarios', Icons.compare_rounded, '/digital-twin/scenario-comparison', Colors.amberAccent),
        _buildModuleLink(context, 'Capacity Tuning', Icons.tune_rounded, '/digital-twin/capacity-optimization', Colors.indigoAccent),
        _buildModuleLink(context, 'Investment Planning', Icons.trending_up_rounded, '/digital-twin/investment-planning', Colors.cyanAccent),
        _buildModuleLink(context, 'Risk Heatmap', Icons.grid_view_rounded, '/digital-twin/risk-heatmap', Colors.orangeAccent),
        _buildModuleLink(context, 'Console Overview', Icons.dashboard_rounded, '/digital-twin/overview', Colors.pinkAccent),
        _buildModuleLink(context, 'Simulation Templates', Icons.copy_all_rounded, '/digital-twin/simulation-templates', Colors.greenAccent),
        _buildModuleLink(context, 'Simulation Replay', Icons.play_circle_outline_rounded, '/digital-twin/simulation-replay', Colors.tealAccent),
        _buildModuleLink(context, 'Process Benchmarks', Icons.fact_check_rounded, '/digital-twin/process-benchmark', Colors.blueAccent),
        _buildModuleLink(context, 'Root Cause Analysis', Icons.psychology_rounded, '/digital-twin/root-cause', Colors.purpleAccent),
        _buildModuleLink(context, 'Approval Workflow', Icons.approval_rounded, '/digital-twin/recommendation-approval', Colors.redAccent),
        _buildModuleLink(context, 'Executive Scorecard', Icons.score_rounded, '/digital-twin/executive-scorecard', Colors.amberAccent),
        _buildModuleLink(context, 'Live Event Stream', Icons.rss_feed_rounded, '/digital-twin/event-stream', Colors.indigoAccent),
        _buildModuleLink(context, 'Event Replay Controls', Icons.replay_rounded, '/digital-twin/event-replay', Colors.cyanAccent),
        _buildModuleLink(context, 'Strategy Map', Icons.map_rounded, '/digital-twin/strategy-map', Colors.orangeAccent),
        _buildModuleLink(context, 'OKR Blockers', Icons.account_tree_outlined, '/digital-twin/initiative-dependencies', Colors.pinkAccent),
        _buildModuleLink(context, 'Time Machine Playback', Icons.history_toggle_off_rounded, '/digital-twin/time-machine', Colors.greenAccent),
        _buildModuleLink(context, 'Prediction Model Hub', Icons.batch_prediction_rounded, '/digital-twin/predictions', Colors.tealAccent),
        _buildModuleLink(context, 'Optimizer Marketplace', Icons.shopping_bag_rounded, '/digital-twin/optimization-marketplace', Colors.blueAccent),
        _buildModuleLink(context, 'Decision Audit History', Icons.history_edu_rounded, '/digital-twin/decision-history', Colors.purpleAccent),
        _buildModuleLink(context, 'Maturity Assessments', Icons.bar_chart_rounded, '/digital-twin/maturity', Colors.redAccent),
        _buildModuleLink(context, 'KPI Dependencies', Icons.hub_rounded, '/digital-twin/kpi-dependency-graph', Colors.amberAccent),
        _buildModuleLink(context, 'Scenario Branching', Icons.fork_right_rounded, '/digital-twin/scenario-branching', Colors.indigoAccent),
        _buildModuleLink(context, 'Confidence Calibration', Icons.track_changes_rounded, '/digital-twin/confidence-calibration', Colors.cyanAccent),
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
