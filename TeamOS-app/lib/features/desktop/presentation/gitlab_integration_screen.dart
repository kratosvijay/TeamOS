import 'package:flutter/material.dart';

class GitLabIntegrationScreen extends StatefulWidget {
  const GitLabIntegrationScreen({super.key});

  @override
  State<GitLabIntegrationScreen> createState() => _GitLabIntegrationScreenState();
}

class _GitLabIntegrationScreenState extends State<GitLabIntegrationScreen> {
  bool _syncMergeRequests = true;
  bool _syncPipelines = true;
  bool _aiAnalysis = true;
  bool _runningAnalysis = false;
  String _analysisOutput = '';

  final List<Map<String, String>> _projects = [
    {'name': 'TeamOS / web-dashboard', 'id': '994801', 'visibility': 'Private'},
    {'name': 'TeamOS / mobile-engine', 'id': '994805', 'visibility': 'Private'},
  ];

  final List<Map<String, dynamic>> _pipelineRuns = [
    {
      'id': '#88102',
      'ref': 'refs/heads/develop',
      'status': 'SUCCESS',
      'duration': '4m 12s',
      'finishedAt': '12 mins ago',
    },
    {
      'id': '#88099',
      'ref': 'refs/merge-requests/122',
      'status': 'FAILED',
      'duration': '1m 45s',
      'finishedAt': '1 hour ago',
    },
  ];

  void _runPipelineAIAnalysis() {
    setState(() {
      _runningAnalysis = true;
      _analysisOutput = '';
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _runningAnalysis = false;
          _analysisOutput =
              '### GitLab CI/CD Failure Analysis (Job #88099)\n\n'
              '- **Failure Root Cause**: Jest test suite execution timed out on environment variable DB_URL resolution.\n'
              '- **Resolution Path**: The database health check endpoint returned 503 during migration stages.\n'
              '- **Suggested Fix**: Update `gitlab-ci.yml` database service health check retries from 3 to 10.';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('GitLab Connector Settings', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                      'Linked GitLab Projects',
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
                        itemCount: _projects.length,
                        separatorBuilder: (context, index) => const Divider(color: Color(0xFF334155), height: 1),
                        itemBuilder: (context, index) {
                          final project = _projects[index];
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                            leading: const Icon(Icons.folder_shared_outlined, color: Color(0xFF38BDF8)),
                            title: Text(project['name']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            subtitle: Text('Project ID: ${project['id']} • ${project['visibility']}', style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                            trailing: IconButton(
                              icon: const Icon(Icons.link_off, color: Color(0xFFF43F5E)),
                              onPressed: () {},
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'AI CI/CD Failure Analyzer',
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
                            'Analyze GitLab CI/CD build logs automatically when a job fails to isolate compilation or database deployment bugs.',
                            style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13, height: 1.4),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF38BDF8),
                              foregroundColor: const Color(0xFF0F172A),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            icon: _runningAnalysis
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF0F172A)),
                                  )
                                : const Icon(Icons.psychology, size: 18),
                            label: const Text('Simulate CI/CD Failure Logs Analysis', style: TextStyle(fontWeight: FontWeight.bold)),
                            onPressed: _runningAnalysis ? null : _runPipelineAIAnalysis,
                          ),
                          if (_analysisOutput.isNotEmpty) ...[
                            const SizedBox(height: 24),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0F172A),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: const Color(0xFF334155)),
                              ),
                              child: Text(
                                _analysisOutput,
                                style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.5, fontFamily: 'monospace'),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Recent GitLab Pipelines',
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
                        itemCount: _pipelineRuns.length,
                        separatorBuilder: (context, index) => const Divider(color: Color(0xFF334155), height: 1),
                        itemBuilder: (context, index) {
                          final run = _pipelineRuns[index];
                          final isSuccess = run['status'] == 'SUCCESS';
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            leading: Icon(
                              isSuccess ? Icons.check_circle_outline : Icons.error_outline,
                              color: isSuccess ? const Color(0xFF10B981) : const Color(0xFFF43F5E),
                            ),
                            title: Text('Pipeline ${run['id']}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            subtitle: Text('Branch: ${run['ref']} • Duration: ${run['duration']}', style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                            trailing: Text(
                              run['finishedAt']!,
                              style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
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
                      'Features Configuration',
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
                            title: const Text('Merge Requests Sync', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                            subtitle: const Text('Mirror MR status updates to sprint board', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                            value: _syncMergeRequests,
                            activeColor: const Color(0xFF38BDF8),
                            onChanged: (val) {
                              setState(() {
                                _syncMergeRequests = val;
                              });
                            },
                          ),
                          const Divider(color: Color(0xFF334155), height: 24),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Pipeline Alerts', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                            subtitle: const Text('Send chat warnings on pipeline execution failure', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                            value: _syncPipelines,
                            activeColor: const Color(0xFF38BDF8),
                            onChanged: (val) {
                              setState(() {
                                _syncPipelines = val;
                              });
                            },
                          ),
                          const Divider(color: Color(0xFF334155), height: 24),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('AI Analysis Logs', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                            subtitle: const Text('Enable AI diagnostics for pipeline runs', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                            value: _aiAnalysis,
                            activeColor: const Color(0xFF38BDF8),
                            onChanged: (val) {
                              setState(() {
                                _aiAnalysis = val;
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
