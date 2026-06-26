import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../dashboard/presentation/dashboard_screen.dart';

class WebhookConsoleScreen extends StatefulWidget {
  const WebhookConsoleScreen({super.key});

  @override
  State<WebhookConsoleScreen> createState() => _WebhookConsoleScreenState();
}

class _WebhookConsoleScreenState extends State<WebhookConsoleScreen> {
  final List<Map<String, dynamic>> _subscriptions = [
    {
      'id': 'sub-1',
      'url': 'https://api.partner.com/teamos/webhook',
      'events': ['TaskCreated', 'ProjectCreated'],
      'active': true,
    },
  ];

  final List<Map<String, dynamic>> _deliveries = [
    {
      'event': 'TaskCreated',
      'url': 'https://api.partner.com/teamos/webhook',
      'status': 200,
      'attempts': 1,
      'time': '12:04:15',
    },
    {
      'event': 'ProjectCreated',
      'url': 'https://api.partner.com/teamos/webhook',
      'status': 500,
      'attempts': 3,
      'time': '12:05:00',
    },
  ];

  void _addWebhook() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Add Webhook Subscription', style: TextStyle(color: Colors.white)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Destination URL',
                labelStyle: TextStyle(color: Color(0xFF94A3B8)),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF334155))),
              ),
              style: TextStyle(color: Colors.white),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Secret Key',
                labelStyle: TextStyle(color: Color(0xFF94A3B8)),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF334155))),
              ),
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF94A3B8))),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _subscriptions.add({
                  'id': 'sub-new',
                  'url': 'https://services.custom.org/callback',
                  'events': ['*'],
                  'active': true,
                });
              });
              Navigator.pop(ctx);
            },
            child: const Text('Subscribe', style: TextStyle(color: Color(0xFF3B82F6))),
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
                                  'Webhook Testing Console',
                                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            ElevatedButton.icon(
                              onPressed: _addWebhook,
                              icon: const Icon(Icons.add_rounded),
                              label: const Text('Add Webhook'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF3B82F6),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 28),
                        const Text('Active Subscriptions', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _subscriptions.length,
                          itemBuilder: (context, index) {
                            final sub = _subscriptions[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E293B),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFF334155)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(sub['url'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 4),
                                      Text('Events: ${sub['events'].join(', ')}', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                                    ],
                                  ),
                                  Switch(
                                    value: sub['active'],
                                    activeColor: const Color(0xFF3B82F6),
                                    onChanged: (val) {
                                      setState(() {
                                        sub['active'] = val;
                                      });
                                    },
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 28),
                        const Text('Delivery History Logs', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _deliveries.length,
                          itemBuilder: (context, index) {
                            final delivery = _deliveries[index];
                            final isSuccess = delivery['status'] == 200;
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E293B),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFF334155)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 10,
                                            height: 10,
                                            decoration: BoxDecoration(
                                              color: isSuccess ? Colors.green : Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(delivery['event'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(delivery['url'], style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text('Status: ${delivery['status']}', style: TextStyle(color: isSuccess ? Colors.green : Colors.red, fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 4),
                                      Text('Attempts: ${delivery['attempts']} | Time: ${delivery['time']}', style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
