import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  final List<Map<String, dynamic>> _catalog = [
    {
      'id': 'github',
      'name': 'GitHub',
      'icon': Icons.code,
      'category': 'Development',
      'installed': true,
      'description': 'Sync PRs, issues, commits, and automate code reviews.',
      'rating': '4.9',
    },
    {
      'id': 'slack',
      'name': 'Slack',
      'icon': Icons.chat_bubble_outline,
      'category': 'Communication',
      'installed': true,
      'description': 'Bi-directional chat sync, notification broadcasts, and slash commands.',
      'rating': '4.8',
    },
    {
      'id': 'google',
      'name': 'Google Workspace',
      'icon': Icons.email_outlined,
      'category': 'Productivity',
      'installed': true,
      'description': 'Sync Google Calendar meetings and import Google Docs.',
      'rating': '4.7',
    },
    {
      'id': 'microsoft',
      'name': 'Microsoft 365',
      'icon': Icons.grid_view,
      'category': 'Productivity',
      'installed': true,
      'description': 'Sync Outlook Calendar meetings and OneDrive files.',
      'rating': '4.6',
    },
    {
      'id': 'gitlab',
      'name': 'GitLab',
      'icon': Icons.terminal,
      'category': 'Development',
      'installed': true,
      'description': 'Sync GitLab repositories, merge requests, and pipelines.',
      'rating': '4.8',
    },
    {
      'id': 'bitbucket',
      'name': 'BitBucket',
      'icon': Icons.folder_copy,
      'category': 'Development',
      'installed': false,
      'description': 'Sync Bitbucket repositories and build runs.',
      'rating': '4.5',
    },
    {
      'id': 'jira',
      'name': 'Jira Software',
      'icon': Icons.assignment_outlined,
      'category': 'Management',
      'installed': false,
      'description': 'Map Jira tickets to TeamOS sprint backlog cards.',
      'rating': '4.4',
    },
    {
      'id': 'confluence',
      'name': 'Confluence',
      'icon': Icons.menu_book,
      'category': 'Management',
      'installed': false,
      'description': 'Index Confluence spaces for hybrid semantic search RAG.',
      'rating': '4.3',
    },
  ];

  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final categories = ['All', 'Development', 'Productivity', 'Communication', 'Management'];
    
    final filtered = _selectedCategory == 'All'
        ? _catalog
        : _catalog.where((c) => c['category'] == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Integrations Marketplace', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(32),
        children: [
          const Text(
            'Ecosystem Integrations Directory',
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            'Discover and install connections to link external workflows with TeamOS workspace boards.',
            style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
          ),
          const SizedBox(height: 24),
          // Category selector
          Wrap(
            spacing: 12,
            children: categories.map((cat) {
              final active = _selectedCategory == cat;
              return ChoiceChip(
                label: Text(cat),
                selected: active,
                selectedColor: const Color(0xFF38BDF8),
                backgroundColor: const Color(0xFF1E293B),
                labelStyle: TextStyle(
                  color: active ? const Color(0xFF0F172A) : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _selectedCategory = cat;
                    });
                  }
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          // Catalog Grid
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 1.5,
            children: filtered.map((item) {
              final installed = item['installed'] as bool;
              return Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F172A),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(item['icon'] as IconData, color: const Color(0xFF38BDF8), size: 24),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['name'] as String, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(item['category'] as String, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Color(0xFFF59E0B), size: 14),
                            const SizedBox(width: 4),
                            Text(item['rating'] as String, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Text(
                        item['description'] as String,
                        style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13, height: 1.4),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        installed
                            ? OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Color(0xFF334155)),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                ),
                                onPressed: () => context.push('/integrations/details/${item['id']}'),
                                child: const Text('Configure', style: TextStyle(color: Colors.white, fontSize: 13)),
                              )
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF38BDF8),
                                  foregroundColor: const Color(0xFF0F172A),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                ),
                                onPressed: () => context.push('/integrations/install/${item['id']}'),
                                child: const Text('Install', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                              ),
                        if (installed)
                          const Text(
                            'Installed',
                            style: TextStyle(color: Color(0xFF10B981), fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
