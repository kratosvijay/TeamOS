import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class MeetingDetailsScreen extends HookWidget {
  final String meetingId;
  const MeetingDetailsScreen({super.key, required this.meetingId});

  @override
  Widget build(BuildContext context) {
    // Mock meeting details data
    final meeting = {
      'title': 'Project Architecture Review',
      'host': 'Sarah Jenkins',
      'startedAt': 'June 21, 2026, 10:00 AM',
      'endedAt': 'June 21, 2026, 10:45 AM',
      'duration': '45 minutes',
      'aiSummary': 'Sarah kicked off the meeting explaining the schema migration requirements. Alex verified that NestJS compiles successfully after the prisma generate client regeneration. John Doe reported that the BullMQ provisioning workers are operational in the background. The team decided to approve release candidate v1.2 and store recording segments in MinIO.',
      'keyPoints': [
        'Prisma client was regenerated successfully.',
        'BullMQ provisioning worker is running in the background.',
        'MinIO recordings bucket will be configured for MP4 exports.',
      ],
    };

    final participants = [
      {'name': 'Sarah Jenkins', 'role': 'HOST', 'duration': '45m'},
      {'name': 'Alex Martinez', 'role': 'PRESENTER', 'duration': '42m'},
      {'name': 'John Doe', 'role': 'ATTENDEE', 'duration': '45m'},
      {'name': 'You', 'role': 'PRESENTER', 'duration': '45m'},
    ];

    final decisions = [
      'Approve release candidate v1.2',
      'Store recording segments in MinIO for Phase 9',
    ];

    final actionItems = [
      {'title': 'Configure MinIO bucket path details', 'assignee': 'You', 'status': 'OPEN'},
      {'title': 'Write unit tests in meeting.service.spec.ts', 'assignee': 'Alex', 'status': 'COMPLETED'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Ceremony Outcomes', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(meeting['title'] as String, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(
                      'Held on ${meeting['startedAt']} • Hosted by ${meeting['host']}',
                      style: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: const Icon(Icons.play_circle_fill_rounded, color: Colors.white),
                  label: const Text('Watch Recording', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  onPressed: () => context.push('/meetings/recordings'),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // AI summary box
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.auto_awesome, color: Color(0xFF3B82F6), size: 20),
                      SizedBox(width: 8),
                      Text('AI MEETING SUMMARY', style: TextStyle(color: Color(0xFF3B82F6), fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    meeting['aiSummary'] as String,
                    style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 13, height: 1.6),
                  ),
                  const Divider(color: Color(0xFF334155), height: 32),
                  const Text('KEY DISCUSSION POINTS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                  const SizedBox(height: 12),
                  ...(meeting['keyPoints'] as List<String>).map((pt) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.circle, color: Color(0xFF3B82F6), size: 6),
                          const SizedBox(width: 10),
                          Expanded(child: Text(pt, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13))),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Side-by-side components
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Attendance
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF334155)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('ATTENDANCE TIMELINE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(height: 16),
                        ...participants.map((p) {
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              backgroundColor: const Color(0xFF0F172A),
                              child: Text(p['name']!.substring(0, 1), style: const TextStyle(color: Colors.white)),
                            ),
                            title: Text(p['name']!, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                            subtitle: Text('Role: ${p['role']}', style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
                            trailing: Text(p['duration']!, style: const TextStyle(color: Colors.greenAccent, fontSize: 13, fontWeight: FontWeight.bold)),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                // Decisions
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF334155)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('LOGGED DECISIONS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(height: 16),
                        ...decisions.map((dec) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Row(
                              children: [
                                const Icon(Icons.gavel_rounded, color: Colors.amberAccent, size: 18),
                                const SizedBox(width: 12),
                                Expanded(child: Text(dec, style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 13))),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Action Items list
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('MEETING ACTION ITEMS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 16),
                  ...actionItems.map((item) {
                    final isDone = item['status'] == 'COMPLETED';

                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        isDone ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                        color: isDone ? Colors.greenAccent : const Color(0xFF64748B),
                      ),
                      title: Text(
                        item['title']!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          decoration: isDone ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      subtitle: Text('Assignee: ${item['assignee']}', style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: isDone ? Colors.green.withOpacity(0.1) : Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item['status']!,
                          style: TextStyle(
                            color: isDone ? Colors.greenAccent : Colors.blueAccent,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
