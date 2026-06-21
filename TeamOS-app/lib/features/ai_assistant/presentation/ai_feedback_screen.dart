import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AIFeedbackScreen extends StatelessWidget {
  const AIFeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final feedbacks = [
      {'id': '1', 'rating': 'Positive', 'feedback': 'Task generation list was accurate and saved a lot of time.', 'date': 'June 20, 2026'},
      {'id': '2', 'rating': 'Negative', 'feedback': 'Summaries omitted task TOS-44 blocker dependencies details.', 'date': 'June 18, 2026'},
      {'id': '3', 'rating': 'Positive', 'feedback': 'Excellent explanation of the database migration steps.', 'date': 'June 14, 2026'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('AI User Feedback Logs', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24.0),
        itemCount: feedbacks.length,
        itemBuilder: (context, index) {
          final item = feedbacks[index];
          final isPositive = item['rating'] == 'Positive';
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  isPositive ? Icons.thumb_up_alt_rounded : Icons.thumb_down_alt_rounded,
                  color: isPositive ? Colors.greenAccent : Colors.redAccent,
                  size: 24,
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['feedback']!, style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5)),
                      const SizedBox(height: 8),
                      Text('Reviewed: ${item['date']}', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
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
