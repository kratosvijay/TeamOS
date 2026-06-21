import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AIUsageScreen extends StatelessWidget {
  const AIUsageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final usageLogs = [
      {'provider': 'OPENAI', 'model': 'gpt-4o', 'tokens': '1,280', 'cost': '\$0.024', 'latency': '1.1s'},
      {'provider': 'ANTHROPIC', 'model': 'claude-3-5-sonnet', 'tokens': '4,520', 'cost': '\$0.115', 'latency': '1.8s'},
      {'provider': 'GEMINI', 'model': 'gemini-1.5-flash', 'tokens': '2,400', 'cost': '\$0.009', 'latency': '0.6s'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('AI Cost & Usage Logs', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24.0),
        itemCount: usageLogs.length,
        itemBuilder: (context, index) {
          final item = usageLogs[index];
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['model']!, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text('Provider: ${item['provider']} | Latency: ${item['latency']}',
                        style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(item['cost']!, style: const TextStyle(color: Colors.greenAccent, fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('${item['tokens']} tokens', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
