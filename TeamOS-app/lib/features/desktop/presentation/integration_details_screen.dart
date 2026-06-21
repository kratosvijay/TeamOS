import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class IntegrationDetailsScreen extends StatefulWidget {
  final String integrationId;
  const IntegrationDetailsScreen({super.key, required this.integrationId});

  @override
  State<IntegrationDetailsScreen> createState() => _IntegrationDetailsScreenState();
}

class _IntegrationDetailsScreenState extends State<IntegrationDetailsScreen> {
  bool _syncEnabled = true;
  String _permissionLevel = 'READ_WRITE';
  bool _isLoading = false;

  final Map<String, Map<String, dynamic>> _detailsCache = {
    'github': {
      'name': 'GitHub',
      'icon': Icons.code,
      'status': 'SYNCED',
      'lastSync': '2 mins ago',
      'description': 'Synchronize repositories, issues, PRs, commits, and releases with TeamOS project boards.',
      'scopes': ['repo', 'read:org', 'admin:repo_hook'],
      'owner': 'Workspace Admin',
      'installedAt': 'June 10, 2026',
    },
    'slack': {
      'name': 'Slack',
      'icon': Icons.chat_bubble_outline,
      'status': 'SYNCING',
      'lastSync': 'Just now',
      'description': 'Broadcast notifications to Slack channels, sync workspace chat channels, and enable TeamOS slash commands.',
      'scopes': ['incoming-webhook', 'commands', 'channels:read'],
      'owner': 'Workspace Admin',
      'installedAt': 'June 12, 2026',
    },
    'google': {
      'name': 'Google Workspace',
      'icon': Icons.email_outlined,
      'status': 'SYNCED',
      'lastSync': '1 hour ago',
      'description': 'Sync Google Calendars, launch Google Meet directly, and import Docs into TeamOS Wiki rooms.',
      'scopes': ['calendar.readonly', 'drive.readonly', 'meet.readonly'],
      'owner': 'Project Manager',
      'installedAt': 'May 20, 2026',
    },
    'microsoft': {
      'name': 'Microsoft 365',
      'icon': Icons.grid_view,
      'status': 'FAILED',
      'lastSync': '4 hours ago',
      'description': 'Sync Outlook Calendar, Microsoft Teams events, and OneDrive resources.',
      'scopes': ['Calendars.Read', 'Files.Read', 'User.Read'],
      'owner': 'Workspace Admin',
      'installedAt': 'June 18, 2026',
    },
    'gitlab': {
      'name': 'GitLab',
      'icon': Icons.terminal,
      'status': 'PAUSED',
      'lastSync': 'Yesterday',
      'description': 'Sync GitLab projects, merge requests, releases, and CI pipelines with sprint tracking.',
      'scopes': ['api', 'read_repository'],
      'owner': 'Lead Architect',
      'installedAt': 'May 28, 2026',
    },
  };

  void _triggerSync() {
    setState(() {
      _isLoading = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF10B981),
            content: Text('${_getIntegrationName()} manual synchronization triggered and completed.'),
          ),
        );
      }
    });
  }

  String _getIntegrationName() {
    return _detailsCache[widget.integrationId]?['name'] ?? widget.integrationId.toUpperCase();
  }

  IconData _getIntegrationIcon() {
    return _detailsCache[widget.integrationId]?['icon'] ?? Icons.extension;
  }

  @override
  Widget build(BuildContext context) {
    final details = _detailsCache[widget.integrationId] ?? {
      'name': widget.integrationId.toUpperCase(),
      'status': 'UNKNOWN',
      'lastSync': 'N/A',
      'description': 'Custom configured ecosystem connector.',
      'scopes': <String>[],
      'owner': 'N/A',
      'installedAt': 'N/A',
    };

    final scopes = details['scopes'] as List<String>;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: Text('${_getIntegrationName()} Settings', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(32),
        children: [
          // Header Card
          Card(
            color: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Color(0xFF334155)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(_getIntegrationIcon(), color: const Color(0xFF38BDF8), size: 40),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              _getIntegrationName(),
                              style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF334155),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                details['status'] as String,
                                style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          details['description'] as String,
                          style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF38BDF8),
                          foregroundColor: const Color(0xFF0F172A),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        icon: _isLoading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF0F172A)),
                              )
                            : const Icon(Icons.sync, size: 18),
                        label: Text(_isLoading ? 'Syncing...' : 'Sync Now', style: const TextStyle(fontWeight: FontWeight.bold)),
                        onPressed: _isLoading ? null : _triggerSync,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          // Configuration grid
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    // Connection Info
                    _buildSectionHeader('Connection Metadata'),
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
                          _buildDetailRow('Owner Identity', details['owner'] as String),
                          const Divider(color: Color(0xFF334155), height: 24),
                          _buildDetailRow('Installed On', details['installedAt'] as String),
                          const Divider(color: Color(0xFF334155), height: 24),
                          _buildDetailRow('Last Successful Sync', details['lastSync'] as String),
                          const Divider(color: Color(0xFF334155), height: 24),
                          _buildDetailRow('Scopes Granted', scopes.join(', ')),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Permissions
                    _buildSectionHeader('Permissions Mapping'),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF334155)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Assign RBAC level within this TeamOS Workspace for events processed by this integration.',
                            style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13, height: 1.4),
                          ),
                          const SizedBox(height: 20),
                          DropdownButtonFormField<String>(
                            value: _permissionLevel,
                            dropdownColor: const Color(0xFF1E293B),
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: 'Integration RBAC Permission',
                              labelStyle: TextStyle(color: Color(0xFF38BDF8)),
                              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF334155))),
                            ),
                            items: const [
                              DropdownMenuItem(value: 'READ_ONLY', child: Text('READ_ONLY (Read payloads only)')),
                              DropdownMenuItem(value: 'READ_WRITE', child: Text('READ_WRITE (Read and execute tasks)')),
                              DropdownMenuItem(value: 'ADMIN', child: Text('ADMIN (Full resource manipulation)')),
                            ],
                            onChanged: (val) {
                              setState(() {
                                _permissionLevel = val ?? 'READ_WRITE';
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 32),
              Expanded(
                child: Column(
                  children: [
                    _buildSectionHeader('Sync Toggles'),
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
                            title: const Text('Auto-Sync Engine', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                            subtitle: const Text('Synchronize external events in background hourly', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                            value: _syncEnabled,
                            activeColor: const Color(0xFF38BDF8),
                            onChanged: (val) {
                              setState(() {
                                _syncEnabled = val;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildSectionHeader('Danger Zone'),
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
                            'Uninstalling this integration will purge credentials from the secrets vault and disable outgoing hook loops.',
                            style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12, height: 1.4),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF43F5E).withOpacity(0.12),
                              side: const BorderSide(color: Color(0xFFF43F5E)),
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: const Color(0xFF0F172A),
                                  title: Text('Uninstall ${_getIntegrationName()}?', style: const TextStyle(color: Colors.white)),
                                  content: const Text('Are you sure you want to disconnect and delete all installation details?', style: TextStyle(color: Color(0xFF94A3B8))),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B))),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF43F5E)),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        context.pop();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Uninstalled ${_getIntegrationName()} successfully.')),
                                        );
                                      },
                                      child: const Text('Uninstall', style: TextStyle(color: Colors.white)),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: const Text('Uninstall Connection', style: TextStyle(color: Color(0xFFF43F5E), fontWeight: FontWeight.bold)),
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

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 14)),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }
}
