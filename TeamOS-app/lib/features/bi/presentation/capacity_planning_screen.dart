import 'package:flutter/material.dart';

class CapacityPlanningScreen extends StatefulWidget {
  const CapacityPlanningScreen({super.key});

  @override
  State<CapacityPlanningScreen> createState() => _CapacityPlanningScreenState();
}

class _CapacityPlanningScreenState extends State<CapacityPlanningScreen> {
  final List<TeamCapacity> _teamCapacities = [
    TeamCapacity(teamName: 'Frontend Pod', totalHours: 320, loadHours: 280),
    TeamCapacity(teamName: 'Backend Core', totalHours: 480, loadHours: 410),
    TeamCapacity(teamName: 'Infrastructure & SRE', totalHours: 160, loadHours: 155),
    TeamCapacity(teamName: 'Product & QA', totalHours: 240, loadHours: 170),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Capacity Planning', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Workspace Capacity Analyzer',
              style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Examine availability budgets, sprint load factors, and team-specific limits.',
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
            ),
            const SizedBox(height: 24),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _teamCapacities.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final team = _teamCapacities[index];
                final progress = team.loadHours / team.totalHours;
                final remaining = team.totalHours - team.loadHours;
                final isOverloaded = progress > 0.90;

                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isOverloaded ? const Color(0xFFF59E0B) : const Color(0xFF334155)),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(team.teamName, style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                          Text(
                            '${(progress * 100).toInt()}% loaded',
                            style: TextStyle(
                              color: isOverloaded ? const Color(0xFFF59E0B) : const Color(0xFF10B981),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStat('Total Availability', '${team.totalHours} hrs'),
                          _buildStat('Sprint Load', '${team.loadHours} hrs'),
                          _buildStat('Remaining Margin', '$remaining hrs', color: isOverloaded ? const Color(0xFFEF4444) : const Color(0xFF10B981)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      LinearProgressIndicator(
                        value: progress.clamp(0.0, 1.0),
                        backgroundColor: const Color(0xFF0F172A),
                        color: isOverloaded ? const Color(0xFFF59E0B) : const Color(0xFF3B82F6),
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

  Widget _buildStat(String label, String value, {Color? color}) {
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

class TeamCapacity {
  final String teamName;
  final int totalHours;
  final int loadHours;

  TeamCapacity({required this.teamName, required this.totalHours, required this.loadHours});
}
