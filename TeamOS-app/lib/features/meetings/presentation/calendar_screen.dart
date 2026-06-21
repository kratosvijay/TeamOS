import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class CalendarScreen extends HookWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedMonth = useState<String>('June 2026');

    // Mock calendar events
    final events = [
      {'day': 10, 'title': 'Sprint 1 Planning', 'type': 'CEREMONY'},
      {'day': 15, 'title': 'TOS-101 Migration Deadline', 'type': 'TASK'},
      {'day': 21, 'title': 'Project Architecture Review', 'type': 'MEETING'},
      {'day': 24, 'title': 'Sprint 1 Retrospective', 'type': 'CEREMONY'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Ceremonies Calendar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Calendar month selector header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(icon: const Icon(Icons.chevron_left_rounded, color: Colors.white), onPressed: () {}),
                    Text(selectedMonth.value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    IconButton(icon: const Icon(Icons.chevron_right_rounded, color: Colors.white), onPressed: () {}),
                  ],
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF334155)),
                  icon: const Icon(Icons.sync_rounded, color: Colors.white),
                  label: const Text('Sync External', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Synchronizing with Google/Outlook calendar providers...')),
                    );
                  },
                )
              ],
            ),
            const SizedBox(height: 24),
            // Monthly Calendar Grid
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.1,
                ),
                itemCount: 35, // 5 weeks grid slots
                itemBuilder: (context, index) {
                  final dayNumber = index - 2; // Mock offset starting Tuesday
                  final isValidDay = dayNumber > 0 && dayNumber <= 30;

                  final dayEvents = events.where((e) => e['day'] == dayNumber).toList();

                  return Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isValidDay ? const Color(0xFF1E293B) : const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: dayEvents.isNotEmpty ? const Color(0xFF3B82F6) : const Color(0xFF334155),
                        width: dayEvents.isNotEmpty ? 1.5 : 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isValidDay ? '$dayNumber' : '',
                          style: TextStyle(
                            color: isValidDay ? Colors.white : const Color(0xFF334155),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        if (isValidDay && dayEvents.isNotEmpty) ...[
                          const Spacer(),
                          ...dayEvents.map((e) {
                            Color badgeColor = Colors.blueAccent;
                            if (e['type'] == 'CEREMONY') badgeColor = Colors.amberAccent;
                            if (e['type'] == 'TASK') badgeColor = Colors.redAccent;

                            return Container(
                              margin: const EdgeInsets.only(top: 4),
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                              width: double.infinity,
                              decoration: BoxDecoration(color: badgeColor.withOpacity(0.15), borderRadius: BorderRadius.circular(4)),
                              child: Text(
                                e['title'] as String,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: badgeColor, fontSize: 9, fontWeight: FontWeight.bold),
                              ),
                            );
                          }).toList(),
                        ]
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
