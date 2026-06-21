import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class MeetingHomeScreen extends HookWidget {
  const MeetingHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock meeting schedules
    final activeMeetings = useState<List<Map<String, dynamic>>>([
      {
        'id': 'meet-active-1',
        'title': 'Daily Scrum Standup',
        'host': 'Sarah Jenkins',
        'type': 'SPRINT_PLANNING',
        'roomName': 'meet-TOS-SCRUM',
        'participantsCount': 5,
        'startedAt': '10 minutes ago',
      }
    ]);

    final upcomingMeetings = useState<List<Map<String, dynamic>>>([
      {
        'id': 'meet-up-1',
        'title': 'Project Architecture Review',
        'host': 'You',
        'type': 'PROJECT_REVIEW',
        'startTime': 'Today, 3:00 PM',
        'duration': '1 hour',
      },
      {
        'id': 'meet-up-2',
        'title': 'Sprint 2 Retrospective',
        'host': 'John Doe',
        'type': 'RETROSPECTIVE',
        'startTime': 'Tomorrow, 11:00 AM',
        'duration': '45 mins',
      },
    ]);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Meetings Workspace', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => context.go('/dashboard'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month_rounded, color: Colors.white),
            onPressed: () => context.push('/meetings/calendar'),
            tooltip: 'Workspace Calendar',
          ),
          IconButton(
            icon: const Icon(Icons.video_library_rounded, color: Colors.white),
            onPressed: () => context.push('/meetings/recordings'),
            tooltip: 'Recording Archives',
          ),
        ],
      ),
      body: Row(
        children: [
          // Sidebar / Options Panel
          Container(
            width: 280,
            color: const Color(0xFF1E293B),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.video_call_rounded, color: Colors.white),
                  label: const Text('Start Instant Meeting', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  onPressed: () {
                    // Navigate directly to a new active room
                    context.push('/meetings/room/instant-huddle');
                  },
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF94A3B8),
                    side: const BorderSide(color: Color(0xFF334155)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.add_alarm_rounded, color: Color(0xFF3B82F6)),
                  label: const Text('Schedule Meeting', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  onPressed: () => context.push('/meetings/schedule/new'),
                ),
                const Spacer(),
                // Timezone Widget
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('CURRENT TIMEZONE', style: TextStyle(color: Color(0xFF64748B), fontSize: 10, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text('GMT+05:30 (IST)', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('Local time matches host timezone', style: TextStyle(color: Color(0xFF64748B), fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Main content pane
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (activeMeetings.value.isNotEmpty) ...[
                    const Text('ACTIVE MEETINGS', style: TextStyle(color: Colors.greenAccent, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                    const SizedBox(height: 16),
                    ...activeMeetings.value.map((meet) {
                      return Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.greenAccent.withOpacity(0.3)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.greenAccent.withOpacity(0.05),
                              blurRadius: 16,
                              spreadRadius: 2,
                            )
                          ],
                        ),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.green,
                              child: Icon(Icons.online_prediction_rounded, color: Colors.white, size: 28),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(meet['title'] as String, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Hosted by ${meet['host']} • ${meet['participantsCount']} participants active',
                                    style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: () => context.push('/meetings/room/${meet['id']}'),
                              child: const Text('Join Now', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            )
                          ],
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 40),
                  ],

                  // Upcoming Meetings
                  const Text('UPCOMING CEREMONIES', style: TextStyle(color: Color(0xFF64748B), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                  const SizedBox(height: 16),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: upcomingMeetings.value.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final meet = upcomingMeetings.value[index];

                      return Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFF334155)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(meet['title'] as String, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 6),
                                Text(
                                  'Time: ${meet['startTime']} (${meet['duration']}) • Host: ${meet['host']}',
                                  style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.info_outline_rounded, color: Color(0xFF94A3B8)),
                                  onPressed: () => context.push('/meetings/details/${meet['id']}'),
                                  tooltip: 'Meeting Info',
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF334155),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  onPressed: () {},
                                  child: const Text('Add to Calendar', style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
