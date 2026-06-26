import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../dashboard/presentation/dashboard_screen.dart';

class ExtensionStoreScreen extends StatelessWidget {
  const ExtensionStoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {
        'id': 'market-github',
        'name': 'GitHub Connector',
        'desc': 'Connect repository pull requests, commit pushes, actions, and releases to tasks',
        'rating': 4.8,
        'category': 'Development',
        'version': '1.2.0',
        'author': 'TeamOS Core',
        'downloads': '1.5k',
      },
      {
        'id': 'market-gitlab',
        'name': 'GitLab Sync',
        'desc': 'Sync merge requests, issues, and CI pipelines monitoring with sprint boards',
        'rating': 4.6,
        'category': 'Development',
        'version': '1.0.5',
        'author': 'TeamOS Core',
        'downloads': '870',
      },
      {
        'id': 'market-slack',
        'name': 'Slack Alerts',
        'desc': 'Dispatch custom notification alerts, action updates, and daily summaries to Slack channels',
        'rating': 4.7,
        'category': 'Communication',
        'version': '1.5.0',
        'author': 'TeamOS Core',
        'downloads': '3.2k',
      },
      {
        'id': 'market-ai-agent',
        'name': 'AutoQA Agent',
        'desc': 'Autonomous AI Agent analyzing commit changes and writing unit test coverage drafts.',
        'rating': 4.9,
        'category': 'AI Agents',
        'version': '2.1.0',
        'author': 'AI Team',
        'downloads': '420',
      },
    ];

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
                          'Extension Marketplace',
                          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 24),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 1.6,
                          ),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index];
                            return Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E293B),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: const Color(0xFF334155)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF111827),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              item['category'].toString().toUpperCase(),
                                              style: const TextStyle(color: Color(0xFF3B82F6), fontSize: 10, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                                              const SizedBox(width: 4),
                                              Text(
                                                item['rating'].toString(),
                                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        item['name'],
                                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        item['desc'],
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Downloads: ${item['downloads']} | By ${item['author']}',
                                        style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
                                      ),
                                      ElevatedButton(
                                        onPressed: () => context.go('/developer/store/details/${item['id']}'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF3B82F6),
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                        ),
                                        child: const Text('View Details'),
                                      )
                                    ],
                                  )
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
