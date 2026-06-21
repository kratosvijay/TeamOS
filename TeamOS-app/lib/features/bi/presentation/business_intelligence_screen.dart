import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BusinessIntelligenceScreen extends StatelessWidget {
  const BusinessIntelligenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Business Intelligence', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.corporate_fare, color: Colors.white),
            onPressed: () => context.push('/business-intelligence/departments'),
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
                  'Corporate BI Analytics',
                  style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: () => context.push('/business-intelligence/departments'),
                  icon: const Icon(Icons.bar_chart, color: Color(0xFF3B82F6), size: 16),
                  label: const Text('Departments', style: TextStyle(color: Color(0xFF3B82F6), fontSize: 13)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Workspace velocity trends, AI platform productivity, meeting ratios, and department outcomes.',
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
            ),
            const SizedBox(height: 24),

            // Metrics overview cards
            _buildTrendCard(
              title: 'Sprint Velocity Trends',
              desc: 'Average story points delivered per sprint across workspaces.',
              currentVal: '42.5 pts',
              changeVal: '+12.4% from last month',
              isPositive: true,
            ),
            const SizedBox(height: 16),
            _buildTrendCard(
              title: 'Delivery Speed (Cycle Time)',
              desc: 'Average days taken to complete high priority tickets.',
              currentVal: '3.2 Days',
              changeVal: '-15.8% (faster resolution)',
              isPositive: true,
            ),
            const SizedBox(height: 16),
            _buildTrendCard(
              title: 'Meeting Overhead ratio',
              desc: 'Percentage of engineer hours spent in video conferencing.',
              currentVal: '14.2%',
              changeVal: '+2.1% (increasing meeting load)',
              isPositive: false,
            ),
            const SizedBox(height: 16),
            _buildTrendCard(
              title: 'AI Assisted Coding Speedup',
              desc: 'Task resolution acceleration when utilizing copilot prompts.',
              currentVal: '1.48x',
              changeVal: '+8.3% token utilization efficiency',
              isPositive: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendCard({
    required String title,
    required String desc,
    required String currentVal,
    required String changeVal,
    required bool isPositive,
  }) {
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
              Text(title, style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
              Icon(
                isPositive ? Icons.trending_up : Icons.trending_down,
                color: isPositive ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(desc, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
          const Divider(color: Color(0xFF334155), height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(currentVal, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              Text(
                changeVal,
                style: TextStyle(
                  color: isPositive ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
