import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AIGovernanceScreen extends StatelessWidget {
  const AIGovernanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auditLogs = [
      {'id': '1', 'actor': 'System Runbook Builder', 'action': 'Executed AI Prompt Template Rollback to V3', 'date': 'June 20, 2026'},
      {'id': '2', 'actor': 'AI Coordinator Agent', 'action': 'Compiled Daily Workspace Memory Summary', 'date': 'June 18, 2026'},
      {'id': '3', 'actor': 'Workspace Admin', 'action': 'Configured Claude model router policies', 'date': 'June 14, 2026'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('AI Governance & Audits', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24.0),
        itemCount: auditLogs.length,
        itemBuilder: (context, index) {
          final item = auditLogs[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item['actor']!, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                    Text(item['date']!, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
                  ],
                ),
                const SizedBox(height: 12),
                Text(item['action']!, style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 13, height: 1.4)),
              ],
            ),
          );
        },
      ),
    );
  }
}
