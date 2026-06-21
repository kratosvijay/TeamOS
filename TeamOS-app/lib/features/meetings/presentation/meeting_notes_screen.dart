import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class MeetingNotesScreen extends HookWidget {
  final String meetingId;
  const MeetingNotesScreen({super.key, required this.meetingId});

  @override
  Widget build(BuildContext context) {
    final noteController = useTextEditingController(
      text: '# Architecture Review - Meeting Notes\n\n'
          '## Agenda:\n'
          '- Refactor database schema and execute migration.\n'
          '- Implement NestJS MinIO StorageService wrapper.\n'
          '- Mock LiveKit tokens based on participant role mappings.\n\n'
          '## Meeting Action Items:\n'
          '- [ ] configure MinIO credentials\n'
          '- [ ] finalize meeting.gateway.ts socket testing\n',
    );

    void handleSave() {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Meeting notes saved successfully.'), backgroundColor: Colors.green),
      );
      context.pop();
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Edit Meeting Notes', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check_rounded, color: Colors.greenAccent),
            onPressed: handleSave,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Formatting tool belt bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Row(
                children: [
                  IconButton(icon: const Icon(Icons.format_bold_rounded, color: Colors.white, size: 20), onPressed: () {}),
                  IconButton(icon: const Icon(Icons.format_italic_rounded, color: Colors.white, size: 20), onPressed: () {}),
                  IconButton(icon: const Icon(Icons.format_list_bulleted_rounded, color: Colors.white, size: 20), onPressed: () {}),
                  IconButton(icon: const Icon(Icons.format_list_numbered_rounded, color: Colors.white, size: 20), onPressed: () {}),
                  IconButton(icon: const Icon(Icons.link_rounded, color: Colors.white, size: 20), onPressed: () {}),
                  const VerticalDivider(color: Color(0xFF334155), width: 24, thickness: 1.5),
                  IconButton(icon: const Icon(Icons.task_alt_rounded, color: Colors.white, size: 20), onPressed: () {}),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Text area Editor
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: TextField(
                  controller: noteController,
                  maxLines: null,
                  style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 14, height: 1.6),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Start writing notes...',
                    hintStyle: TextStyle(color: Color(0xFF64748B)),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
