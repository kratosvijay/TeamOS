import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AIAgentsScreen extends StatelessWidget {
  const AIAgentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final agents = [
      {'name': 'Sprint Planner', 'purpose': 'Sprint capacity planning and velocity trend calculations'},
      {'name': 'Technical Writer', 'purpose': 'PRDs, design documents, and release notes generator'},
      {'name': 'Project Manager', 'purpose': 'Task allocations and dependencies calculations'},
      {'name': 'Risk Analyst', 'purpose': 'Burnout rates and project health scoring engine'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Dynamic AI Agents', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24.0),
        itemCount: agents.length,
        itemBuilder: (context, index) {
          final item = agents[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Row(
              children: [
                const Icon(Icons.smart_toy_outlined, color: Colors.cyanAccent, size: 32),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['name']!, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text(item['purpose']!, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13, height: 1.4)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
