import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Enterprise Admin Dashboard', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/dashboard'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enterprise Overview',
              style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Analytics Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: MediaQuery.of(context).size.width > 900 ? 5 : 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.3,
              children: const [
                AnalyticsCard(title: 'Security Score', value: '92%', color: Color(0xFF10B981), icon: Icons.security),
                AnalyticsCard(title: 'Compliance Score', value: '88%', color: Color(0xFF3B82F6), icon: Icons.verified_user),
                AnalyticsCard(title: 'Active Sessions', value: '42', color: Color(0xFF8B5CF6), icon: Icons.devices),
                AnalyticsCard(title: 'Failed Logins', value: '3', color: Color(0xFFEF4444), icon: Icons.gpp_bad),
                AnalyticsCard(title: 'DLP Violations', value: '0', color: Color(0xFFF59E0B), icon: Icons.warning_amber),
                AnalyticsCard(title: 'MFA Adoption', value: '85%', color: Color(0xFF06B6D4), icon: Icons.phonelink_ring),
                AnalyticsCard(title: 'Retention Rules', value: '5', color: Color(0xFFEC4899), icon: Icons.restore_from_trash),
                AnalyticsCard(title: 'Active Legal Holds', value: '1', color: Color(0xFFF43F5E), icon: Icons.gavel),
                AnalyticsCard(title: 'Audit Exports', value: '12', color: Color(0xFF14B8A6), icon: Icons.file_download),
                AnalyticsCard(title: 'Security Incidents', value: '2', color: Color(0xFF6366F1), icon: Icons.report_problem),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              'Administrative Settings & Controls',
              style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Navigation Links
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                AdminSettingsTile(
                  title: 'Security Center',
                  subtitle: 'Manage MFA policies, password logins, and IP allowlists',
                  icon: Icons.shield,
                  onTap: () => context.push('/admin/security'),
                ),
                AdminSettingsTile(
                  title: 'Compliance Center',
                  subtitle: 'SOC2, ISO27001 readiness checklists and audit logs',
                  icon: Icons.assignment_turned_in,
                  onTap: () => context.push('/admin/compliance'),
                ),
                AdminSettingsTile(
                  title: 'Single Sign-On (SSO)',
                  subtitle: 'Configure Okta, Azure AD, and OpenID Connect identity providers',
                  icon: Icons.vpn_key,
                  onTap: () => context.push('/admin/sso'),
                ),
                AdminSettingsTile(
                  title: 'SCIM Directory Sync',
                  subtitle: 'Manage automated user provisioning and syncing',
                  icon: Icons.sync,
                  onTap: () => context.push('/admin/scim'),
                ),
                AdminSettingsTile(
                  title: 'Session Management',
                  subtitle: 'Monitor and terminate active user sessions and device access',
                  icon: Icons.phonelink_setup,
                  onTap: () => context.push('/admin/sessions'),
                ),
                AdminSettingsTile(
                  title: 'Data Retention Policies',
                  subtitle: 'Define schedules for messages, documents, and meetings',
                  icon: Icons.restore,
                  onTap: () => context.push('/admin/retention'),
                ),
                AdminSettingsTile(
                  title: 'Data Loss Prevention (DLP)',
                  subtitle: 'Configure rules to block, warn, or quarantine credentials & SSNs',
                  icon: Icons.policy,
                  onTap: () => context.push('/admin/dlp'),
                ),
                AdminSettingsTile(
                  title: 'Legal Hold Registry',
                  subtitle: 'Ensure key compliance data is preserved during audit holds',
                  icon: Icons.gavel_rounded,
                  onTap: () => context.push('/admin/legal-hold'),
                ),
                AdminSettingsTile(
                  title: 'Audit Logs Export',
                  subtitle: 'Download logs in CSV, JSON, or PDF formats',
                  icon: Icons.download,
                  onTap: () => context.push('/admin/audit'),
                ),
                AdminSettingsTile(
                  title: 'Organization Hierarchy',
                  subtitle: 'Configure company workspaces and organization nodes',
                  icon: Icons.corporate_fare,
                  onTap: () => context.push('/admin/organization'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AnalyticsCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  const AnalyticsCard({
    super.key,
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
              ),
              Icon(icon, color: color, size: 20),
            ],
          ),
          Text(
            value,
            style: TextStyle(fontSize: 24, color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class AdminSettingsTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const AdminSettingsTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1E293B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Icon(icon, color: const Color(0xFF3B82F6), size: 28),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
        trailing: const Icon(Icons.chevron_right, color: Color(0xFF64748B)),
        onTap: onTap,
      ),
    );
  }
}
