import 'package:flutter/material.dart';

class GitHubIntegrationScreen extends StatefulWidget {
  const GitHubIntegrationScreen({super.key});

  @override
  State<GitHubIntegrationScreen> createState() => _GitHubIntegrationScreenState();
}

class _GitHubIntegrationScreenState extends State<GitHubIntegrationScreen> {
  bool _syncPRs = true;
  bool _syncIssues = true;
  bool _aiSummaries = true;
  bool _triggeringAISummary = false;
  String _aiSummaryResult = '';

  final List<Map<String, String>> _repositories = [
    {'name': 'teamos-core', 'status': 'Synced', 'branch': 'main'},
    {'name': 'teamos-app', 'status': 'Synced', 'branch': 'develop'},
    {'name': 'teamos-infra', 'status': 'Synced', 'branch': 'master'},
  ];

  final List<Map<String, dynamic>> _recentEvents = [
    {
      'type': 'pull_request.merged',
      'repo': 'teamos-core',
      'ref': 'PR #412: Implement Offline Sync Batching',
      'user': 'alex_dev',
      'time': '10 mins ago',
    },
    {
      'type': 'push',
      'repo': 'teamos-app',
      'ref': 'Commit f409b1a: fix(UI): adjust command palette overlay margin',
      'user': 'sarah_m',
      'time': '34 mins ago',
    },
    {
      'type': 'workflow_run.success',
      'repo': 'teamos-infra',
      'ref': 'CI Pipeline: Production Release deployment success',
      'user': 'git_bot',
      'time': '1 hour ago',
    },
  ];

  void _generateAISummary() {
    setState(() {
      _triggeringAISummary = true;
      _aiSummaryResult = '';
    });
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        setState(() {
          _triggeringAISummary = false;
          _aiSummaryResult =
              '### AI Summary: Pull Request #412 (Offline Sync Batching)\n\n'
              '- **Key Additions**: Added `SyncBatch` payload structure with device ID registry support.\n'
              '- **Security**: Implemented field-level merge conflict resolutions bypassing default LWW updates.\n'
              '- **Tests**: Registered 12 new unit specs checking batch sequence recovery checks.';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('GitHub Connector Settings', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
              // Main content
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Linked Repositories',
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
                            leading: const Icon(Icons.folder_outlined, color: Color(0xFF38BDF8)),
                            title: Text(repo['name']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            subtitle: Text('Tracking branch: ${repo['branch']}', style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981).withOpacity(0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                repo['status']!,
                                style: const TextStyle(color: Color(0xFF10B981), fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'AI Code Summaries Generator',
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
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Instantly generate summaries for pull requests, commits, and releases using LLM analysis of code diffs.',
                            style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13, height: 1.4),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF38BDF8),
                              foregroundColor: const Color(0xFF0F172A),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            icon: _triggeringAISummary
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF0F172A)),
                                  )
                                : const Icon(Icons.auto_awesome, size: 18),
                            label: const Text('Simulate AI Summary Generation', style: TextStyle(fontWeight: FontWeight.bold)),
                            onPressed: _triggeringAISummary ? null : _generateAISummary,
                          ),
                          if (_aiSummaryResult.isNotEmpty) ...[
                            const SizedBox(height: 24),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0F172A),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: const Color(0xFF334155)),
                              ),
                              child: Text(
                                _aiSummaryResult,
                                style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.5, fontFamily: 'monospace'),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Recent Webhook Events Log',
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
                        itemCount: _recentEvents.length,
                        separatorBuilder: (context, index) => const Divider(color: Color(0xFF334155), height: 1),
                        itemBuilder: (context, index) {
                          final ev = _recentEvents[index];
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0F172A),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Icon(Icons.webhook, color: Color(0xFF38BDF8), size: 18),
                            ),
                            title: Row(
                              children: [
                                Text(
                                  ev['type']!,
                                  style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '@ ${ev['repo']}',
                                  style: const TextStyle(color: Color(0xFF64748B), fontSize: 11),
                                ),
                              ],
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(ev['ref']!, style: const TextStyle(color: Colors.white, fontSize: 13)),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(ev['user']!, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                Text(ev['time']!, style: const TextStyle(color: Color(0xFF64748B), fontSize: 10)),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 32),
              // Side Panel
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Feature Sync Hooks',
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
                            title: const Text('Sync Pull Requests', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                            subtitle: const Text('Update tasks automatically on merge', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                            value: _syncPRs,
                            activeColor: const Color(0xFF38BDF8),
                            onChanged: (val) {
                              setState(() {
                                _syncPRs = val;
                              });
                            },
                          ),
                          const Divider(color: Color(0xFF334155), height: 24),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Sync GitHub Issues', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                            subtitle: const Text('Convert issues to TeamOS backlog items', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                            value: _syncIssues,
                            activeColor: const Color(0xFF38BDF8),
                            onChanged: (val) {
                              setState(() {
                                _syncIssues = val;
                              });
                            },
                          ),
                          const Divider(color: Color(0xFF334155), height: 24),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('AI Automatic Summaries', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                            subtitle: const Text('Attach AI summaries directly to task cards', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                            value: _aiSummaries,
                            activeColor: const Color(0xFF38BDF8),
                            onChanged: (val) {
                              setState(() {
                                _aiSummaries = val;
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
