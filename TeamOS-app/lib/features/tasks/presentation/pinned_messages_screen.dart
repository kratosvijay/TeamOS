import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class PinnedMessagesScreen extends HookWidget {
  final String channelName;
  const PinnedMessagesScreen({super.key, required this.channelName});

  @override
  Widget build(BuildContext context) {
    // Mock pinned messages list
    final pins = useState<List<Map<String, dynamic>>>([
      {
        'id': 'p1',
        'sender': 'Sarah Jenkins',
        'content': 'We need to migrate database schema first. Did you run the prisma generate command?',
        'pinnedBy': 'Sarah Jenkins',
        'time': '10:14 AM',
      },
      {
        'id': 'p2',
        'sender': 'John Doe',
        'content': 'FCM credentials and BullMQ provisioning workers are fully operational in the background.',
        'pinnedBy': 'John Doe',
        'time': '10:20 AM',
      },
    ]);

    void unpinMessage(String id) {
      pins.value = pins.value.where((p) => p['id'] != id).toList();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Message unpinned successfully.'),
          backgroundColor: Color(0xFF1E293B),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: Text('Pinned in #$channelName', style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1E293B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: pins.value.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.push_pin_outlined, size: 64, color: Color(0xFF334155)),
                  SizedBox(height: 16),
                  Text('No pinned messages in this channel', style: TextStyle(color: Color(0xFF64748B), fontSize: 15)),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(24),
              itemCount: pins.value.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final item = pins.value[index];

                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Pin details header
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.push_pin_rounded, color: Colors.amberAccent, size: 16),
                                const SizedBox(width: 8),
                                Text(
                                  'Pinned by ${item['pinnedBy']}',
                                  style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.close_rounded, color: Color(0xFF64748B), size: 18),
                              onPressed: () => unpinMessage(item['id'] as String),
                              tooltip: 'Unpin Message',
                            ),
                          ],
                        ),
                      ),
                      const Divider(color: Color(0xFF334155), height: 1),
                      // Message body
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundColor: const Color(0xFF334155),
                              radius: 16,
                              child: Text(
                                (item['sender'] as String).substring(0, 1),
                                style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        item['sender'] as String,
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                      ),
                                      Text(
                                        item['time'] as String,
                                        style: const TextStyle(color: Color(0xFF64748B), fontSize: 11),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    item['content'] as String,
                                    style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 13, height: 1.4),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const Divider(color: Color(0xFF334155), height: 1),
                      // Jump to message action
                      InkWell(
                        onTap: () => context.pop(),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.arrow_right_alt_rounded, color: Color(0xFF3B82F6), size: 18),
                              SizedBox(width: 6),
                              Text(
                                'Jump to message',
                                style: TextStyle(color: Color(0xFF3B82F6), fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
