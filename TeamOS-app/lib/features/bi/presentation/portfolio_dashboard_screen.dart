import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PortfolioDashboardScreen extends StatelessWidget {
  const PortfolioDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Strategic Portfolios', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.hub, color: Colors.white),
            onPressed: () => context.push('/programs'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enterprise Portfolios',
              style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Track high-level portfolios, workspace mappings, strategic alignments, and velocities.',
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
            ),
            const SizedBox(height: 24),

            // Portfolios List
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildPortfolioCard(
                  context,
                  title: 'Engineering Strategic Portfolio',
                  desc: 'Core architecture expansion, security migrations, and cloud delivery.',
                  health: 92,
                  risk: 'LOW',
                  velocity: '45 pts/sprint',
                  workspaces: 3,
                ),
                const SizedBox(height: 16),
                _buildPortfolioCard(
                  context,
                  title: 'Enterprise Growth Portfolio',
                  desc: 'Billing improvements, CRM syncing, and marketing hubs.',
                  health: 68,
                  risk: 'MEDIUM',
                  velocity: '28 pts/sprint',
                  workspaces: 2,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPortfolioCard(
    BuildContext context, {
    required String title,
    required String desc,
    required int health,
    required String risk,
    required String velocity,
    required int workspaces,
  }) {
    final healthColor = health >= 80
        ? const Color(0xFF10B981)
        : (health >= 60 ? const Color(0xFFF59E0B) : const Color(0xFFEF4444));

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              CircleAvatar(
                radius: 24,
                backgroundColor: healthColor.withOpacity(0.1),
                child: Text(
                  '$health%',
                  style: TextStyle(color: healthColor, fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(desc, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
          const Divider(color: Color(0xFF334155), height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMeta('Risk Level', risk, color: risk == 'HIGH' ? Colors.red : (risk == 'MEDIUM' ? Colors.amber : Colors.green)),
              _buildMeta('Velocity', velocity),
              _buildMeta('Workspaces', '$workspaces linked'),
            ],
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => context.push('/portfolio/health'),
              icon: const Icon(Icons.analytics, color: Color(0xFF3B82F6)),
              label: const Text('View Health Analysis', style: TextStyle(color: Color(0xFF3B82F6))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeta(String label, String value, {Color? color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(color: color ?? Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ],
    );
  }
}
