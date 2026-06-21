import 'package:flutter/material.dart';

class WorkflowAnalyticsScreen extends StatelessWidget {
  const WorkflowAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Workflow Analytics', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Automation Performance Metrics',
              style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Audit workflow runs success rates, monitor SLA compliance, and examine execution bottleneck points.',
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
            ),
            const SizedBox(height: 24),

            // Performance indicators
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard('Success Rate', '93.7%', Colors.green, '105 of 112 runs complete'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildMetricCard('Avg Duration', '14.2m', Colors.blue, 'Excluding manual holds'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: _buildMetricCard('SLA Breaches', '3 Runs', Colors.orange, 'Awaiting approvals'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildMetricCard('Failure Rate', '6.3%', Colors.red, '7 execution retries logged'),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Bottleneck Section
            const Text(
              'Node Execution Bottlenecks',
              style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            _buildBottleneckCard(
              nodeName: 'HR Manager Review Signoff',
              type: 'APPROVAL',
              delayText: 'Avg delay: 4.8 hours',
              recommendation: 'Recommend adding a 12h delegation escalation rule.',
            ),
            const SizedBox(height: 12),
            _buildBottleneckCard(
              nodeName: 'AWS Sandbox Provisioning Webhook',
              type: 'WEBHOOK',
              delayText: 'Avg latency: 28 seconds (8% retries)',
              recommendation: 'API gateway timeout alert. Check endpoint keepalive connection limits.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, Color color, String subtitle) {
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
          Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text(value, style: TextStyle(color: color, fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(subtitle, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildBottleneckCard({
    required String nodeName,
    required String type,
    required String delayText,
    required String recommendation,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(nodeName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  type,
                  style: const TextStyle(color: Color(0xFF3B82F6), fontSize: 9, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(delayText, style: const TextStyle(color: Color(0xFFF59E0B), fontSize: 12, fontWeight: FontWeight.bold)),
          const Divider(color: Color(0xFF334155), height: 24),
          Row(
            children: [
              const Icon(Icons.lightbulb_outline, color: Color(0xFF10B981), size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  recommendation,
                  style: const TextStyle(color: Color(0xFF10B981), fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
