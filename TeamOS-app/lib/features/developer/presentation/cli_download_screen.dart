import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../dashboard/presentation/dashboard_screen.dart';

class CliDownloadScreen extends StatelessWidget {
  const CliDownloadScreen({super.key});

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
                          'TeamOS Developer CLI Installation',
                          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        _buildInstallSection(),
                        const SizedBox(height: 24),
                        _buildCommandsReference(),
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

  Widget _buildInstallSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Installation via npm',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Download and install the teamos binary utility globally on your local machine.',
            style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF111827),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SelectableText(
                  'npm install -g @teamos/cli',
                  style: TextStyle(color: Colors.greenAccent, fontFamily: 'monospace', fontSize: 13),
                ),
                Icon(Icons.copy_rounded, color: Color(0xFF64748B), size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommandsReference() {
    final List<Map<String, String>> cmds = [
      {'cmd': 'teamos login', 'desc': 'Authenticate developer registry context.'},
      {'cmd': 'teamos create-app <name>', 'desc': 'Create template application structure.'},
      {'cmd': 'teamos generate widget <name>', 'desc': 'Generate a custom dashboard widget.'},
      {'cmd': 'teamos publish', 'desc': 'Publish the local plugin bundle to the marketplace.'},
      {'cmd': 'teamos doctor', 'desc': 'Verify development configurations and connection.'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'CLI Commands Reference',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...cmds.map((c) => Container(
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
                  Text(
                    c['cmd']!,
                    style: const TextStyle(color: Color(0xFF3B82F6), fontFamily: 'monospace', fontWeight: FontWeight.bold),
                  ),
                  Text(
                    c['desc']!,
                    style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                  ),
                ],
              ),
            ))
      ],
    );
  }
}
