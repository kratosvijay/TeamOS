import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class MeetingAnalyticsScreen extends HookWidget {
  final String meetingId;
  const MeetingAnalyticsScreen({super.key, required this.meetingId});

  @override
  Widget build(BuildContext context) {
    // Mock analytics indices
    final analytics = {
      'attendanceRate': 100, // percentage
      'avgDuration': '45 minutes',
      'effectivenessScore': 88, // percentage
      'collaborationScore': 92, // percentage
      'actionItemsCreated': 2,
      'decisionsLogged': 2,
    };

    // Speaking time mock percentages
    final speakingTimes = [
      {'name': 'Sarah Jenkins', 'percent': 45.0, 'color': Colors.blueAccent},
      {'name': 'Alex Martinez', 'percent': 30.0, 'color': Colors.greenAccent},
      {'name': 'You', 'percent': 15.0, 'color': Colors.amberAccent},
      {'name': 'John Doe', 'percent': 10.0, 'color': Colors.redAccent},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Ceremony Analytics', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
            const Text('MEETING METRICS SUMMARY', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            // Grid of scores
            GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.6,
              children: [
                MetricCard(title: 'Attendance Rate', value: '${analytics['attendanceRate']}%', icon: Icons.people_rounded, color: Colors.greenAccent),
                MetricCard(title: 'Effectiveness Score', value: '${analytics['effectivenessScore']}%', icon: Icons.trending_up_rounded, color: Colors.blueAccent),
                MetricCard(title: 'Collaboration Score', value: '${analytics['collaborationScore']}%', icon: Icons.handshake_rounded, color: Colors.amberAccent),
              ],
            ),
            const SizedBox(height: 40),

            // Speaking Time Graph and Details
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Speaking time list
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
                        const Text('SPEAKING TIME DISTRIBUTION', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(height: 24),
                        ...speakingTimes.map((sp) {
                          final color = sp['color'] as Color;
                          final pct = sp['percent'] as double;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(sp['name'] as String, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                                    Text('$pct%', style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                LinearProgressIndicator(
                                  value: pct / 100,
                                  backgroundColor: const Color(0xFF0F172A),
                                  color: color,
                                  minHeight: 8,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                // Actions & Decisions totals
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
                        const Text('ENGAGEMENT METRICS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(height: 24),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.playlist_add_check_rounded, color: Colors.blueAccent, size: 28),
                          title: const Text('Action Items Created', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                          trailing: Text('${analytics['actionItemsCreated']}', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        const Divider(color: Color(0xFF334155), height: 24),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.gavel_rounded, color: Colors.amberAccent, size: 28),
                          title: const Text('Decisions Logged', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                          trailing: Text('${analytics['decisionsLogged']}', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        const Divider(color: Color(0xFF334155), height: 24),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.access_time_rounded, color: Colors.greenAccent, size: 28),
                          title: const Text('Average Meeting Duration', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                          trailing: Text(analytics['avgDuration'] as String, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.bold)),
              Icon(icon, color: color),
            ],
          ),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
