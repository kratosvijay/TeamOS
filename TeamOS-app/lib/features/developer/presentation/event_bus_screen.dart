import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../dashboard/presentation/dashboard_screen.dart';

class EventBusScreen extends StatefulWidget {
  const EventBusScreen({super.key});

  @override
  State<EventBusScreen> createState() => _EventBusScreenState();
}

class _EventBusScreenState extends State<EventBusScreen> {
  final List<Map<String, dynamic>> _events = [
    {
      'id': 'evt-1',
      'name': 'TaskCreated',
      'workspaceId': 'ws-production',
      'payload': '{"taskId": "task-abc-123", "title": "Implement VM VM2 Isolation"}',
      'time': '12:04:15',
    },
    {
      'id': 'evt-2',
      'name': 'ProjectCreated',
      'workspaceId': 'ws-production',
      'payload': '{"projectId": "proj-982", "name": "TeamOS PaaS Core"}',
      'time': '12:04:55',
    },
    {
      'id': 'evt-3',
      'name': 'InvoicePaid',
      'workspaceId': 'ws-billing',
      'payload': '{"invoiceId": "inv-901", "amount": 1500.0}',
      'time': '12:08:10',
    },
  ];

  void _triggerReplay() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Replay Historical Events', style: TextStyle(color: Colors.white)),
        content: const Text(
          'This will publish the recorded events for this workspace again to trigger active sandboxed extensions. Continue?',
          style: TextStyle(color: Color(0xFF94A3B8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF94A3B8))),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Events replayed successfully!')),
              );
            },
            child: const Text('Replay All', style: TextStyle(color: Color(0xFF3B82F6))),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Row(
        children: [
          const SidebarWidget(isCollapsed: false),
          Expanded(
            child: Column(
              children: [
                const TopBarWidget(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () => context.go('/developer'),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.arrow_back_rounded, color: Color(0xFF3B82F6), size: 16),
                                      SizedBox(width: 4),
                                      Text('Back to Developer Portal', style: TextStyle(color: Color(0xFF3B82F6))),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Event Bus Stream Monitor',
                                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            ElevatedButton.icon(
                              onPressed: _triggerReplay,
                              icon: const Icon(Icons.replay_rounded),
                              label: const Text('Replay Events'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF3B82F6),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 24),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _events.length,
                          itemBuilder: (context, index) {
                            final event = _events[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E293B),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: const Color(0xFF334155)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.cable_rounded, color: Color(0xFF3B82F6), size: 20),
                                          const SizedBox(width: 8),
                                          Text(
                                            event['name'],
                                            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        event['time'],
                                        style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Workspace: ${event['workspaceId']}',
                                    style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF111827),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      event['payload'],
                                      style: const TextStyle(
                                        color: Colors.greenAccent,
                                        fontFamily: 'monospace',
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
