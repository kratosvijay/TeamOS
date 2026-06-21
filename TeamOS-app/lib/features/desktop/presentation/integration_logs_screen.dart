import 'package:flutter/material.dart';

class IntegrationLogsScreen extends StatefulWidget {
  const IntegrationLogsScreen({super.key});

  @override
  State<IntegrationLogsScreen> createState() => _IntegrationLogsScreenState();
}

class _IntegrationLogsScreenState extends State<IntegrationLogsScreen> {
  final List<Map<String, String>> _logs = [
    {
      'timestamp': '2026-06-21 23:40:12',
      'integration': 'GITHUB',
      'action': 'WEBHOOK_RECEIVED',
      'status': 'SUCCESS',
      'details': 'Processed push commit f409b1a from alex_dev.',
    },
    {
      'timestamp': '2026-06-21 23:30:00',
      'integration': 'VAULT',
      'action': 'TOKEN_ROTATE',
      'status': 'SUCCESS',
      'details': 'BullMQ cron job integration-token-refresh auto-rotated GitHub installation token.',
    },
    {
      'timestamp': '2026-06-21 22:15:45',
      'integration': 'MICROSOFT',
      'action': 'SYNC_CONNECTOR',
      'status': 'FAILED',
      'details': 'Token expired and refresh token rotation failed. Suspension alert dispatched to admin.',
    },
    {
      'timestamp': '2026-06-21 21:00:10',
      'integration': 'GOOGLE',
      'action': 'CALENDAR_SYNC',
      'status': 'SUCCESS',
      'details': 'Imported 12 meetings and updated sprint planning calendar boards.',
    },
  ];

  String _filterStatus = 'ALL';

  @override
  Widget build(BuildContext context) {
    final filtered = _filterStatus == 'ALL'
        ? _logs
        : _logs.where((l) => l['status'] == _filterStatus).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Integration Activity Logs', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                    'Audit & Sync Activity Log',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Monitor background sync routines, token rotation jobs, and webhook payloads.',
                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                  ),
                ],
              ),
              DropdownButton<String>(
                value: _filterStatus,
                dropdownColor: const Color(0xFF1E293B),
                style: const TextStyle(color: Colors.white),
                items: const [
                  DropdownMenuItem(value: 'ALL', child: Text('All Events')),
                  DropdownMenuItem(value: 'SUCCESS', child: Text('Success Only')),
                  DropdownMenuItem(value: 'FAILED', child: Text('Failures Only')),
                ],
                onChanged: (val) {
                  setState(() {
                    _filterStatus = val ?? 'ALL';
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Table layout
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(1.2),
                1: FlexColumnWidth(1.0),
                2: FlexColumnWidth(1.5),
                3: FlexColumnWidth(1.0),
                4: FlexColumnWidth(3.0),
              },
              children: [
                // Header row
                const TableRow(
                  decoration: BoxDecoration(
                    color: Color(0xFF0F172A),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('TIMESTAMP', style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('INTEGRATION', style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('ACTION', style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('STATUS', style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('DETAILS', style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                // Data rows
                ...filtered.map((log) {
                  final isSuccess = log['status'] == 'SUCCESS';
                  return TableRow(
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Color(0xFF334155))),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(log['timestamp']!, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          log['integration']!,
                          style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(log['action']!, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          log['status']!,
                          style: TextStyle(
                            color: isSuccess ? const Color(0xFF10B981) : const Color(0xFFF43F5E),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          log['details']!,
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
