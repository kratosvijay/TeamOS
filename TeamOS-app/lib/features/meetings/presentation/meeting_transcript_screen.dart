import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class MeetingTranscriptScreen extends HookWidget {
  final String meetingId;
  const MeetingTranscriptScreen({super.key, required this.meetingId});

  @override
  Widget build(BuildContext context) {
    final searchController = useTextEditingController();
    final transcripts = useState<List<Map<String, String>>>([
      {
        'sender': 'Sarah Jenkins',
        'content': 'We need to migrate database schema first. Did you run the prisma generate command?',
        'time': '10:14 AM',
      },
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

    final filtered = useState<List<Map<String, String>>>(transcripts.value);

    void handleSearch(String text) {
      if (text.trim().isEmpty) {
        filtered.value = transcripts.value;
      } else {
        filtered.value = transcripts.value
            .where((t) => t['content']!.toLowerCase().contains(text.toLowerCase()) || t['sender']!.toLowerCase().contains(text.toLowerCase()))
            .toList();
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Meeting Transcript', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Exporting meeting transcript as CSV...')),
              );
            },
            tooltip: 'Export Transcript',
          )
        ],
      ),
      body: Column(
        children: [
          // Search box
          Container(
            padding: const EdgeInsets.all(20),
            color: const Color(0xFF1E293B),
            child: TextField(
              controller: searchController,
              onChanged: handleSearch,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search transcripts...',
                hintStyle: const TextStyle(color: Color(0xFF64748B)),
                prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF64748B)),
                filled: true,
                fillColor: const Color(0xFF0F172A),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          // Bubbles stream
          Expanded(
            child: filtered.value.isEmpty
                ? const Center(child: Text('No matching transcripts found', style: TextStyle(color: Color(0xFF64748B))))
                : ListView.separated(
                    padding: const EdgeInsets.all(24),
                    itemCount: filtered.value.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 20),
                    itemBuilder: (context, index) {
                      final tx = filtered.value[index];
                      final isMe = tx['sender'] == 'You';

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: const Color(0xFF334155),
                            radius: 16,
                            child: Text(
                              tx['sender']!.substring(0, 1),
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(tx['sender']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                                    const SizedBox(width: 8),
                                    Text(tx['time']!, style: const TextStyle(color: Color(0xFF64748B), fontSize: 10)),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1E293B),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    tx['content']!,
                                    style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 13, height: 1.5),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
}
