import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class MeetingRecordingsScreen extends HookWidget {
  const MeetingRecordingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock recordings list
    final recordings = useState<List<Map<String, dynamic>>>([
      {
        'id': 'rec-1',
        'title': 'Project Standup',
        'date': 'June 21, 2026',
        'duration': '15:20',
        'size': '45 MB',
        'isPlaying': false,
      },
      {
        'id': 'rec-2',
        'title': 'Sprint Kickoff Ceremony',
        'date': 'June 20, 2026',
        'duration': '44:10',
        'size': '128 MB',
        'isPlaying': false,
      },
      {
        'id': 'rec-3',
        'title': 'API Architecture Review',
        'date': 'June 18, 2026',
        'duration': '32:45',
        'size': '94 MB',
        'isPlaying': false,
      },
    ]);

    void togglePlayback(String id) {
      recordings.value = recordings.value.map((rec) {
        if (rec['id'] == id) {
          return {...rec, 'isPlaying': !(rec['isPlaying'] as bool)};
        }
        return {...rec, 'isPlaying': false}; // Stop others
      }).toList();
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Recording Library', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: recordings.value.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.video_library_rounded, size: 64, color: Color(0xFF334155)),
                  SizedBox(height: 16),
                  Text('No recorded meetings yet', style: TextStyle(color: Color(0xFF64748B), fontSize: 15)),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(24),
              itemCount: recordings.value.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final rec = recordings.value[index];
                final isPlaying = rec['isPlaying'] as bool;

                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isPlaying ? const Color(0xFF3B82F6) : const Color(0xFF334155)),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: CircleAvatar(
                          backgroundColor: isPlaying ? const Color(0xFF3B82F6) : const Color(0xFF0F172A),
                          radius: 24,
                          child: IconButton(
                            icon: Icon(
                              isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                              color: isPlaying ? Colors.white : const Color(0xFF3B82F6),
                            ),
                            onPressed: () => togglePlayback(rec['id'] as String),
                          ),
                        ),
                        title: Text(rec['title'] as String, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          'Recorded: ${rec['date']} • Size: ${rec['size']}',
                          style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              rec['duration'] as String,
                              style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 16),
                            IconButton(
                              icon: const Icon(Icons.download_rounded, color: Color(0xFF94A3B8)),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Downloading recording file from MinIO storage...')),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      if (isPlaying) ...[
                        // Player simulator controls
                        Container(
                          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Text('0:00', style: TextStyle(color: Color(0xFF64748B), fontSize: 11)),
                                  Expanded(
                                    child: Slider(
                                      value: 0.1,
                                      activeColor: const Color(0xFF3B82F6),
                                      inactiveColor: const Color(0xFF0F172A),
                                      onChanged: (val) {},
                                    ),
                                  ),
                                  Text(rec['duration'] as String, style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ],
                  ),
                );
              },
            ),
    );
  }
}
