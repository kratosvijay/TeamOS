import 'package:flutter/material.dart';

class SessionManagementScreen extends StatefulWidget {
  const SessionManagementScreen({super.key});

  @override
  State<SessionManagementScreen> createState() => _SessionManagementScreenState();
}

class _SessionManagementScreenState extends State<SessionManagementScreen> {
  final List<UserSessionData> _sessions = [
    UserSessionData(id: '1', user: 'Alex Rivera (Admin)', device: 'MacBook Pro - Chrome', ip: '192.168.1.45', risk: 0, status: 'Current Session'),
    UserSessionData(id: '2', user: 'Elena Rostova', device: 'iPhone 15 - Safari', ip: '172.56.21.109', risk: 20, status: 'Active 2h ago'),
    UserSessionData(id: '3', user: 'Marcus Aurelius', device: 'Windows 11 - Edge', ip: '203.0.113.88', risk: 80, status: 'Active (VPN detected)'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Session Management', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        actions: [
          TextButton.icon(
            style: TextButton.styleFrom(foregroundColor: const Color(0xFFEF4444)),
            onPressed: () {
              setState(() {
                _sessions.clear();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All active sessions terminated')),
              );
            },
            icon: const Icon(Icons.logout),
            label: const Text('Terminate All'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Active User Sessions',
              style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Monitor logged-in sessions, device metrics, and risk scores. Revoke access immediately if needed.',
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
            ),
            const SizedBox(height: 24),

            // Sessions List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _sessions.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final ses = _sessions[index];
                final riskColor = ses.risk >= 50
                    ? const Color(0xFFEF4444)
                    : (ses.risk > 0 ? const Color(0xFFF59E0B) : const Color(0xFF10B981));

                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    leading: CircleAvatar(
                      backgroundColor: riskColor.withOpacity(0.1),
                      child: Icon(Icons.devices, color: riskColor),
                    ),
                    title: Text(ses.user, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(ses.device, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                        Text('IP: ${ses.ip} | Risk: ${ses.risk}%', style: TextStyle(color: const Color(0xFF64748B), fontSize: 11)),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Chip(
                          label: Text(ses.status, style: TextStyle(fontSize: 10, color: riskColor)),
                          backgroundColor: riskColor.withOpacity(0.05),
                          side: BorderSide(color: riskColor.withOpacity(0.2)),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.cancel, color: Color(0xFFEF4444)),
                          onPressed: () {
                            setState(() {
                              _sessions.removeAt(index);
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Session for ${ses.user} terminated')),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class UserSessionData {
  final String id;
  final String user;
  final String device;
  final String ip;
  final int risk;
  final String status;

  UserSessionData({
    required this.id,
    required this.user,
    required this.device,
    required this.ip,
    required this.risk,
    required this.status,
  });
}
