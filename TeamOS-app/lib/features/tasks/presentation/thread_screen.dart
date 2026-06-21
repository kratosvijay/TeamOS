import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class ThreadScreen extends HookWidget {
  final String messageId;
  const ThreadScreen({super.key, required this.messageId});

  @override
  Widget build(BuildContext context) {
    final replyController = useTextEditingController();

    // Mock parent message
    final parentMessage = {
      'sender': 'Sarah Jenkins',
      'content': 'We need to migrate database schema first. Did you run the prisma generate command?',
      'time': '10:14 AM',
    };

    // Mock thread replies
    final replies = useState<List<Map<String, String>>>([
      {
        'sender': 'Alex Martinez',
        'content': 'Yes, prisma generate completed successfully. Compiling the NestJS backend has no errors now.',
        'time': '10:16 AM',
      },
      {
        'sender': 'John Doe',
        'content': 'FCM credentials and BullMQ provisioning workers are fully operational in the background.',
        'time': '10:20 AM',
      },
      {
        'sender': 'Sarah Jenkins',
        'content': 'Excellent. I will launch the build check again to double check imports.',
        'time': '10:22 AM',
      },
    ]);

    void sendReply() {
      if (replyController.text.trim().isEmpty) return;
      replies.value = [
        ...replies.value,
        {
          'sender': 'You',
          'content': replyController.text.trim(),
          'time': 'Just now',
        }
      ];
      replyController.clear();
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Thread Discussion', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1E293B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          // Parent message container
          Container(
            padding: const EdgeInsets.all(20),
            color: const Color(0xFF1E293B),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0xFF334155),
                  radius: 18,
                  child: Icon(Icons.person_rounded, color: Color(0xFF94A3B8), size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(parentMessage['sender']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                          const SizedBox(width: 8),
                          Text(parentMessage['time']!, style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(parentMessage['content']!, style: const TextStyle(color: Color(0xFFE2E8F0), fontSize: 14, height: 1.4)),
                    ],
                  ),
                )
              ],
            ),
          ),

          // Replies list separator label
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            color: const Color(0xFF0F172A),
            child: const Text('REPLIES', style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold)),
          ),

          // Replies stream list
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              itemCount: replies.value.length,
              separatorBuilder: (context, index) => const SizedBox(height: 20),
              itemBuilder: (context, index) {
                final reply = replies.value[index];

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      backgroundColor: Color(0xFF334155),
                      radius: 16,
                      child: Icon(Icons.person_rounded, color: Color(0xFF94A3B8), size: 16),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(reply['sender']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                              const SizedBox(width: 8),
                              Text(reply['time']!, style: const TextStyle(color: Color(0xFF64748B), fontSize: 10)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(reply['content']!, style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 13, height: 1.4)),
                        ],
                      ),
                    )
                  ],
                );
              },
            ),
          ),

          // Reply input box
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF1E293B),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: replyController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Reply in thread...',
                      hintStyle: const TextStyle(color: Color(0xFF64748B)),
                      filled: true,
                      fillColor: const Color(0xFF0F172A),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                CircleAvatar(
                  backgroundColor: const Color(0xFF3B82F6),
                  child: IconButton(
                    icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                    onPressed: sendReply,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
