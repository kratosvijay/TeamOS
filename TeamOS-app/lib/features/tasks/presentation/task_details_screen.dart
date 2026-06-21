import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'worklog_widget.dart';
import 'dependency_graph_widget.dart';

class TaskDetailsScreen extends StatelessWidget {
  final String taskId;
  const TaskDetailsScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    // Mock task details
    final task = {
      'key': 'ECO-102',
      'title': 'Implement Socket Gateway Listeners',
      'description': 'Ensure Sockets security checks verify user project membership and rate limits before allowing room subscriptions.',
      'type': 'TASK',
      'status': 'IN_PROGRESS',
      'priority': 'CRITICAL',
      'storyPoints': 5,
      'estimated': 12.0,
      'logged': 4.0,
      'aiSummary': 'Implement secure WebSockets validation routines on room connection handshakes.',
      'watchersCount': 4,
      'isWatching': true,
      'dependencies': [
        {'type': 'BLOCKS', 'taskKey': 'ECO-104', 'status': 'TODO'},
        {'type': 'RELATES_TO', 'taskKey': 'ECO-87', 'status': 'DONE'},
      ]
    };

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: Text('Task Details: ${task['key']}', style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1E293B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(task['isWatching'] as bool ? Icons.visibility : Icons.visibility_off, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.white),
            onPressed: () => context.push('/tasks/edit/$taskId'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title & Description
            Text(
              task['title'] as String,
              style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              task['description'] as String,
              style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 15, height: 1.4),
            ),
            const SizedBox(height: 24),
            const Divider(color: Color(0xFF334155)),
            const SizedBox(height: 24),

            // AI Summary Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.auto_awesome, color: Color(0xFF3B82F6)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('AI Task Summary', style: TextStyle(color: Color(0xFF3B82F6), fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(height: 4),
                        Text(task['aiSummary'] as String, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Sibling Columns: Details & Log Metrics
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Column 1: Details & Dependencies
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      DependencyGraphWidget(dependencies: List<Map<String, String>>.from(task['dependencies'] as List)),
                      const SizedBox(height: 24),
                      const CommentsWidget(),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                
                // Column 2: Status Details & Time Logs
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      // Status and Details list Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFF334155)),
                        ),
                        child: Column(
                          children: [
                            buildInfoRow('Status', task['status'] as String),
                            buildInfoRow('Priority', task['priority'] as String),
                            buildInfoRow('Story Points', '${task['storyPoints']}'),
                            buildInfoRow('Watchers', '${task['watchersCount']} watching'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      WorklogWidget(estimated: task['estimated'] as double, logged: task['logged'] as double),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInfoRow(String label, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
          Text(val, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// Stub Comments List Widget
class CommentsWidget extends StatelessWidget {
  const CommentsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Activity Discussion', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(height: 16),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(backgroundColor: Color(0xFF3B82F6), child: Text('JD')),
            title: Text('John Doe', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: Text('I will finalize the socket listener integration verification checks today. @developer-team', style: TextStyle(color: Color(0xFF94A3B8))),
          ),
        ],
      ),
    );
  }
}
