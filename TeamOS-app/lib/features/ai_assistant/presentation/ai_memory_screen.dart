import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AIMemoryScreen extends StatelessWidget {
  const AIMemoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Long Term AI Memory', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
            const Text('Consolidated Memory Summary', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Workspace Context Aggregated Timeline:',
                    style: TextStyle(color: Colors.cyanAccent, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'The engineering team is currently executing the pgvector and OpenSearch hybrid RAG modules. '
                    'Decisions completed: Yjs updates are buffered inside a Redis server and merged every 5 seconds. '
                    'Weekly summary automations run every Friday at 5:00 PM PST. '
                    'Project Leads review task updates daily at 9:00 AM PST.',
                    style: TextStyle(color: Color(0xFFCBD5E1), fontSize: 13, height: 1.6),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
