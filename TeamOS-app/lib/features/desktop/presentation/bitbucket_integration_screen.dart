import 'package:flutter/material.dart';

class BitBucketIntegrationScreen extends StatefulWidget {
  const BitBucketIntegrationScreen({super.key});

  @override
  State<BitBucketIntegrationScreen> createState() => _BitBucketIntegrationScreenState();
}

class _BitBucketIntegrationScreenState extends State<BitBucketIntegrationScreen> {
  bool _syncRepos = true;
  bool _syncBuilds = true;

  final List<Map<String, String>> _repositories = [
    {'name': 'TeamOS / bitbucket-backend-mirror', 'status': 'Connected', 'type': 'Git'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('BitBucket Connector Settings', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(32),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Connected BitBucket Repositories',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF334155)),
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _repositories.length,
                        separatorBuilder: (context, index) => const Divider(color: Color(0xFF334155), height: 1),
                        itemBuilder: (context, index) {
                          final repo = _repositories[index];
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                            leading: const Icon(Icons.inventory_2_outlined, color: Color(0xFF38BDF8)),
                            title: Text(repo['name']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            subtitle: Text('Type: ${repo['type']}', style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                            trailing: Text(
                              repo['status']!,
                              style: const TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 32),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'BitBucket Webhook Configuration',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF334155)),
                      ),
                      child: Column(
                        children: [
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Mirror Pull Requests', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                            value: _syncRepos,
                            activeColor: const Color(0xFF38BDF8),
                            onChanged: (val) {
                              setState(() {
                                _syncRepos = val;
                              });
                            },
                          ),
                          const Divider(color: Color(0xFF334155), height: 24),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Track BitBucket Pipelines', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                            value: _syncBuilds,
                            activeColor: const Color(0xFF38BDF8),
                            onChanged: (val) {
                              setState(() {
                                _syncBuilds = val;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
