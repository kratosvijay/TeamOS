import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class KanbanBoardScreen extends HookWidget {
  const KanbanBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Column Settings with WIP limits
    final columns = [
      {'status': 'Backlog', 'wip': 0, 'tasks': 4},
      {'status': 'Todo', 'wip': 10, 'tasks': 3},
      {'status': 'In Progress', 'wip': 3, 'tasks': 4}, // Exceeds WIP limit!
      {'status': 'In Review', 'wip': 5, 'tasks': 1},
      {'status': 'Testing', 'wip': 3, 'tasks': 2},
      {'status': 'Done', 'wip': 0, 'tasks': 12},
    ];

    final filterQuery = useTextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Kanban Workspace', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Filtering bar
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF1E293B),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: filterQuery,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Filter cards by name, key, or assignee...',
                      hintStyle: const TextStyle(color: Color(0xFF64748B)),
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF64748B)),
                      filled: true,
                      fillColor: const Color(0xFF0F172A),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                DropdownButton<String>(
                  dropdownColor: const Color(0xFF1E293B),
                  style: const TextStyle(color: Colors.white),
                  value: 'All Sprints',
                  onChanged: (val) {},
                  items: const [
                    DropdownMenuItem(value: 'All Sprints', child: Text('All Sprints')),
                    DropdownMenuItem(value: 'Sprint 1', child: Text('Sprint 1')),
                  ],
                ),
              ],
            ),
          ),
          
          // Kanban Columns Board Scroll
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(24),
              child: Row(
                children: columns.map((col) {
                  final status = col['status'] as String;
                  final wip = col['wip'] as int;
                  final tasksCount = col['tasks'] as int;
                  final isWipExceeded = wip > 0 && tasksCount > wip;

                  return Container(
                    width: 280,
                    margin: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isWipExceeded ? Colors.redAccent.withOpacity(0.5) : const Color(0xFF334155),
                        width: isWipExceeded ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Column Header
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    status,
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    wip > 0 ? 'WIP Limit: $wip' : 'No WIP Limit',
                                    style: TextStyle(color: isWipExceeded ? Colors.redAccent : const Color(0xFF64748B), fontSize: 11),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isWipExceeded ? Colors.redAccent.withOpacity(0.2) : const Color(0xFF0F172A),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '$tasksCount',
                                  style: TextStyle(color: isWipExceeded ? Colors.redAccent : Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Cards list
                        Expanded(
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            itemCount: tasksCount,
                            separatorBuilder: (context, index) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              return const KanbanCard(
                                keyString: 'TOS-102',
                                title: 'Implement socket gateway listeners',
                                priority: 'CRITICAL',
                                storyPoints: 5,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class KanbanCard extends StatelessWidget {
  final String keyString;
  final String title;
  final String priority;
  final int storyPoints;

  const KanbanCard({
    super.key,
    required this.keyString,
    required this.title,
    required this.priority,
    required this.storyPoints,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(keyString, style: const TextStyle(color: Color(0xFF3B82F6), fontSize: 11, fontWeight: FontWeight.bold)),
              ),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amberAccent, size: 14),
                  const SizedBox(width: 4),
                  Text('$storyPoints', style: const TextStyle(color: Colors.white, fontSize: 12)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Chip(
                label: Text(priority, style: const TextStyle(fontSize: 10, color: Colors.white)),
                backgroundColor: priority == 'CRITICAL' ? Colors.redAccent.withOpacity(0.3) : const Color(0xFF1E293B),
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ),
              const CircleAvatar(
                radius: 12,
                backgroundColor: Color(0xFF3B82F6),
                child: Text('U', style: TextStyle(color: Colors.white, fontSize: 10)),
              )
            ],
          ),
        ],
      ),
    );
  }
}
