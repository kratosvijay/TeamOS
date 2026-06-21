import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AIPromptRegistryScreen extends StatelessWidget {
  const AIPromptRegistryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prompts = [
      {'id': '1', 'name': 'Sprint Capacity Planner', 'category': 'SPRINT_PLANNER', 'version': 'V4', 'status': 'ACTIVE'},
      {'id': '2', 'name': 'Architecture Writer', 'category': 'TECHNICAL_WRITER', 'version': 'V2', 'status': 'ACTIVE'},
      {'id': '3', 'name': 'Executive Reporter', 'category': 'EXECUTIVE_REPORTER', 'version': 'V6', 'status': 'ACTIVE'},
      {'id': '4', 'name': 'Risk Scoring Prompt', 'category': 'RISK_ANALYST', 'version': 'V1', 'status': 'DEPRECATED'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('AI Prompt Registry', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24.0),
        itemCount: prompts.length,
        itemBuilder: (context, index) {
          final item = prompts[index];
          final isActive = item['status'] == 'ACTIVE';
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
                Icon(Icons.terminal_rounded, color: isActive ? Colors.greenAccent : Colors.grey, size: 28),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['name']!, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text('Category: ${item['category']} | Version: ${item['version']}',
                          style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isActive ? Colors.green.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    item['status']!,
                    style: TextStyle(color: isActive ? Colors.greenAccent : Colors.grey, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
