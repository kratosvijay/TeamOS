import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CalendarViewScreen extends StatelessWidget {
  const CalendarViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock task list with due dates
    final calendarTasks = [
      {'day': 4, 'key': 'TOS-101', 'title': 'Design Schema', 'color': Colors.blueAccent},
      {'day': 8, 'key': 'TOS-102', 'title': 'API Endpoints', 'color': Colors.purpleAccent},
      {'day': 12, 'key': 'TOS-103', 'title': 'FCM Gateway', 'color': Colors.amberAccent},
      {'day': 18, 'key': 'TOS-104', 'title': 'Kanban Sync Sockets', 'color': Colors.greenAccent},
      {'day': 22, 'key': 'TOS-105', 'title': 'Writing Tests', 'color': Colors.redAccent},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Workspace Calendar', style: TextStyle(color: Colors.white)),
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
            // Calendar grid header (Month and Weekdays)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  const Text('June 2026', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      Text('S', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
                      Text('M', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
                      Text('T', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
                      Text('W', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
                      Text('T', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
                      Text('F', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
                      Text('S', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Due Tasks list view below calendar
            const Text('Upcoming Deadlines', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: calendarTasks.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final task = calendarTasks[index];
                final color = task['color'] as Color;

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 36,
                        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${task['key']} - ${task['title']}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                          const SizedBox(height: 4),
                          Text('Due on: June ${task['day']}, 2026', style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                        ],
                      )
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
