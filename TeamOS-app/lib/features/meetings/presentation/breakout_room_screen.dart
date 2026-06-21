import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class BreakoutRoomScreen extends HookWidget {
  final String meetingId;
  const BreakoutRoomScreen({super.key, required this.meetingId});

  @override
  Widget build(BuildContext context) {
    final rooms = useState<List<Map<String, dynamic>>>([
      {'id': 'b1', 'name': 'Frontend workshop', 'participants': ['Alex Martinez', 'Sarah Jenkins']},
      {'id': 'b2', 'name': 'API refactoring', 'participants': ['John Doe']},
    ]);

    void addRoom() {
      rooms.value = [
        ...rooms.value,
        {'id': DateTime.now().toString(), 'name': 'Breakout Room ${rooms.value.length + 1}', 'participants': []}
      ];
    }

    void closeAll() {
      rooms.value = [];
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All breakout rooms closed. Merged back to main huddle.'), backgroundColor: Colors.amber),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Breakout Allocation', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.add_rounded, color: Colors.white), onPressed: addRoom, tooltip: 'Add Room'),
          IconButton(icon: const Icon(Icons.merge_type_rounded, color: Colors.amberAccent), onPressed: closeAll, tooltip: 'Close & Merge'),
        ],
      ),
      body: rooms.value.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.door_sliding_outlined, size: 64, color: Color(0xFF334155)),
                  const SizedBox(height: 16),
                  const Text('No breakout rooms active', style: TextStyle(color: Color(0xFF64748B), fontSize: 15)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: addRoom,
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3B82F6)),
                    child: const Text('Create Breakout Room', style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(24),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
              ),
              itemCount: rooms.value.length,
              itemBuilder: (context, index) {
                final r = rooms.value[index];
                final list = r['participants'] as List<String>;

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
                          Text(r['name'] as String, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                          const Icon(Icons.people_outline_rounded, color: Color(0xFF64748B), size: 16),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: list.isEmpty
                            ? const Center(child: Text('Room is empty', style: TextStyle(color: Color(0xFF64748B), fontSize: 12)))
                            : ListView.separated(
                                itemCount: list.length,
                                separatorBuilder: (context, idx) => const SizedBox(height: 6),
                                itemBuilder: (context, idx) {
                                  return Row(
                                    children: [
                                      const Icon(Icons.circle, color: Colors.greenAccent, size: 6),
                                      const SizedBox(width: 8),
                                      Text(list[idx], style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 12)),
                                    ],
                                  );
                                },
                              ),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFF334155))),
                          onPressed: () {},
                          child: const Text('Move participant', style: TextStyle(color: Color(0xFF94A3B8))),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
    );
  }
}
