import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProjectHealthScreen extends StatelessWidget {
  final String projectId;
  const ProjectHealthScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: Text('Project Health Score: $projectId', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
            // Main score circular tracker
            Center(
              child: Container(
                width: 160,
                height: 160,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF6366F1), width: 8),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('88', style: TextStyle(color: Colors.white, fontSize: 44, fontWeight: FontWeight.bold)),
                    Text('HEALTH SCORE', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Health parameters cards
            const Text('AI Risk Matrix Summary', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            _buildHealthItem('Delivery Risk Score', '12% - VERY LOW', Colors.greenAccent),
            _buildHealthItem('Burnout Risk Index', '38% - MODERATE', Colors.orangeAccent),
            _buildHealthItem('Dependency Blockers', '2 Active Blockers', Colors.redAccent),
            _buildHealthItem('Sprint Velocity Status', 'Stable (Forecast: 26pts)', Colors.blueAccent),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthItem(String title, String status, Color statusColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 15, fontWeight: FontWeight.w600)),
          Text(status, style: TextStyle(color: statusColor, fontSize: 15, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
