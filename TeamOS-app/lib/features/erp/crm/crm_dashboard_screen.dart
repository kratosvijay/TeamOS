import 'package:flutter/material.dart';

class CrmDashboardScreen extends StatelessWidget {
  const CrmDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('CRM Dashboard', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sales Performance Overview',
              style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Track sales funnel conversions, monitor active leads, and review deals close probability.',
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: _buildMetricCard('PIPELINE VALUE', '\$2.4M', Colors.blue)),
                const SizedBox(width: 12),
                Expanded(child: _buildMetricCard('DEALS WON', '18', Colors.green)),
                const SizedBox(width: 12),
                Expanded(child: _buildMetricCard('HOT LEADS', '9', Colors.red)),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Pipeline Stage Allocation',
              style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildPipelineBar('Prospecting', 12, Colors.blue),
                  const SizedBox(height: 12),
                  _buildPipelineBar('Proposal Sent', 6, Colors.purple),
                  const SizedBox(height: 12),
                  _buildPipelineBar('Negotiation', 4, Colors.amber),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildPipelineBar(String stage, int count, Color color) {
    return Row(
      children: [
        SizedBox(width: 100, child: Text(stage, style: const TextStyle(color: Colors.white, fontSize: 13))),
        const SizedBox(width: 12),
        Expanded(
          child: LinearProgressIndicator(
            value: count / 15.0,
            backgroundColor: const Color(0xFF334155),
            color: color,
            minHeight: 8,
          ),
        ),
        const SizedBox(width: 12),
        Text('$count deals', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
      ],
    );
  }
}
