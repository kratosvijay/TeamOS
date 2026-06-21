import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class ChatHomeScreen extends HookWidget {
  const ChatHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = useTextEditingController();
    
    // Mock workspace channels
    final channels = [
      {'name': 'general', 'type': 'PROJECT_TEXT', 'unread': 0},
      {'name': 'announcements', 'type': 'PROJECT_TEXT', 'unread': 3},
      {'name': 'development', 'type': 'PROJECT_TEXT', 'unread': 0},
      {'name': 'security-private', 'type': 'PRIVATE_TEXT', 'unread': 1},
    ];

    // Mock direct message threads
    final dms = [
      {'name': 'Sarah Jenkins', 'avatar': null, 'status': 'ONLINE', 'lastMsg': 'FCM vault token configured.', 'unread': 0},
      {'name': 'Alex Martinez', 'avatar': null, 'status': 'BUSY', 'lastMsg': 'Drafting retrospective action items.', 'unread': 2},
      {'name': 'John Doe', 'avatar': null, 'status': 'OFFLINE', 'lastMsg': 'Did you run the prisma generate command?', 'unread': 0},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Collaboration Hub', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1E293B),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded, color: Colors.white),
            onPressed: () => context.push('/chat/search'),
          ),
          IconButton(
            icon: const Icon(Icons.alternate_email_rounded, color: Colors.white),
            onPressed: () => context.push('/chat/mentions'),
          ),
        ],
      ),
      body: Row(
        children: [
          // Sidebar / List pane
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Search box
                  TextField(
                    controller: searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Jump to conversation...',
                      hintStyle: const TextStyle(color: Color(0xFF64748B)),
                      prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF64748B), size: 20),
                      filled: true,
                      fillColor: const Color(0xFF1E293B),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Huddle section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('ACTIVE HUDDLES', style: TextStyle(color: Color(0xFF64748B), fontSize: 12, fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.add, color: Color(0xFF3B82F6), size: 18),
                        onPressed: () => context.push('/chat/voice/new'),
                      ),
                    ],
                  ),
                  ListTile(
                    onTap: () => context.push('/chat/voice/huddle-123'),
                    leading: const CircleAvatar(
                      backgroundColor: Colors.greenAccent,
                      child: Icon(Icons.volume_up_rounded, color: Color(0xFF0F172A), size: 18),
                    ),
                    title: const Text('Dev Sync Huddle', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                    subtitle: const Text('3 developers speaking', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFF64748B), size: 14),
                  ),
                  const SizedBox(height: 24),

                  // Channels Header
                  const Text('CHANNELS', style: TextStyle(color: Color(0xFF64748B), fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...channels.map((chan) {
                    final unread = chan['unread'] as int;
                    final isPrivate = chan['type'] == 'PRIVATE_TEXT';

                    return ListTile(
                      onTap: () => context.push('/chat/channel/${chan['name']}'),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      leading: Icon(
                        isPrivate ? Icons.lock_outline_rounded : Icons.tag_rounded,
                        color: unread > 0 ? Colors.white : const Color(0xFF64748B),
                        size: 20,
                      ),
                      title: Text(
                        chan['name'] as String,
                        style: TextStyle(
                          color: unread > 0 ? Colors.white : const Color(0xFF94A3B8),
                          fontWeight: unread > 0 ? FontWeight.bold : FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                      trailing: unread > 0
                          ? Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: const Color(0xFF3B82F6), borderRadius: BorderRadius.circular(10)),
                              child: Text('$unread', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                            )
                          : null,
                    );
                  }).toList(),
                  const SizedBox(height: 28),

                  // Direct Messages Header
                  const Text('DIRECT MESSAGES', style: TextStyle(color: Color(0xFF64748B), fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...dms.map((dm) {
                    final unread = dm['unread'] as int;
                    final status = dm['status'] as String;

                    Color statusColor = const Color(0xFF64748B);
                    if (status == 'ONLINE') statusColor = Colors.greenAccent;
                    if (status == 'BUSY') statusColor = Colors.redAccent;

                    return ListTile(
                      onTap: () => context.push('/chat/dm/${dm['name']}'),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      leading: Stack(
                        children: [
                          const CircleAvatar(
                            backgroundColor: Color(0xFF334155),
                            radius: 16,
                            child: Icon(Icons.person_rounded, color: Color(0xFF94A3B8), size: 18),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
                            ),
                          )
                        ],
                      ),
                      title: Text(
                        dm['name'] as String,
                        style: TextStyle(
                          color: unread > 0 ? Colors.white : const Color(0xFF94A3B8),
                          fontWeight: unread > 0 ? FontWeight.bold : FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Text(
                        dm['lastMsg'] as String,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
                      ),
                      trailing: unread > 0
                          ? Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: const Color(0xFF3B82F6), borderRadius: BorderRadius.circular(10)),
                              child: Text('$unread', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                            )
                          : null,
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
