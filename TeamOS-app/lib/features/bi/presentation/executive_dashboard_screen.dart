import 'package:flutter/material.dart';

class ExecutiveDashboardScreen extends StatelessWidget {
  const ExecutiveDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Executive Overview', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Executive Operating System',
              style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'High-level metrics, financial health, compliance, security posture, and strategic risk indexes.',
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
            ),
            const SizedBox(height: 24),

            // Grid of Widgets
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.15,
              children: [
                _buildStatCard('Monthly Recurring Revenue', '\$145,200', 'MRR', Icons.account_balance_wallet, Colors.blue),
                _buildStatCard('Annual Recurring Revenue', '\$1.74M', 'ARR', Icons.trending_up, Colors.green),
                _buildProgressWidgetCard('Workspace Health', 'Avg 84%', 0.84, Colors.teal),
                _buildProgressWidgetCard('Compliance Score', 'SOC2 / ISO 94%', 0.94, Colors.purple),
                _buildProgressWidgetCard('Security Score', 'No Critical Risks 98%', 0.98, Colors.indigo),
                _buildProgressWidgetCard('Portfolio Health', 'Stable Alignment 89%', 0.89, Colors.purple),
                _buildAlertCard('Strategic Risks', '2 Sprints Delayed', 'HIGH RISK', Icons.gavel, Colors.amber),
                _buildAlertCard('Delivery Forecast', 'SaaS Phase V: Aug 12', 'ON TRACK', Icons.offline_pin, Colors.green),
                _buildProgressWidgetCard('Capacity Forecast', 'Remaining 28%', 0.28, Colors.orange),
                _buildProgressWidgetCard('Resource Utilization', 'Allocated 82%', 0.82, Colors.pink),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, String subtitle, IconData icon, Color color) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(subtitle, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11)),
              Icon(icon, color: color, size: 18),
            ],
          ),
          const Spacer(),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildProgressWidgetCard(String title, String status, double progress, Color color) {
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
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(status, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
          const Spacer(),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: const Color(0xFF0F172A),
            color: color,
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertCard(String title, String status, String alertText, IconData icon, Color color) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
              ),
              Icon(icon, color: color, size: 16),
            ],
          ),
          const Spacer(),
          Text(status, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              alertText,
              style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }
}
