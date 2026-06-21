import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WorkflowDashboardScreen extends StatefulWidget {
  const WorkflowDashboardScreen({super.key});

  @override
  State<WorkflowDashboardScreen> createState() => _WorkflowDashboardScreenState();
}

class _WorkflowDashboardScreenState extends State<WorkflowDashboardScreen> {
  final List<WorkflowItem> _workflows = [
    WorkflowItem(id: '1', name: 'GitHub PR Code Review Automation', status: 'ACTIVE', executions: 45, failures: 1, slaBreaches: 0),
    WorkflowItem(id: '2', name: 'Leave Application & HR Approval', status: 'ACTIVE', executions: 12, failures: 0, slaBreaches: 2),
    WorkflowItem(id: '3', name: 'Procurement CAPEX Dispatch Flow', status: 'PAUSED', executions: 8, failures: 2, slaBreaches: 1),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Workflow Automation Center', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
            onPressed: () => context.push('/workflows/marketplace'),
          ),
          IconButton(
            icon: const Icon(Icons.analytics_outlined, color: Colors.white),
            onPressed: () => context.push('/workflows/analytics'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Workflow Orchestration',
                  style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () => context.push('/workflows/builder'),
                  icon: const Icon(Icons.add, color: Colors.white, size: 16),
                  label: const Text('Create Flow', style: TextStyle(color: Colors.white, fontSize: 13)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Automate cross-workspace tasks, set up timers, approval chains, and integrate custom APIs.',
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
            ),
            const SizedBox(height: 24),

            // Aggregate Quick Metrics Row
            Row(
              children: [
                Expanded(child: _buildMetricTile('ACTIVE FLOWS', '2', Colors.green)),
                const SizedBox(width: 12),
                Expanded(child: _buildMetricTile('RUNNING RUNS', '65', Colors.blue)),
                const SizedBox(width: 12),
                Expanded(child: _buildMetricTile('SLA BREACHES', '3', Colors.amber)),
              ],
            ),
            const SizedBox(height: 24),

            const Text(
              'Workspace Automation Flows',
              style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _workflows.length,
              separatorBuilder: (context, idx) => const SizedBox(height: 16),
              itemBuilder: (context, idx) {
                final flow = _workflows[idx];
                final statusColor = flow.status == 'ACTIVE' ? const Color(0xFF10B981) : const Color(0xFFF59E0B);
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
                            child: Text(flow.name, style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              flow.status,
                              style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const Divider(color: Color(0xFF334155), height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildDetailCol('Total Runs', '${flow.executions}'),
                          _buildDetailCol('Failures', '${flow.failures}', color: flow.failures > 0 ? const Color(0xFFEF4444) : null),
                          _buildDetailCol('SLA Breaches', '${flow.slaBreaches}', color: flow.slaBreaches > 0 ? const Color(0xFFF59E0B) : null),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(
                            onPressed: () => context.push('/workflows/executions'),
                            icon: const Icon(Icons.history, size: 16, color: Color(0xFF3B82F6)),
                            label: const Text('Executions History', style: TextStyle(color: Color(0xFF3B82F6), fontSize: 13)),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1E293B),
                              side: const BorderSide(color: Color(0xFF334155)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Workflow "${flow.name}" triggered manually')),
                              );
                            },
                            icon: const Icon(Icons.play_arrow, size: 16, color: Colors.white),
                            label: const Text('Run Flow', style: TextStyle(color: Colors.white, fontSize: 13)),
                          ),
                        ],
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

  Widget _buildMetricTile(String label, String val, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Column(
        children: [
          Text(val, style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 9, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildDetailCol(String label, String val, {Color? color}) {
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

class WorkflowItem {
  final String id;
  final String name;
  final String status;
  final int executions;
  final int failures;
  final int slaBreaches;

  WorkflowItem({
    required this.id,
    required this.name,
    required this.status,
    required this.executions,
    required this.failures,
    required this.slaBreaches,
  });
}
