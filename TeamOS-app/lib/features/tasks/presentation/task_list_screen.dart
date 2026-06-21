import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock hierarchical issues
    final epics = [
      {
        'key': 'ECO-1',
        'title': 'Core Platforms Architecture Setup',
        'type': 'EPIC',
        'status': 'IN_PROGRESS',
        'stories': [
          {
            'key': 'ECO-2',
            'title': 'User Authentication endpoints',
            'type': 'STORY',
            'status': 'DONE',
            'tasks': [
              {'key': 'ECO-3', 'title': 'Write jwt validation logic', 'type': 'TASK', 'status': 'DONE'},
              {'key': 'ECO-4', 'title': 'Implement Google token check', 'type': 'TASK', 'status': 'DONE'},
            ]
          },
          {
            'key': 'ECO-5',
            'title': 'Kanban board UI synchronization',
            'type': 'STORY',
            'status': 'IN_PROGRESS',
            'tasks': [
              {'key': 'ECO-6', 'title': 'Build drag and drop widgets', 'type': 'TASK', 'status': 'IN_PROGRESS'},
              {'key': 'ECO-7', 'title': 'Integrate WIP column warnings', 'type': 'BUG', 'status': 'TODO'},
            ]
          }
        ]
      }
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Backlog Work items', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(24),
        itemCount: epics.length,
        separatorBuilder: (context, index) => const SizedBox(height: 24),
        itemBuilder: (context, index) {
          final epic = epics[index];
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
                // Epic Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.purple.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                      child: const Text('EPIC', style: TextStyle(color: Colors.purpleAccent, fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 12),
                    Text(epic['key'] as String, style: const TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    Expanded(child: Text(epic['title'] as String, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(color: Color(0xFF334155)),
                
                // Nested Stories list
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: (epic['stories'] as List).length,
                  itemBuilder: (context, sIndex) {
                    final story = (epic['stories'] as List)[sIndex];
                    return Padding(
                      padding: const EdgeInsets.only(top: 16, left: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(color: Colors.green.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                                child: const Text('STORY', style: TextStyle(color: Colors.greenAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(width: 8),
                              Text(story['key'] as String, style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
                              const SizedBox(width: 8),
                              Expanded(child: Text(story['title'] as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                            ],
                          ),
                          
                          // Tasks under Stories
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: (story['tasks'] as List).length,
                            itemBuilder: (context, tIndex) {
                              final task = (story['tasks'] as List)[tIndex];
                              return Padding(
                                padding: const EdgeInsets.only(top: 12, left: 32),
                                child: Row(
                                  children: [
                                    Icon(
                                      task['type'] == 'BUG' ? Icons.bug_report_rounded : Icons.check_circle_outline_rounded,
                                      color: task['type'] == 'BUG' ? Colors.redAccent : const Color(0xFF3B82F6),
                                      size: 16,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(task['key'] as String, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                                    const SizedBox(width: 8),
                                    Expanded(child: Text(task['title'] as String, style: const TextStyle(color: Color(0xFF94A3B8)))),
                                    Chip(
                                      label: Text(task['status'] as String, style: const TextStyle(fontSize: 10, color: Colors.white)),
                                      backgroundColor: task['status'] == 'DONE' ? Colors.green.withOpacity(0.3) : const Color(0xFF334155),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/tasks/create'),
        backgroundColor: const Color(0xFF3B82F6),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
