import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RoadmapViewScreen extends StatelessWidget {
  const RoadmapViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Epics with timeline details
    final epics = [
      {
        'key': 'TOS-1',
        'title': 'Core Infrastructure Setup',
        'progress': 0.85,
        'quarter': 'Q1 2026',
        'color': Colors.purpleAccent,
        'status': 'IN_PROGRESS'
      },
      {
        'key': 'TOS-2',
        'title': 'Video Meetings Module',
        'progress': 0.40,
        'quarter': 'Q1-Q2 2026',
        'color': Colors.blueAccent,
        'status': 'IN_PROGRESS'
      },
      {
        'key': 'TOS-3',
        'title': 'Notion-like Sync Docs',
        'progress': 0.10,
        'quarter': 'Q2 2026',
        'color': Colors.amberAccent,
        'status': 'TODO'
      },
      {
        'key': 'TOS-4',
        'title': 'Mobile Client Wrappers',
        'progress': 0.00,
        'quarter': 'Q3 2026',
        'color': Colors.pinkAccent,
        'status': 'BACKLOG'
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Product Roadmap', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1E293B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(24),
        itemCount: epics.length,
        separatorBuilder: (context, index) => const SizedBox(height: 20),
        itemBuilder: (context, index) {
          final epic = epics[index];
          final progressVal = epic['progress'] as double;
          final pct = (progressVal * 100).toInt();

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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: (epic['color'] as Color).withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
                      child: Text(epic['key'] as String, style: TextStyle(color: epic['color'] as Color, fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                    Text(epic['quarter'] as String, style: const TextStyle(color: Color(0xFF64748B), fontSize: 13, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                Text(epic['title'] as String, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: progressVal,
                          backgroundColor: const Color(0xFF0F172A),
                          color: epic['color'] as Color,
                          minHeight: 10,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text('$pct%', style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Status: ${epic['status']}', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.keyboard_arrow_right_rounded, size: 16, color: Color(0xFF3B82F6)),
                      label: const Text('View Issues', style: TextStyle(color: Color(0xFF3B82F6), fontSize: 12, fontWeight: FontWeight.bold)),
                    )
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
