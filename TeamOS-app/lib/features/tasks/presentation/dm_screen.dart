import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class DmScreen extends HookWidget {
  final String userName;
  const DmScreen({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    final messageController = useTextEditingController();
    
    // Mock messages with read receipts
    final messages = useState<List<Map<String, dynamic>>>([
      {
        'id': '201',
        'sender': userName,
        'content': 'Hey, did you look at the velocity report? We are averaging 13 story points.',
        'time': 'Yesterday',
        'isRead': true,
      },
      {
        'id': '202',
        'sender': 'You',
        'content': 'Yes! John Doe did 5 points, Sarah Jenkins did 3. The backlog health summary looks stable.',
        'time': 'Yesterday',
        'isRead': true,
      },
      {
        'id': '203',
        'sender': userName,
        'content': 'Great. I will check in on the rest of the epic roadmap progress shortly.',
        'time': '10:05 AM',
        'isRead': true,
      },
    ]);

    void sendMessage() {
      if (messageController.text.trim().isEmpty) return;
      messages.value = [
        ...messages.value,
        {
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'sender': 'You',
          'content': messageController.text.trim(),
          'time': 'Just now',
          'isRead': false, // Unread by other participant initially
        }
      ];
      messageController.clear();
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Color(0xFF334155),
              radius: 16,
              child: Icon(Icons.person_rounded, color: Color(0xFF94A3B8), size: 18),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userName, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                const Text('Active Now', style: TextStyle(color: Colors.greenAccent, fontSize: 11)),
              ],
            )
          ],
        ),
        backgroundColor: const Color(0xFF1E293B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          // DM messages list
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(24),
              itemCount: messages.value.length,
              separatorBuilder: (context, index) => const SizedBox(height: 18),
              itemBuilder: (context, index) {
                final msg = messages.value[index];
                final isMe = msg['sender'] == 'You';
                final isLast = index == messages.value.length - 1;

                return Column(
                  crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      constraints: const BoxConstraints(maxWidth: 280),
                      decoration: BoxDecoration(
                        color: isMe ? const Color(0xFF3B82F6) : const Color(0xFF1E293B),
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(12),
                          topRight: const Radius.circular(12),
                          bottomLeft: Radius.circular(isMe ? 12 : 0),
                          bottomRight: Radius.circular(isMe ? 0 : 12),
                        ),
                      ),
                      child: Text(
                        msg['content'] as String,
                        style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.4),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(msg['time'] as String, style: const TextStyle(color: Color(0xFF64748B), fontSize: 10)),
                        if (isMe && isLast) ...[
                          const SizedBox(width: 6),
                          Icon(
                            msg['isRead'] as bool ? Icons.done_all_rounded : Icons.done_rounded,
                            size: 14,
                            color: msg['isRead'] as bool ? Colors.greenAccent : const Color(0xFF64748B),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            msg['isRead'] as bool ? 'Seen' : 'Sent',
                            style: const TextStyle(color: Color(0xFF64748B), fontSize: 10),
                          ),
                        ]
                      ],
                    )
                  ],
                );
              },
            ),
          ),

          // DM input block
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF1E293B),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Message $userName',
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
                    onPressed: sendMessage,
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
