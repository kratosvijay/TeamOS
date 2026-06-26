import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../dashboard/presentation/dashboard_screen.dart';

class ApiKeysScreen extends StatefulWidget {
  const ApiKeysScreen({super.key});

  @override
  State<ApiKeysScreen> createState() => _ApiKeysScreenState();
}

class _ApiKeysScreenState extends State<ApiKeysScreen> {
  final List<Map<String, dynamic>> _keys = [
    {
      'id': '1',
      'name': 'Production Data Pipeline',
      'prefix': 'tos_live_abc123...',
      'scopes': ['READ_TASKS', 'READ_PROJECTS'],
      'lastUsed': '2026-06-25 14:23',
      'expiresAt': '2027-06-25',
    },
    {
      'id': '2',
      'name': 'AI Agent Integration',
      'prefix': 'tos_live_xyz890...',
      'scopes': ['AI_EXECUTE', 'WRITE_TASKS'],
      'lastUsed': '2026-06-26 11:05',
      'expiresAt': 'Never',
    },
  ];

  void _generateKey() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('API Key Generated', style: TextStyle(color: Colors.white)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Copy this key now. For security reasons, it cannot be displayed again.',
              style: TextStyle(color: Color(0xFF94A3B8)),
            ),
            SizedBox(height: 16),
            SelectableText(
              'tos_live_789fgh456jkl123vbn456qwe789',
              style: TextStyle(
                color: Color(0xFF3B82F6),
                fontFamily: 'monospace',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Done', style: TextStyle(color: Color(0xFF3B82F6))),
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
                                  'API Keys Credentials',
                                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            ElevatedButton.icon(
                              onPressed: _generateKey,
                              icon: const Icon(Icons.add_rounded),
                              label: const Text('Create API Key'),
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
                          itemCount: _keys.length,
                          itemBuilder: (context, index) {
                            final key = _keys[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
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
                                      Text(
                                        key['name'],
                                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Key: ${key['prefix']}',
                                        style: const TextStyle(color: Color(0xFF64748B), fontFamily: 'monospace'),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: (key['scopes'] as List<String>)
                                            .map(
                                              (scope) => Container(
                                                margin: const EdgeInsets.only(right: 8),
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFF1E1E2E),
                                                  borderRadius: BorderRadius.circular(6),
                                                  border: Border.all(color: const Color(0xFF334155)),
                                                ),
                                                child: Text(
                                                  scope,
                                                  style: const TextStyle(color: Color(0xFF3B82F6), fontSize: 10),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      )
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text('Last Used: ${key['lastUsed']}', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                                      const SizedBox(height: 4),
                                      Text('Expires: ${key['expiresAt']}', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                                      const SizedBox(height: 8),
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            _keys.removeAt(index);
                                          });
                                        },
                                        child: const Text('Revoke', style: TextStyle(color: Colors.redAccent)),
                                      ),
                                    ],
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
