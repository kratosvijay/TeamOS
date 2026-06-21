import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class ListViewScreen extends HookWidget {
  const ListViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock task list
    final tasks = useState<List<Map<String, dynamic>>>([
      {'id': '1', 'key': 'TOS-101', 'title': 'Design DB schema', 'type': 'TASK', 'status': 'DONE', 'priority': 'HIGH', 'selected': false},
      {'id': '2', 'key': 'TOS-102', 'title': 'Implement auth gateway', 'type': 'STORY', 'status': 'IN_PROGRESS', 'priority': 'CRITICAL', 'selected': false},
      {'id': '3', 'key': 'TOS-103', 'title': 'Configure FCM notifications', 'type': 'TASK', 'status': 'TODO', 'priority': 'MEDIUM', 'selected': false},
      {'id': '4', 'key': 'TOS-104', 'title': 'Socket connection fails on web client', 'type': 'BUG', 'status': 'IN_REVIEW', 'priority': 'CRITICAL', 'selected': false},
      {'id': '5', 'key': 'TOS-105', 'title': 'Setup S3 MinIO storage bucket', 'type': 'TASK', 'status': 'TODO', 'priority': 'LOW', 'selected': false},
    ]);

    final isBulkMode = useState<bool>(false);

    void toggleSelect(int index) {
      final updated = List<Map<String, dynamic>>.from(tasks.value);
      updated[index]['selected'] = !(updated[index]['selected'] as bool);
      tasks.value = updated;

      // Check if any task is selected to toggle bulk mode
      isBulkMode.value = updated.any((t) => t['selected'] as bool);
    }

    void deselectAll() {
      tasks.value = tasks.value.map((t) => {...t, 'selected': false}).toList();
      isBulkMode.value = false;
    }

    void bulkUpdateStatus(String newStatus) {
      final selectedKeys = tasks.value.where((t) => t['selected'] as bool).map((t) => t['key']).join(', ');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bulk updated status to $newStatus for issues: $selectedKeys'),
          backgroundColor: Colors.green,
        ),
      );
      deselectAll();
    }

    void bulkDelete() {
      final selectedKeys = tasks.value.where((t) => t['selected'] as bool).map((t) => t['key']).join(', ');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bulk deleted issues: $selectedKeys'),
          backgroundColor: Colors.redAccent,
        ),
      );
      tasks.value = tasks.value.where((t) => !(t['selected'] as bool)).toList();
      deselectAll();
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Flat List Navigator', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1E293B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (isBulkMode.value) ...[
            PopupMenuButton<String>(
              icon: const Icon(Icons.edit_road_rounded, color: Colors.amberAccent),
              onSelected: bulkUpdateStatus,
              color: const Color(0xFF1E293B),
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'TODO', child: Text('Move to Todo', style: TextStyle(color: Colors.white))),
                const PopupMenuItem(value: 'IN_PROGRESS', child: Text('Move to In Progress', style: TextStyle(color: Colors.white))),
                const PopupMenuItem(value: 'DONE', child: Text('Move to Done', style: TextStyle(color: Colors.white))),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.delete_sweep_rounded, color: Colors.redAccent),
              onPressed: bulkDelete,
            ),
            IconButton(
              icon: const Icon(Icons.close_rounded, color: Colors.white),
              onPressed: deselectAll,
            ),
          ]
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(24),
        itemCount: tasks.value.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final task = tasks.value[index];
          final selected = task['selected'] as bool;

          return InkWell(
            onLongPress: () => toggleSelect(index),
            onTap: () {
              if (isBulkMode.value) {
                toggleSelect(index);
              }
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: selected ? const Color(0xFF1E293B).withOpacity(0.8) : const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selected ? const Color(0xFF3B82F6) : const Color(0xFF334155),
                  width: selected ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  if (isBulkMode.value) ...[
                    Checkbox(
                      value: selected,
                      activeColor: const Color(0xFF3B82F6),
                      onChanged: (val) => toggleSelect(index),
                    ),
                    const SizedBox(width: 12),
                  ],
                  // Task key type tag
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: task['type'] == 'BUG'
                          ? Colors.red.withOpacity(0.15)
                          : Colors.blue.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      task['type'] as String,
                      style: TextStyle(
                        color: task['type'] == 'BUG' ? Colors.redAccent : Colors.blueAccent,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${task['key']} - ${task['title']}',
                          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              'Status: ${task['status']}',
                              style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Priority: ${task['priority']}',
                              style: TextStyle(
                                color: task['priority'] == 'CRITICAL' ? Colors.redAccent : const Color(0xFF64748B),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
