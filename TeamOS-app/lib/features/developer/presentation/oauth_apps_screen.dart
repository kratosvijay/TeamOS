import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../dashboard/presentation/dashboard_screen.dart';

class OauthAppsScreen extends StatefulWidget {
  const OauthAppsScreen({super.key});

  @override
  State<OauthAppsScreen> createState() => _OauthAppsScreenState();
}

class _OauthAppsScreenState extends State<OauthAppsScreen> {
  final List<Map<String, dynamic>> _apps = [
    {
      'clientId': 'tos_oauth_client_98231',
      'clientSecret': '••••••••••••••••••••••••',
      'name': 'ERP Sync Extension',
      'redirectUris': ['https://erp.partner.com/oauth/callback'],
      'scopes': ['READ_TASKS', 'ERP_READ'],
    },
  ];

  void _registerApp() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Register OAuth App', style: TextStyle(color: Colors.white)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Application Name',
                labelStyle: TextStyle(color: Color(0xFF94A3B8)),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF334155))),
              ),
              style: TextStyle(color: Colors.white),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Redirect URI',
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
                _apps.add({
                  'clientId': 'tos_oauth_client_new',
                  'clientSecret': 'tos_secret_new_98124',
                  'name': 'New OAuth Extension',
                  'redirectUris': ['https://ext.teamos.com/callback'],
                  'scopes': ['READ_TASKS'],
                });
              });
              Navigator.pop(ctx);
            },
            child: const Text('Register', style: TextStyle(color: Color(0xFF3B82F6))),
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
                                  'OAuth Applications',
                                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            ElevatedButton.icon(
                              onPressed: _registerApp,
                              icon: const Icon(Icons.add_rounded),
                              label: const Text('Register OAuth Client'),
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
                          itemCount: _apps.length,
                          itemBuilder: (context, index) {
                            final app = _apps[index];
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
                                      Text(
                                        app['name'],
                                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _apps.removeAt(index);
                                          });
                                        },
                                        icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Client ID: ${app['clientId']}',
                                    style: const TextStyle(color: Color(0xFF94A3B8), fontFamily: 'monospace'),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Client Secret: ${app['clientSecret']}',
                                    style: const TextStyle(color: Color(0xFF94A3B8), fontFamily: 'monospace'),
                                  ),
                                  const SizedBox(height: 12),
                                  const Text('Redirect URIs:', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  ...(app['redirectUris'] as List<String>).map(
                                    (uri) => Text(uri, style: const TextStyle(color: Color(0xFF64748B))),
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
