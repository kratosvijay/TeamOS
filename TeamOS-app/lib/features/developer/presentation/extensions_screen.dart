import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../dashboard/presentation/dashboard_screen.dart';

class ExtensionsScreen extends StatefulWidget {
  const ExtensionsScreen({super.key});

  @override
  State<ExtensionsScreen> createState() => _ExtensionsScreenState();
}

class _ExtensionsScreenState extends State<ExtensionsScreen> {
  final List<Map<String, dynamic>> _extensions = [
    {
      'id': 'ext-github',
      'name': 'GitHub Connector',
      'version': '1.2.0',
      'author': 'TeamOS Core',
      'enabled': true,
      'permissions': ['READ_WRITE', 'ADMIN'],
    },
    {
      'id': 'ext-gitlab',
      'name': 'GitLab Sync',
      'version': '1.0.5',
      'author': 'TeamOS Core',
      'enabled': false,
      'permissions': ['READ_WRITE'],
    },
  ];

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
                          'Installed Extensions',
                          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 24),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _extensions.length,
                          itemBuilder: (context, index) {
                            final ext = _extensions[index];
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
                                      Row(
                                        children: [
                                          const Icon(Icons.extension_rounded, color: Color(0xFF3B82F6), size: 24),
                                          const SizedBox(width: 12),
                                          Text(
                                            ext['name'],
                                            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text('Version: ${ext['version']} | Author: ${ext['author']}', style: const TextStyle(color: Color(0xFF94A3B8))),
                                      const SizedBox(height: 12),
                                      Row(
                                        children: (ext['permissions'] as List<String>)
                                            .map((perm) => Container(
                                                  margin: const EdgeInsets.only(right: 8),
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFF111827),
                                                    borderRadius: BorderRadius.circular(6),
                                                  ),
                                                  child: Text(perm, style: const TextStyle(color: Color(0xFF3B82F6), fontSize: 10)),
                                                ))
                                            .toList(),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Switch(
                                        value: ext['enabled'],
                                        activeColor: const Color(0xFF3B82F6),
                                        onChanged: (val) {
                                          setState(() {
                                            ext['enabled'] = val;
                                          });
                                        },
                                      ),
                                      const SizedBox(width: 8),
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            _extensions.removeAt(index);
                                          });
                                        },
                                        child: const Text('Uninstall', style: TextStyle(color: Colors.redAccent)),
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
