import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TimelineViewScreen extends StatelessWidget {
  const TimelineViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock scheduling tasks
    final tasks = [
      {
        'key': 'TOS-101',
        'title': 'Setup DB Schema',
        'start': 'Jun 1',
        'end': 'Jun 4',
        'progress': 1.0,
        'dependencies': []
      },
      {
        'key': 'TOS-102',
        'title': 'Implement API Routes',
        'start': 'Jun 4',
        'end': 'Jun 9',
        'progress': 0.6,
        'dependencies': ['TOS-101']
      },
      {
        'key': 'TOS-103',
        'title': 'FCM Setup',
        'start': 'Jun 8',
        'end': 'Jun 12',
        'progress': 0.2,
        'dependencies': []
      },
      {
        'key': 'TOS-104',
        'title': 'Kanban Integration',
        'start': 'Jun 10',
        'end': 'Jun 18',
        'progress': 0.0,
        'dependencies': ['TOS-102', 'TOS-103']
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Gantt Schedule Timeline', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1E293B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Calendar timeline headers
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(10)),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Tasks Schedule', style: TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.bold, fontSize: 13)),
                  Text('June 2026', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Timelines list
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: tasks.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final task = tasks[index];
                final progress = task['progress'] as double;
                final deps = task['dependencies'] as List<String>;

                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${task['key']} - ${task['title']}',
                            style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${task['start']} → ${task['end']}',
                            style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: progress,
                                minHeight: 6,
                                backgroundColor: const Color(0xFF0F172A),
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text('${(progress * 100).toInt()}%', style: const TextStyle(color: Colors.white, fontSize: 12)),
                        ],
                      ),
                      if (deps.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 6,
                          children: [
                            const Text('Depends on: ', style: TextStyle(color: Color(0xFF64748B), fontSize: 11)),
                            ...deps.map((dep) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(color: Colors.redAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                                child: Text(dep, style: const TextStyle(color: Colors.redAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                              );
                            }),
                          ],
                        )
                      ]
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
