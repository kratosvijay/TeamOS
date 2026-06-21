import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class ChannelScreen extends HookWidget {
  final String channelName;
  const ChannelScreen({super.key, required this.channelName});

  @override
  Widget build(BuildContext context) {
    final messageController = useTextEditingController();
    
    // Mock messages
    final messages = useState<List<Map<String, dynamic>>>([
      {
        'id': '101',
        'sender': 'Sarah Jenkins',
        'content': 'We need to migrate database schema first. Did you run the prisma generate command?',
        'time': '10:14 AM',
        'reactions': [
          {'emoji': '👍', 'count': 2},
          {'emoji': '🔥', 'count': 1},
        ],
        'threadCount': 3,
      },
      {
        'id': '102',
        'sender': 'Alex Martinez',
        'content': 'Yes, prisma generate completed successfully. Compiling the NestJS backend has no errors now.',
        'time': '10:16 AM',
        'reactions': [
          {'emoji': '🚀', 'count': 3},
        ],
        'threadCount': 0,
      },
      {
        'id': '103',
        'sender': 'John Doe',
        'content': 'FCM credentials and BullMQ provisioning workers are fully operational in the background.',
        'time': '10:20 AM',
        'reactions': [],
        'threadCount': 0,
      },
    ]);

    final isTyping = useState<bool>(false);

    void sendMessage() {
      if (messageController.text.trim().isEmpty) return;
      messages.value = [
        ...messages.value,
        {
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'sender': 'You',
          'content': messageController.text.trim(),
          'time': 'Just now',
          'reactions': [],
          'threadCount': 0,
        }
      ];
      messageController.clear();
      isTyping.value = false;
    }

    void toggleReaction(String msgId, String emoji) {
      messages.value = messages.value.map((m) {
        if (m['id'] == msgId) {
          final rxList = List<Map<String, dynamic>>.from(m['reactions']);
          final rxIdx = rxList.indexWhere((r) => r['emoji'] == emoji);
          if (rxIdx != -1) {
            rxList[rxIdx]['count']++;
          } else {
            rxList.add({'emoji': emoji, 'count': 1});
          }
          return {...m, 'reactions': rxList};
        }
        return m;
      }).toList();
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: Text('#$channelName', style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1E293B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.push_pin_rounded, color: Colors.amberAccent),
            onPressed: () => context.push('/chat/channel/$channelName/pins'),
          ),
          IconButton(
            icon: const Icon(Icons.volume_up_rounded, color: Colors.greenAccent),
            onPressed: () => context.push('/chat/voice/huddle-123'),
          )
        ],
      ),
      body: Column(
        children: [
          // Message stream
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(24),
              itemCount: messages.value.length,
              separatorBuilder: (context, index) => const SizedBox(height: 20),
              itemBuilder: (context, index) {
                final msg = messages.value[index];
                final reactions = msg['reactions'] as List;
                final threadCount = msg['threadCount'] as int;

                return Row(
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
                              Text(msg['sender'] as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                              const SizedBox(width: 8),
                              Text(msg['time'] as String, style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(msg['content'] as String, style: const TextStyle(color: Color(0xFFE2E8F0), fontSize: 14, height: 1.4)),
                          
                          // Reactions wrap
                          if (reactions.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 6,
                              children: reactions.map((rx) {
                                return InkWell(
                                  onTap: () => toggleReaction(msg['id'], rx['emoji']),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(8)),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(rx['emoji'] as String, style: const TextStyle(fontSize: 12)),
                                        const SizedBox(width: 4),
                                        Text('${rx['count']}', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            )
                          ],

                          // Thread replies link
                          if (threadCount > 0) ...[
                            const SizedBox(height: 8),
                            InkWell(
                              onTap: () => context.push('/chat/thread/${msg['id']}'),
                              child: Row(
                                children: [
                                  const Icon(Icons.reply_all_rounded, size: 16, color: Color(0xFF3B82F6)),
                                  const SizedBox(width: 6),
                                  Text(
                                    '$threadCount replies',
                                    style: const TextStyle(color: Color(0xFF3B82F6), fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            )
                          ]
                        ],
                      ),
                    )
                  ],
                );
              },
            ),
          ),

          // Typing status
          if (isTyping.value) ...[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Someone is typing...', style: TextStyle(color: Color(0xFF64748B), fontSize: 12, fontStyle: FontStyle.italic)),
              ),
            )
          ],

          // Input block
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF1E293B),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file_rounded, color: Color(0xFF94A3B8)),
                  onPressed: () {},
                ),
                Expanded(
                  child: TextField(
                    controller: messageController,
                    style: const TextStyle(color: Colors.white),
                    onChanged: (text) {
                      isTyping.value = text.trim().isNotEmpty;
                    },
                    decoration: InputDecoration(
                      hintText: 'Message #$channelName',
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
