import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AIWorkflowsScreen extends StatelessWidget {
  const AIWorkflowsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final workflows = [
      {'name': 'Sprint Planning Workflow', 'desc': 'Triggers capacity suggestions, story allocations, and risks checks.'},
      {'name': 'Release Planning Workflow', 'desc': 'Scans closed tasks and generates draft technical specifications.'},
      {'name': 'Incident Response Workflow', 'desc': 'Indexes server warnings and drafts rollback suggestions.'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Agent Workflows', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24.0),
        itemCount: workflows.length,
        itemBuilder: (context, index) {
          final item = workflows[index];
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
                const Icon(Icons.account_tree_outlined, color: Colors.indigoAccent, size: 30),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['name']!, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text(item['desc']!, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13, height: 1.4)),
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
