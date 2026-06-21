import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class MeetingDecisionsScreen extends HookWidget {
  final String meetingId;
  const MeetingDecisionsScreen({super.key, required this.meetingId});

  @override
  Widget build(BuildContext context) {
    final searchController = useTextEditingController();
    final decisions = useState<List<Map<String, String>>>([
      {
        'id': 'd1',
        'decision': 'Approve release candidate v1.2 and push to staging',
        'creator': 'Sarah Jenkins',
        'date': 'Today, 10:30 AM',
      },
      {
        'id': 'd2',
        'decision': 'Store recording segments in MinIO bucket path instead of local file system',
        'creator': 'Alex Martinez',
        'date': 'Today, 10:35 AM',
      },
      {
        'id': 'd3',
        'decision': 'Adopt Google Calendar sync provider for all project ceremonies',
        'creator': 'John Doe',
        'date': 'Yesterday, 4:15 PM',
      },
    ]);

    final filtered = useState<List<Map<String, String>>>(decisions.value);

    void filterDecisions(String text) {
      if (text.trim().isEmpty) {
        filtered.value = decisions.value;
      } else {
        filtered.value = decisions.value
            .where((d) => d['decision']!.toLowerCase().contains(text.toLowerCase()) || d['creator']!.toLowerCase().contains(text.toLowerCase()))
            .toList();
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Logged Decisions', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          // Search box
          Container(
            padding: const EdgeInsets.all(20),
            color: const Color(0xFF1E293B),
            child: TextField(
              controller: searchController,
              onChanged: filterDecisions,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search logged decisions...',
                hintStyle: const TextStyle(color: Color(0xFF64748B)),
                prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF64748B)),
                filled: true,
                fillColor: const Color(0xFF0F172A),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          // Decisions List
          Expanded(
            child: filtered.value.isEmpty
                ? const Center(child: Text('No matching decisions found', style: TextStyle(color: Color(0xFF64748B))))
                : ListView.separated(
                    padding: const EdgeInsets.all(24),
                    itemCount: filtered.value.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final item = filtered.value[index];

                      return Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFF334155)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.gavel_rounded, color: Colors.amberAccent, size: 24),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['decision']!,
                                    style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.4),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Logged by ${item['creator']} • ${item['date']}',
                                    style: const TextStyle(color: Color(0xFF64748B), fontSize: 11),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
