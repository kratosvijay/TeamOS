import 'package:flutter/material.dart';

class CicdIntegrationsScreen extends StatefulWidget {
  const CicdIntegrationsScreen({super.key});

  @override
  State<CicdIntegrationsScreen> createState() => _CicdIntegrationsScreenState();
}

class _CicdIntegrationsScreenState extends State<CicdIntegrationsScreen> {
  final List<Map<String, dynamic>> _pipelines = [
    {
      'provider': 'GitHub Actions',
      'repo': 'teamos-core',
      'workflow': 'Production Deploy',
      'status': 'SUCCESS',
      'commit': 'f409b1a',
      'time': '10 mins ago',
    },
    {
      'provider': 'GitLab CI',
      'repo': 'mobile-engine',
      'workflow': 'Integration Tests',
      'status': 'FAILED',
      'commit': 'a99b102',
      'time': '1 hour ago',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('CI/CD Pipelines Console', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(32),
        children: [
          const Text(
            'Active Integration Pipelines',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            'Consolidated status of builds, testing runs, and deployment workflows across providers.',
            style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
          ),
          const SizedBox(height: 32),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _pipelines.length,
              separatorBuilder: (context, index) => const Divider(color: Color(0xFF334155), height: 1),
              itemBuilder: (context, index) {
                final pipe = _pipelines[index];
                final isSuccess = pipe['status'] == 'SUCCESS';
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  leading: CircleAvatar(
                    backgroundColor: isSuccess ? const Color(0xFF10B981).withOpacity(0.12) : const Color(0xFFF43F5E).withOpacity(0.12),
                    child: Icon(
                      isSuccess ? Icons.verified : Icons.dangerous_outlined,
                      color: isSuccess ? const Color(0xFF10B981) : const Color(0xFFF43F5E),
                    ),
                  ),
                  title: Text(
                    '${pipe['provider']}: ${pipe['workflow']}',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Text(
                    'Repository: ${pipe['repo']} • Commit: ${pipe['commit']}',
                    style: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isSuccess ? const Color(0xFF10B981).withOpacity(0.12) : const Color(0xFFF43F5E).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          pipe['status']!,
                          style: TextStyle(
                            color: isSuccess ? const Color(0xFF10B981) : const Color(0xFFF43F5E),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(pipe['time']!, style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
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
