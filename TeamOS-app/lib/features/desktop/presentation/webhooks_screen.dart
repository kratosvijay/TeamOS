import 'package:flutter/material.dart';

class WebhooksScreen extends StatefulWidget {
  const WebhooksScreen({super.key});

  @override
  State<WebhooksScreen> createState() => _WebhooksScreenState();
}

class _WebhooksScreenState extends State<WebhooksScreen> {
  final List<Map<String, dynamic>> _webhookEndpoints = [
    {
      'url': 'https://api.analytics-provider.com/hooks/teamos',
      'events': 'task.created, task.completed',
      'status': 'Active',
      'secret': 'whsec_8849021a8c9b3d12f45',
    },
    {
      'url': 'https://audit-logs.corporate.internal/ingest',
      'events': 'project.created, member.invited',
      'status': 'Failing',
      'secret': 'whsec_991823ab498cd2e71fa',
    },
  ];

  final List<Map<String, dynamic>> _deliveryLogs = [
    {
      'url': 'https://api.analytics-provider.com/hooks/teamos',
      'event': 'task.created',
      'status': '200 OK',
      'attempt': '1',
      'time': '3 mins ago',
    },
    {
      'url': 'https://audit-logs.corporate.internal/ingest',
      'event': 'project.created',
      'status': '503 Service Unavailable',
      'attempt': '3 (Max Retries)',
      'time': '12 mins ago',
    },
  ];

  bool _isDeliveringTest = false;

  void _sendTestWebhook() {
    setState(() {
      _isDeliveringTest = true;
    });
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _isDeliveringTest = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Color(0xFF10B981),
            content: Text('Test webhook payload dispatched to all active endpoints successfully.'),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Webhook Platform Config', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(32),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Outgoing Webhook Endpoints',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Deliver TeamOS event payloads to external systems in real-time.',
                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                  ),
                ],
              ),
              Row(
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E293B),
                      side: const BorderSide(color: Color(0xFF334155)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    ),
                    icon: _isDeliveringTest
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF38BDF8)),
                          )
                        : const Icon(Icons.send_and_archive, color: Color(0xFF38BDF8), size: 18),
                    label: const Text('Test Delivery', style: TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.bold)),
                    onPressed: _isDeliveringTest ? null : _sendTestWebhook,
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF38BDF8),
                      foregroundColor: const Color(0xFF0F172A),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    ),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add Endpoint', style: TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Endpoints Table
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _webhookEndpoints.length,
              separatorBuilder: (context, index) => const Divider(color: Color(0xFF334155), height: 1),
              itemBuilder: (context, index) {
                final hook = _webhookEndpoints[index];
                final isActive = hook['status'] == 'Active';
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  title: Text(hook['url']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 6),
                      Text('Events: ${hook['events']}', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                      const SizedBox(height: 4),
                      Text('Signing Key: ${hook['secret']}', style: const TextStyle(color: Color(0xFF64748B), fontSize: 11, fontFamily: 'monospace')),
                    ],
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isActive ? const Color(0xFF10B981).withOpacity(0.12) : const Color(0xFFF43F5E).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      hook['status']!,
                      style: TextStyle(
                        color: isActive ? const Color(0xFF10B981) : const Color(0xFFF43F5E),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 40),
          const Text(
            'Delivery Logs & Dead Letter Queue (DLQ)',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          // Delivery logs table
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _deliveryLogs.length,
              separatorBuilder: (context, index) => const Divider(color: Color(0xFF334155), height: 1),
              itemBuilder: (context, index) {
                final log = _deliveryLogs[index];
                final is200 = log['status']!.contains('200');
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  leading: Icon(
                    is200 ? Icons.check_circle : Icons.error,
                    color: is200 ? const Color(0xFF10B981) : const Color(0xFFF43F5E),
                    size: 20,
                  ),
                  title: Text(log['url']!, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                  subtitle: Text('Event: ${log['event']} • Attempt: ${log['attempt']}', style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        log['status']!,
                        style: TextStyle(
                          color: is200 ? const Color(0xFF10B981) : const Color(0xFFF43F5E),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(log['time']!, style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
