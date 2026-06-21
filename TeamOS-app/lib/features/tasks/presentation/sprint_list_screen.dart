import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SprintListScreen extends StatelessWidget {
  const SprintListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Sprints
    final sprints = [
      {'id': '1', 'name': 'Sprint 1', 'goal': 'Establish core layout and authentication', 'status': 'ACTIVE', 'velocity': 18},
      {'id': '2', 'name': 'Sprint 2', 'goal': 'Develop task workspaces and kanban boards', 'status': 'FUTURE', 'velocity': 0},
      {'id': '3', 'name': 'Kickoff Sprint', 'goal': 'Project kickoff and planning session', 'status': 'COMPLETED', 'velocity': 12},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Sprint Management', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(24),
        itemCount: sprints.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final sprint = sprints[index];
          final isActive = sprint['status'] == 'ACTIVE';
          final isCompleted = sprint['status'] == 'COMPLETED';

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
                    Text(
                      sprint['name'] as String,
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Chip(
                      label: Text(sprint['status'] as String, style: const TextStyle(fontSize: 10, color: Colors.white)),
                      backgroundColor: isActive
                          ? Colors.blueAccent.withOpacity(0.3)
                          : isCompleted
                              ? Colors.green.withOpacity(0.3)
                              : const Color(0xFF334155),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  sprint['goal'] as String,
                  style: const TextStyle(color: Color(0xFF94A3B8)),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (isCompleted)
                      Text('Velocity achieved: ${sprint['velocity']} SP', style: const TextStyle(color: Colors.greenAccent, fontSize: 12))
                    else
                      const SizedBox.shrink(),
                    TextButton(
                      onPressed: () => context.push('/sprints/details/${sprint['id']}'),
                      child: const Text('View Details', style: TextStyle(color: Color(0xFF3B82F6))),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
