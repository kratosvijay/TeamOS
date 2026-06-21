import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class MeetingActionItemsScreen extends HookWidget {
  final String meetingId;
  const MeetingActionItemsScreen({super.key, required this.meetingId});

  @override
  Widget build(BuildContext context) {
    // Mock action items
    final actionItems = useState<List<Map<String, dynamic>>>([
      {
        'id': 'a1',
        'title': 'Migrate database schema and deploy migrations',
        'assignee': 'Alex Martinez',
        'dueDate': 'June 23, 2026',
        'status': 'OPEN',
      },
      {
        'id': 'a2',
        'title': 'Verify LiveKit room token claims validation',
        'assignee': 'Sarah Jenkins',
        'dueDate': 'June 24, 2026',
        'status': 'IN_PROGRESS',
      },
    ]);

    void convertToTask(String id) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Action item converted to project Task successfully.'), backgroundColor: Colors.green),
      );
      actionItems.value = actionItems.value.where((a) => a['id'] != id).toList();
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Ceremony Action Items', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: actionItems.value.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.playlist_add_check_rounded, size: 64, color: Color(0xFF334155)),
                  SizedBox(height: 16),
                  Text('All action items completed', style: TextStyle(color: Color(0xFF64748B), fontSize: 15)),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(24),
              itemCount: actionItems.value.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final item = actionItems.value[index];

                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['title'] as String,
                              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Assignee: ${item['assignee']} • Due: ${item['dueDate']}',
                              style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        icon: const Icon(Icons.transform_rounded, color: Colors.white, size: 16),
                        label: const Text('Convert to Task', style: TextStyle(color: Colors.white)),
                        onPressed: () => convertToTask(item['id'] as String),
                      )
                    ],
                  ),
                );
              },
            ),
    );
  }
}
