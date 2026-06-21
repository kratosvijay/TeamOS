import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class IntegrationsHomeScreen extends StatefulWidget {
  const IntegrationsHomeScreen({super.key});

  @override
  State<IntegrationsHomeScreen> createState() => _IntegrationsHomeScreenState();
}

class _IntegrationsHomeScreenState extends State<IntegrationsHomeScreen> {
  final List<Map<String, dynamic>> _installedIntegrations = [
    {
      'id': 'github',
      'name': 'GitHub',
      'icon': Icons.code,
      'status': 'SYNCED',
      'lastSync': '2 mins ago',
      'category': 'Development',
      'eventsCount': 1420,
    },
    {
      'id': 'slack',
      'name': 'Slack',
      'icon': Icons.chat_bubble_outline,
      'status': 'SYNCING',
      'lastSync': 'Just now',
      'category': 'Communication',
      'eventsCount': 8920,
    },
    {
      'id': 'google',
      'name': 'Google Workspace',
      'icon': Icons.email_outlined,
      'status': 'SYNCED',
      'lastSync': '1 hour ago',
      'category': 'Productivity',
      'eventsCount': 310,
    },
    {
      'id': 'microsoft',
      'name': 'Microsoft 365',
      'icon': Icons.grid_view,
      'status': 'FAILED',
      'lastSync': '4 hours ago',
      'category': 'Productivity',
      'eventsCount': 105,
    },
    {
      'id': 'gitlab',
      'name': 'GitLab',
      'icon': Icons.terminal,
      'status': 'PAUSED',
      'lastSync': 'Yesterday',
      'category': 'Development',
      'eventsCount': 850,
    },
  ];

  String _searchQuery = '';

  Color _getStatusColor(String status) {
    switch (status) {
      case 'SYNCED':
        return const Color(0xFF10B981); // Emerald green
      case 'SYNCING':
        return const Color(0xFF38BDF8); // Sky blue
      case 'FAILED':
        return const Color(0xFFF43F5E); // Rose red
      case 'PAUSED':
        return const Color(0xFFF59E0B); // Amber yellow
      default:
        return const Color(0xFF64748B); // Slate gray
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _installedIntegrations
        .where((i) => i['name']
            .toString()
            .toLowerCase()
            .contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Integrations Platform', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.security, color: Color(0xFF38BDF8)),
            tooltip: 'Secret Vault',
            onPressed: () => context.push('/integrations/secret-vault'),
          ),
          IconButton(
            icon: const Icon(Icons.webhook, color: Color(0xFF38BDF8)),
            tooltip: 'Webhooks',
            onPressed: () => context.push('/integrations/webhooks'),
          ),
          IconButton(
            icon: const Icon(Icons.list_alt, color: Color(0xFF38BDF8)),
            tooltip: 'Activity Logs',
            onPressed: () => context.push('/integrations/logs'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Row(
        children: [
          // Sidebar Panel for navigation quick links
          Container(
            width: 240,
            color: const Color(0xFF1E293B),
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              children: [
                const Text(
                  'INTEGRATIONS',
                  style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                ),
                const SizedBox(height: 12),
                _buildSidebarItem(context, Icons.dashboard, 'Overview', '/integrations', active: true),
                _buildSidebarItem(context, Icons.storefront, 'Marketplace', '/integrations/marketplace'),
                _buildSidebarItem(context, Icons.vpn_key, 'Secret Vault', '/integrations/secret-vault'),
                _buildSidebarItem(context, Icons.webhook, 'Webhooks Config', '/integrations/webhooks'),
                _buildSidebarItem(context, Icons.history, 'Integration Logs', '/integrations/logs'),
                const SizedBox(height: 32),
                const Text(
                  'CONNECTORS',
                  style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                ),
                const SizedBox(height: 12),
                _buildSidebarItem(context, Icons.code, 'GitHub Integration', '/integrations/github'),
                _buildSidebarItem(context, Icons.terminal, 'GitLab Integration', '/integrations/gitlab'),
                _buildSidebarItem(context, Icons.folder_copy, 'BitBucket Integration', '/integrations/bitbucket'),
                _buildSidebarItem(context, Icons.email_outlined, 'Google Workspace', '/integrations/google'),
                _buildSidebarItem(context, Icons.grid_view, 'Microsoft 365', '/integrations/microsoft'),
                _buildSidebarItem(context, Icons.chat_bubble_outline, 'Slack Integration', '/integrations/slack'),
                _buildSidebarItem(context, Icons.groups_3, 'MS Teams Integration', '/integrations/teams'),
                _buildSidebarItem(context, Icons.integration_instructions, 'CI/CD Pipelines', '/integrations/cicd'),
                _buildSidebarItem(context, Icons.cloud, 'Cloud Providers', '/integrations/cloud'),
              ],
            ),
          ),
          // Main Body
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(32),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Installed Integrations',
                          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Manage your workspace connections, sync loops, and webhooks config.',
                          style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF38BDF8),
                        foregroundColor: const Color(0xFF0F172A),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      icon: const Icon(Icons.add, size: 20),
                      label: const Text('Install New Integration', style: TextStyle(fontWeight: FontWeight.bold)),
                      onPressed: () => context.push('/integrations/marketplace'),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // Search field
                TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Filter installed integrations...',
                    hintStyle: const TextStyle(color: Color(0xFF64748B)),
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF64748B)),
                    fillColor: const Color(0xFF1E293B),
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF334155)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF38BDF8)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val;
                    });
                  },
                ),
                const SizedBox(height: 24),
                // Quick stats
                GridView.count(
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 2.2,
                  children: [
                    _buildStatCard('Active Integrations', '4', const Color(0xFF10B981)),
                    _buildStatCard('Failed Sync Tasks', '1', const Color(0xFFF43F5E)),
                    _buildStatCard('Total Standard Events', '12,657', const Color(0xFF38BDF8)),
                    _buildStatCard('Webhook Endpoints', '8', const Color(0xFFF59E0B)),
                  ],
                ),
                const SizedBox(height: 32),
                // Table/List of integrations
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filtered.length,
                    separatorBuilder: (context, index) => const Divider(color: Color(0xFF334155), height: 1),
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      final status = item['status'] as String;
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        leading: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F172A),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(item['icon'] as IconData, color: const Color(0xFF38BDF8), size: 24),
                        ),
                        title: Text(
                          item['name'] as String,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        subtitle: Row(
                          children: [
                            Text(
                              item['category'] as String,
                              style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
                            ),
                            const SizedBox(width: 8),
                            const Text('•', style: TextStyle(color: Color(0xFF64748B))),
                            const SizedBox(width: 8),
                            Text(
                              'Last sync: ${item['lastSync']}',
                              style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getStatusColor(status).withOpacity(0.1),
                                border: Border.all(color: _getStatusColor(status)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                status,
                                style: TextStyle(color: _getStatusColor(status), fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 24),
                            IconButton(
                              icon: const Icon(Icons.settings, color: Color(0xFF94A3B8)),
                              onPressed: () => context.push('/integrations/details/${item['id']}'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(BuildContext context, IconData icon, String title, String path, {bool active = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: active ? const Color(0xFF0F172A) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(icon, color: active ? const Color(0xFF38BDF8) : const Color(0xFF64748B), size: 18),
        title: Text(
          title,
          style: TextStyle(color: active ? Colors.white : const Color(0xFF94A3B8), fontWeight: active ? FontWeight.bold : FontWeight.normal),
        ),
        onTap: () {
          if (!active) {
            context.push(path);
          }
        },
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
