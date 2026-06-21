import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class AIPendingActionsScreen extends HookWidget {
  const AIPendingActionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = useState<List<Map<String, String>>>([
      {'id': 'act-1', 'agent': 'Sprint Planner', 'action': 'Create subtasks list', 'payload': 'TOS-101 subtask configuration'},
      {'id': 'act-2', 'agent': 'Risk Analyst', 'action': 'Close blocked tasks', 'payload': 'Move TOS-44 to cancelled state'},
    ]);

    void resolveAction(String id, String status) {
      actions.value = actions.value.where((a) => a['id'] != id).toList();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Action $id resolved: $status'), backgroundColor: status == 'APPROVED' ? Colors.green : Colors.red),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('AI Pending Approvals', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: actions.value.isEmpty
          ? const Center(
              child: Text('No pending actions in the queue.', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 16)),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(24.0),
              itemCount: actions.value.length,
              itemBuilder: (context, index) {
                final item = actions.value[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
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
                          Text(item['agent']!, style: const TextStyle(color: Colors.cyanAccent, fontSize: 13, fontWeight: FontWeight.bold)),
                          const Text('PENDING', style: TextStyle(color: Colors.orangeAccent, fontSize: 11, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(item['action']!, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(item['payload']!, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () => resolveAction(item['id']!, 'APPROVED'),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                            child: const Text('Approve', style: TextStyle(color: Colors.white)),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton(
                            onPressed: () => resolveAction(item['id']!, 'REJECTED'),
                            style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.redAccent)),
                            child: const Text('Reject', style: TextStyle(color: Colors.redAccent)),
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
