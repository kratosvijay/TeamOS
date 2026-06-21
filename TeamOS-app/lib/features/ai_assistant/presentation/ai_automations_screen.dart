import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AIAutomationsScreen extends StatelessWidget {
  const AIAutomationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final automations = [
      {'id': '1', 'name': 'Friday Sprint Summary', 'trigger': 'Every Friday at 5:00 PM', 'action': 'Compile sprint stats and write report'},
      {'id': '2', 'name': 'Daily Standup Sync', 'trigger': 'Every weekday at 9:00 AM', 'action': 'Extract task updates and compile log'},
      {'id': '3', 'name': 'Post-Meeting Action Items', 'trigger': 'On Meeting Ended', 'action': 'Transcribe transcript and create action items'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('AI Automations', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24.0),
        itemCount: automations.length,
        itemBuilder: (context, index) {
          final item = automations[index];
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
                    Text(item['name']!, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    const Icon(Icons.electric_bolt_rounded, color: Colors.amberAccent, size: 20),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.schedule_rounded, color: Color(0xFF94A3B8), size: 16),
                    const SizedBox(width: 8),
                    Text('Trigger: ${item['trigger']}', style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.play_circle_outline_rounded, color: Color(0xFF94A3B8), size: 16),
                    const SizedBox(width: 8),
                    Expanded(child: Text('Action: ${item['action']}', style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 13))),
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
