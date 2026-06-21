import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class MentionsScreen extends HookWidget {
  const MentionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock mentions list
    final mentions = useState<List<Map<String, dynamic>>>([
      {
        'id': 'm1',
        'sender': 'Sarah Jenkins',
        'content': 'Hey @You, please make sure the bullmq provisioning queues are working before pushing.',
        'room': 'development',
        'time': 'Just now',
        'isRead': false,
        'path': '/chat/channel/development',
      },
      {
        'id': 'm2',
        'sender': 'Alex Martinez',
        'content': '@You we need to run prisma generate to fix database client types.',
        'room': 'announcements',
        'time': '1 hour ago',
        'isRead': false,
        'path': '/chat/channel/announcements',
      },
      {
        'id': 'm3',
        'sender': 'John Doe',
        'content': 'I think @You already updated the schema.prisma. Let\'s check the walkthrough.',
        'room': 'general',
        'time': 'Yesterday',
        'isRead': true,
        'path': '/chat/channel/general',
      },
    ]);

    void markAllAsRead() {
      mentions.value = mentions.value.map((m) => {...m, 'isRead': true}).toList();
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Mentions & Replies', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1E293B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton.icon(
            onPressed: markAllAsRead,
            icon: const Icon(Icons.done_all_rounded, size: 18, color: Color(0xFF3B82F6)),
            label: const Text('Mark all read', style: TextStyle(color: Color(0xFF3B82F6), fontSize: 13, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: mentions.value.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.alternate_email_rounded, size: 64, color: Color(0xFF334155)),
                  SizedBox(height: 16),
                  Text('No mentions yet', style: TextStyle(color: Color(0xFF64748B), fontSize: 15)),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(24),
              itemCount: mentions.value.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final item = mentions.value[index];
                final isRead = item['isRead'] as bool;

                return InkWell(
                  onTap: () {
                    // Mark as read when clicked
                    mentions.value = mentions.value.map((m) {
                      if (m['id'] == item['id']) return {...m, 'isRead': true};
                      return m;
                    }).toList();
                    context.push(item['path'] as String);
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isRead ? const Color(0xFF1E293B) : const Color(0xFF1E293B).withOpacity(0.6),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isRead ? const Color(0xFF334155) : const Color(0xFF3B82F6).withOpacity(0.4),
                        width: isRead ? 1 : 1.5,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: const Color(0xFF334155),
                          radius: 18,
                          child: Text(
                            (item['sender'] as String).substring(0, 1),
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                                  Row(
                                    children: [
                                      Text(
                                        item['time'] as String,
                                        style: const TextStyle(color: Color(0xFF64748B), fontSize: 11),
                                      ),
                                      if (!isRead) ...[
                                        const SizedBox(width: 8),
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: const BoxDecoration(color: Color(0xFF3B82F6), shape: BoxShape.circle),
                                        )
                                      ]
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '#${item['room']}',
                                style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 8),
                              RichText(
                                text: TextSpan(
                                  style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 13, height: 1.4),
                                  children: _buildMentionsContent(item['content'] as String),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  // Highlights @You or @Developer inside the message body
  List<TextSpan> _buildMentionsContent(String content) {
    final List<TextSpan> spans = [];
    final words = content.split(' ');
    
    for (int i = 0; i < words.length; i++) {
      final word = words[i];
      final isMention = word.startsWith('@');
      
      spans.add(
        TextSpan(
          text: '$word ',
          style: TextStyle(
            color: isMention ? Colors.greenAccent : const Color(0xFFCBD5E1),
            fontWeight: isMention ? FontWeight.bold : FontWeight.normal,
            backgroundColor: isMention ? Colors.greenAccent.withOpacity(0.1) : null,
          ),
        ),
      );
    }
    return spans;
  }
}
