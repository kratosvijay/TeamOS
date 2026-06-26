import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../dashboard/presentation/dashboard_screen.dart'; // import SidebarWidget & TopBarWidget

class DeveloperPortalScreen extends StatelessWidget {
  const DeveloperPortalScreen({super.key});

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
                        _buildHeader(context),
                        const SizedBox(height: 24),
                        _buildMetricsGrid(),
                        const SizedBox(height: 28),
                        const Text(
                          'Developer Tools & Modules',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildToolsGrid(context),
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

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'TeamOS Enterprise PaaS & Developer Portal',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Build, deploy, sandbox, and monitor custom widgets, plugins, and webhooks in real-time.',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => context.go('/developer/store'),
                  icon: const Icon(Icons.shopping_bag_outlined),
                  label: const Text('Browse Extension Store'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF1D4ED8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.6,
      children: const [
        DashboardWidgetCard(
          title: 'Total Installs',
          icon: Icons.download_done_rounded,
          value: '4,210',
        ),
        DashboardWidgetCard(
          title: 'API Calls (24h)',
          icon: Icons.api_rounded,
          value: '984.5k',
        ),
        DashboardWidgetCard(
          title: 'Active Sandboxes',
          icon: Icons.dns_rounded,
          value: '18 running',
        ),
        DashboardWidgetCard(
          title: 'Reviews Pending',
          icon: Icons.rate_review_outlined,
          value: '3 items',
        ),
      ],
    );
  }

  Widget _buildToolsGrid(BuildContext context) {
    final List<Map<String, dynamic>> tools = [
      {
        'title': 'API Keys Management',
        'desc': 'Issue, rotate, and scope hashed credential keys.',
        'icon': Icons.key_rounded,
        'route': '/developer/api-keys',
      },
      {
        'title': 'OAuth Applications',
        'desc': 'Register OAuth clients and set redirect URIs.',
        'icon': Icons.security_rounded,
        'route': '/developer/oauth-apps',
      },
      {
        'title': 'Installed Plugins',
        'desc': 'Manage permissions, settings, and toggles.',
        'icon': Icons.extension_rounded,
        'route': '/developer/extensions',
      },
      {
        'title': 'Dashboard Widget Builder',
        'desc': 'Create custom charts and dynamic dashboard widgets.',
        'icon': Icons.dashboard_customize_rounded,
        'route': '/developer/widget-builder',
      },
      {
        'title': 'Event Bus Monitor',
        'desc': 'Trace pub/sub dispatches and replay historical triggers.',
        'icon': Icons.cable_rounded,
        'route': '/developer/event-bus',
      },
      {
        'title': 'Webhook Testing Console',
        'desc': 'Simulate HTTP payloads, retries, and check deliveries.',
        'icon': Icons.webhook_rounded,
        'route': '/developer/webhooks',
      },
      {
        'title': 'GraphQL Gateway Explorer',
        'desc': 'Interactive query tool for Tasks, Meetings, Documents.',
        'icon': Icons.explore_outlined,
        'route': '/developer/graphql-explorer',
      },
      {
        'title': 'SDK Documentation',
        'desc': 'Developer guides for Node VM runtime environment.',
        'icon': Icons.menu_book_rounded,
        'route': '/developer/sdk-docs',
      },
      {
        'title': 'CLI Download',
        'desc': 'Install the teamos command line binary utility.',
        'icon': Icons.terminal_rounded,
        'route': '/developer/cli-download',
      },
      {
        'title': 'Developer Analytics',
        'desc': 'Check average CPU execution time and crashes.',
        'icon': Icons.bar_chart_rounded,
        'route': '/developer/analytics',
      },
      {
        'title': 'API Usage Logs',
        'desc': 'Real-time trace logs and rate limiting state.',
        'icon': Icons.history_toggle_off_rounded,
        'route': '/developer/api-usage',
      },
      {
        'title': 'Marketplace Reviews',
        'desc': 'Monitor reviews and pipeline status of your apps.',
        'icon': Icons.thumbs_up_down_rounded,
        'route': '/developer/reviews',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.8,
      ),
      itemCount: tools.length,
      itemBuilder: (context, index) {
        final tool = tools[index];
        return InkWell(
          onTap: () => context.go(tool['route']),
          borderRadius: BorderRadius.circular(16),
          child: Container(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(tool['icon'], color: const Color(0xFF3B82F6), size: 28),
                    const Icon(Icons.arrow_forward_rounded, color: Color(0xFF64748B), size: 16),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tool['title'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tool['desc'],
                      style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
