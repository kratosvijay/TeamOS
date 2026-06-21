import 'package:flutter/material.dart';

class DepartmentAnalyticsScreen extends StatefulWidget {
  const DepartmentAnalyticsScreen({super.key});

  @override
  State<DepartmentAnalyticsScreen> createState() => _DepartmentAnalyticsScreenState();
}

class _DepartmentAnalyticsScreenState extends State<DepartmentAnalyticsScreen> {
  final List<DepartmentData> _departments = [
    DepartmentData(
      name: 'Engineering Core',
      velocity: '45 pts/sprint',
      resourceCount: 18,
      budgetUsed: 82.5,
      tasksCompleted: 140,
      openIncidents: 0,
    ),
    DepartmentData(
      name: 'Cyber Security Operations',
      velocity: 'N/A',
      resourceCount: 5,
      budgetUsed: 62.0,
      tasksCompleted: 45,
      openIncidents: 1,
    ),
    DepartmentData(
      name: 'Product & Design',
      velocity: '24 pts/sprint',
      resourceCount: 8,
      budgetUsed: 71.3,
      tasksCompleted: 58,
      openIncidents: 0,
    ),
    DepartmentData(
      name: 'Sales & Growth',
      velocity: 'N/A',
      resourceCount: 12,
      budgetUsed: 89.1,
      tasksCompleted: 92,
      openIncidents: 0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Department Analytics', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cross-Department Alignments',
              style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Drill down into structural KPIs, headcount distributions, budget consumption, and security workloads.',
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
            ),
            const SizedBox(height: 24),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _departments.length,
              separatorBuilder: (context, idx) => const SizedBox(height: 16),
              itemBuilder: (context, idx) {
                final dept = _departments[idx];
                final budgetColor = dept.budgetUsed >= 85
                    ? const Color(0xFFEF4444)
                    : (dept.budgetUsed >= 70 ? const Color(0xFFF59E0B) : const Color(0xFF10B981));

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
                          Text(dept.name, style: const TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold)),
                          Text('${dept.resourceCount} staff members', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                        ],
                      ),
                      const Divider(color: Color(0xFF334155), height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildDeptStat('Velocity', dept.velocity),
                          _buildDeptStat('Tasks Completed', '${dept.tasksCompleted}'),
                          _buildDeptStat('Open Incidents', '${dept.openIncidents}', color: dept.openIncidents > 0 ? const Color(0xFFEF4444) : null),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Budget Consumption', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                          Text('${dept.budgetUsed}%', style: TextStyle(color: budgetColor, fontWeight: FontWeight.bold, fontSize: 13)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: dept.budgetUsed / 100,
                        backgroundColor: const Color(0xFF0F172A),
                        color: budgetColor,
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

  Widget _buildDeptStat(String label, String val, {Color? color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
        const SizedBox(height: 4),
        Text(
          val,
          style: TextStyle(color: color ?? Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ],
    );
  }
}

class DepartmentData {
  final String name;
  final String velocity;
  final int resourceCount;
  final double budgetUsed;
  final int tasksCompleted;
  final int openIncidents;

  DepartmentData({
    required this.name,
    required this.velocity,
    required this.resourceCount,
    required this.budgetUsed,
    required this.tasksCompleted,
    required this.openIncidents,
  });
}
