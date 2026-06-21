import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AIModelPolicyScreen extends StatelessWidget {
  const AIModelPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final policies = [
      {'task': 'Chat Queries', 'provider': 'OPENAI', 'model': 'GPT-4o', 'cost': '\$0.015 / 1k'},
      {'task': 'Technical Specifications', 'provider': 'ANTHROPIC', 'model': 'Claude 3.5 Sonnet', 'cost': '\$0.024 / 1k'},
      {'task': 'Semantic Knowledge Search', 'provider': 'GEMINI', 'model': 'Gemini 1.5 Flash', 'cost': '\$0.004 / 1k'},
      {'task': 'Meeting Summaries', 'provider': 'OPENAI', 'model': 'GPT-4o-mini', 'cost': '\$0.005 / 1k'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('AI Model Routing Policy', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24.0),
        itemCount: policies.length,
        itemBuilder: (context, index) {
          final item = policies[index];
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
                const Icon(Icons.route_rounded, color: Color(0xFF6366F1), size: 28),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['task']!, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text('Route: ${item['provider']} (${item['model']})', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item['cost']!,
                    style: const TextStyle(color: Colors.greenAccent, fontSize: 11, fontWeight: FontWeight.bold),
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
