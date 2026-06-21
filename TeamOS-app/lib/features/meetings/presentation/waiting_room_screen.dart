import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class WaitingRoomScreen extends HookWidget {
  final String meetingId;
  const WaitingRoomScreen({super.key, required this.meetingId});

  @override
  Widget build(BuildContext context) {
    // Mock queue
    final queue = useState<List<Map<String, String>>>([
      {'id': 'temp-1', 'name': 'Sarah Jenkins (Guest)', 'company': 'Design Partner'},
      {'id': 'temp-2', 'name': 'Bob Martinez (External)', 'company': 'Prisma Systems'},
    ]);

    void approveUser(String id) {
      queue.value = queue.value.where((q) => q['id'] != id).toList();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Participant approved and admitted to the huddle.'), backgroundColor: Colors.green),
      );
    }

    void rejectUser(String id) {
      queue.value = queue.value.where((q) => q['id'] != id).toList();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Participant entry rejected.'), backgroundColor: Colors.redAccent),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Waiting Room Queue', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: queue.value.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.people_outline_rounded, size: 64, color: Color(0xFF334155)),
                  SizedBox(height: 16),
                  Text('Waiting room is empty', style: TextStyle(color: Color(0xFF64748B), fontSize: 15)),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(24),
              itemCount: queue.value.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final guest = queue.value[index];

                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Color(0xFF0F172A),
                        child: Icon(Icons.person_outline_rounded, color: Color(0xFF3B82F6)),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              guest['name']!,
                              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Company: ${guest['company']}',
                              style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        onPressed: () => approveUser(guest['id']!),
                        child: const Text('Approve', style: TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.redAccent)),
                        onPressed: () => rejectUser(guest['id']!),
                        child: const Text('Deny', style: TextStyle(color: Colors.redAccent)),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
