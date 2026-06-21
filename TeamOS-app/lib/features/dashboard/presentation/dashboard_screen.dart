import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/responsive_layout.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: const DashboardMobileView(),
      tablet: const DashboardTabletView(),
      desktop: const DashboardDesktopView(),
    );
  }
}

// Sub-views implementations
class DashboardDesktopView extends StatelessWidget {
  const DashboardDesktopView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Row(
        children: [
          // Sidebar
          const SidebarWidget(isCollapsed: false),
          // Main content area
          Expanded(
            child: Column(
              children: [
                const TopBarWidget(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const WelcomeBanner(),
                        const SizedBox(height: 24),
                        // Dashboard Grid
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 3,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio: 1.5,
                          children: const [
                            DashboardWidgetCard(title: 'My Tasks', icon: Icons.playlist_add_check_rounded, value: '5 active'),
                            DashboardWidgetCard(title: 'Active Projects', icon: Icons.folder_open_rounded, value: '3 repositories'),
                            DashboardWidgetCard(title: 'Upcoming Meetings', icon: Icons.videocam_outlined, value: '1 standup'),
                            DashboardWidgetCard(title: 'Sprint Progress', icon: Icons.trending_up_rounded, value: 'Sprint 1 - 70%'),
                            DashboardWidgetCard(title: 'Online Members', icon: Icons.people_outline_rounded, value: '4 members'),
                            DashboardWidgetCard(title: 'Recent Activity', icon: Icons.history_rounded, value: '12 updates today'),
                          ],
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

class DashboardTabletView extends StatelessWidget {
  const DashboardTabletView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Row(
        children: [
          const SidebarWidget(isCollapsed: true),
          Expanded(
            child: Column(
              children: [
                const TopBarWidget(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const WelcomeBanner(),
                        const SizedBox(height: 20),
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.4,
                          children: const [
                            DashboardWidgetCard(title: 'My Tasks', icon: Icons.playlist_add_check_rounded, value: '5 active'),
                            DashboardWidgetCard(title: 'Active Projects', icon: Icons.folder_open_rounded, value: '3 repositories'),
                            DashboardWidgetCard(title: 'Upcoming Meetings', icon: Icons.videocam_outlined, value: '1 standup'),
                            DashboardWidgetCard(title: 'Sprint Progress', icon: Icons.trending_up_rounded, value: 'Sprint 1 - 70%'),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardMobileView extends StatelessWidget {
  const DashboardMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('TeamOS Dashboard', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: Colors.white),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const WelcomeBanner(),
            const SizedBox(height: 16),
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                DashboardWidgetCard(title: 'My Tasks', icon: Icons.playlist_add_check_rounded, value: '5 active'),
                SizedBox(height: 12),
                DashboardWidgetCard(title: 'Active Projects', icon: Icons.folder_open_rounded, value: '3 repositories'),
                SizedBox(height: 12),
                DashboardWidgetCard(title: 'Upcoming Meetings', icon: Icons.videocam_outlined, value: '1 standup'),
                SizedBox(height: 12),
                DashboardWidgetCard(title: 'Online Members', icon: Icons.people_outline_rounded, value: '4 members'),
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1E293B),
        selectedItemColor: const Color(0xFF3B82F6),
        unselectedItemColor: const Color(0xFF64748B),
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            context.go('/dashboard');
          } else if (index == 1) {
            context.go('/chat');
          } else if (index == 2) {
            context.go('/projects');
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline_rounded), label: 'Chats'),
          BottomNavigationBarItem(icon: Icon(Icons.check_circle_outline_rounded), label: 'Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Settings'),
        ],
      ),
    );
  }
}

// Inline Widgets
class SidebarWidget extends StatelessWidget {
  final bool isCollapsed;
  const SidebarWidget({super.key, required this.isCollapsed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isCollapsed ? 70 : 240,
      color: const Color(0xFF1E293B),
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Icon(Icons.space_dashboard_rounded, color: const Color(0xFF3B82F6), size: isCollapsed ? 32 : 40),
          if (!isCollapsed) ...[
            const SizedBox(height: 16),
            const Text('TeamOS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
          ],
          const SizedBox(height: 40),
          Expanded(
            child: ListView(
              children: [
                SidebarItem(icon: Icons.dashboard_rounded, label: 'Dashboard', isCollapsed: isCollapsed),
                SidebarItem(icon: Icons.folder_open_rounded, label: 'Projects', isCollapsed: isCollapsed),
                SidebarItem(icon: Icons.playlist_add_check_rounded, label: 'Tasks', isCollapsed: isCollapsed),
                SidebarItem(icon: Icons.forum_outlined, label: 'Chat', isCollapsed: isCollapsed),
                SidebarItem(icon: Icons.videocam_outlined, label: 'Meetings', isCollapsed: isCollapsed),
                SidebarItem(icon: Icons.settings_outlined, label: 'Settings', isCollapsed: isCollapsed),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isCollapsed;
  const SidebarItem({super.key, required this.icon, required this.label, required this.isCollapsed});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF94A3B8)),
      title: isCollapsed ? null : Text(label, style: const TextStyle(color: Color(0xFF94A3B8))),
      onTap: () {
        if (label == 'Dashboard') {
          context.go('/dashboard');
        } else if (label == 'Projects') {
          context.go('/projects');
        } else if (label == 'Chat') {
          context.go('/chat');
        }
      },
    );
  }
}

class TopBarWidget extends StatelessWidget {
  const TopBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      color: const Color(0xFF1E293B),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Workspace Dashboard', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          Row(
            children: [
              IconButton(icon: const Icon(Icons.search, color: Colors.white), onPressed: () {}),
              const SizedBox(width: 16),
              const CircleAvatar(
                backgroundColor: Color(0xFF3B82F6),
                child: Text('U', style: TextStyle(color: Colors.white)),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class WelcomeBanner extends StatelessWidget {
  const WelcomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Welcome back, Developer!', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('Check your upcoming tasks, project standups, and team announcements.', style: TextStyle(color: Colors.white70)),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class DashboardWidgetCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String value;

  const DashboardWidgetCard({super.key, required this.title, required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
              Text(title, style: const TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.bold, fontSize: 14)),
              Icon(icon, color: const Color(0xFF3B82F6)),
            ],
          ),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
