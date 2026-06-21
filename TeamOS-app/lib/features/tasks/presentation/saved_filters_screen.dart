import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class SavedFiltersScreen extends HookWidget {
  const SavedFiltersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock saved filters
    final filters = useState<List<Map<String, dynamic>>>([
      {
        'id': '1',
        'name': 'My In-Progress Bugs',
        'isShared': false,
        'query': {'status': 'IN_PROGRESS', 'type': 'BUG', 'assignee': 'me'}
      },
      {
        'id': '2',
        'name': 'Sprint 1 Critical Blockers',
        'isShared': true,
        'query': {'status': 'TODO', 'priority': 'CRITICAL', 'sprint': 'Sprint 1'}
      },
      {
        'id': '3',
        'name': 'Done Stories',
        'isShared': false,
        'query': {'status': 'DONE', 'type': 'STORY'}
      },
    ]);

    void deleteFilter(String id) {
      filters.value = filters.value.where((f) => f['id'] != id).toList();
    }

    void toggleShare(String id) {
      filters.value = filters.value.map((f) {
        if (f['id'] == id) {
          return {...f, 'isShared': !(f['isShared'] as bool)};
        }
        return f;
      }).toList();
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Saved Filters', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1E293B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(24),
        itemCount: filters.value.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final filter = filters.value[index];
          final query = filter['query'] as Map<String, dynamic>;
          final isShared = filter['isShared'] as bool;

          return Container(
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
                    Row(
                      children: [
                        Text(filter['name'] as String, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 8),
                        Icon(
                          isShared ? Icons.people_outline_rounded : Icons.lock_outline_rounded,
                          size: 16,
                          color: isShared ? Colors.blueAccent : const Color(0xFF64748B),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            isShared ? Icons.share_rounded : Icons.share_location_rounded,
                            color: isShared ? Colors.amberAccent : const Color(0xFF64748B),
                            size: 20,
                          ),
                          tooltip: isShared ? 'Make Private' : 'Share with Workspace',
                          onPressed: () => toggleShare(filter['id'] as String),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
                          onPressed: () => deleteFilter(filter['id'] as String),
                        )
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: query.entries.map((entry) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        '${entry.key}: ${entry.value}',
                        style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                      ),
                    );
                  }).toList(),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
