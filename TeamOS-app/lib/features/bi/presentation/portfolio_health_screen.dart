import 'package:flutter/material.dart';

class PortfolioHealthScreen extends StatefulWidget {
  const PortfolioHealthScreen({super.key});

  @override
  State<PortfolioHealthScreen> createState() => _PortfolioHealthScreenState();
}

class _PortfolioHealthScreenState extends State<PortfolioHealthScreen> {
  final List<StrategicGoal> _strategicGoals = [
    StrategicGoal(title: 'Migrate to Cloud Architecture', alignmentPct: 95, health: 'STABLE'),
    StrategicGoal(title: 'Achieve Compliance Controls', alignmentPct: 88, health: 'ON TRACK'),
    StrategicGoal(title: 'Automate Scaling Workflows', alignmentPct: 62, health: 'AT RISK'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Portfolio Health Analysis', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Strategic Portfolio Alignment',
              style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Assess structural alignments, velocity trends, active risk parameters, and delivery delays.',
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
            ),
            const SizedBox(height: 24),

            // Health parameters overview
            Row(
              children: [
                Expanded(
                  child: _buildParameterCard('Strategic Index', '91.2%', Icons.sync_alt, Colors.green),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildParameterCard('Risk Vulnerabilities', 'Low Risk', Icons.security, Colors.blue),
                ),
              ],
            ),
            const SizedBox(height: 24),

            const Text(
              'Portfolio Strategic Goals',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _strategicGoals.length,
              separatorBuilder: (context, idx) => const SizedBox(height: 12),
              itemBuilder: (context, idx) {
                final goal = _strategicGoals[idx];
                final statusColor = goal.health == 'STABLE' || goal.health == 'ON TRACK'
                    ? const Color(0xFF10B981)
                    : const Color(0xFFEF4444);

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
                            child: Text(goal.title, style: const TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              goal.health,
                              style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Alignment progress', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                          Text('${goal.alignmentPct}%', style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 13)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: goal.alignmentPct / 100,
                        backgroundColor: const Color(0xFF0F172A),
                        color: statusColor,
                        minHeight: 6,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParameterCard(String label, String value, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 16),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
        ],
      ),
    );
  }
}

class StrategicGoal {
  final String title;
  final int alignmentPct;
  final String health;

  StrategicGoal({required this.title, required this.alignmentPct, required this.health});
}
