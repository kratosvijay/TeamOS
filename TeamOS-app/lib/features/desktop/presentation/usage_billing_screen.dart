import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UsageBillingScreen extends StatefulWidget {
  const UsageBillingScreen({super.key});

  @override
  State<UsageBillingScreen> createState() => _UsageBillingScreenState();
}

class _UsageBillingScreenState extends State<UsageBillingScreen> {
  final List<Map<String, dynamic>> _meters = [
    {
      'name': 'Workspace Members (Seats)',
      'current': 11,
      'allowed': 15,
      'percentage': 0.73,
      'unit': 'users',
    },
    {
      'name': 'Active Projects',
      'current': 34,
      'allowed': 50,
      'percentage': 0.68,
      'unit': 'projects',
    },
    {
      'name': 'Database & File Storage',
      'current': 7.1,
      'allowed': 10,
      'percentage': 0.71,
      'unit': 'GB',
    },
    {
      'name': 'Monthly AI Tokens',
      'current': 25000,
      'allowed': 50000,
      'percentage': 0.50,
      'unit': 'tokens',
    },
    {
      'name': 'Meetings Recording Minutes',
      'current': 120,
      'allowed': 500,
      'percentage': 0.24,
      'unit': 'minutes',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Usage Metering', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Row(
        children: [
          // Sidebar menu
          Container(
            width: 240,
            color: const Color(0xFF1E293B),
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              children: [
                const Text(
                  'BILLING PLATFORM',
                  style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                ),
                const SizedBox(height: 12),
                _buildSidebarItem(context, Icons.credit_card, 'Overview & Plan', '/billing/subscription'),
                _buildSidebarItem(context, Icons.bar_chart, 'Usage Metering', '/billing/usage', active: true),
                _buildSidebarItem(context, Icons.history, 'Invoices Archive', '/billing/invoices'),
                _buildSidebarItem(context, Icons.list_alt_rounded, 'Plans Pricing', '/billing/plans'),
              ],
            ),
          ),
          // Main panel
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(40),
              children: [
                const Text(
                  'Resource Consumption Meters',
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Track current active workspace quotas against your limits.',
                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                ),
                const SizedBox(height: 32),
                // Meters grid
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _meters.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 24),
                  itemBuilder: (context, index) {
                    final item = _meters[index];
                    final pct = item['percentage'] as double;
                    final current = item['current'];
                    final allowed = item['allowed'];
                    final unit = item['unit'];
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item['name'] as String,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              Text(
                                '$current / $allowed $unit',
                                style: const TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: pct,
                              minHeight: 10,
                              backgroundColor: const Color(0xFF0F172A),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                pct > 0.85 ? const Color(0xFFF43F5E) : const Color(0xFF38BDF8),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            pct > 0.85 ? 'Warning: Near plan limits quota. Upgrade proposed.' : 'Current usage within boundaries.',
                            style: TextStyle(
                              color: pct > 0.85 ? const Color(0xFFF43F5E) : const Color(0xFF64748B),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
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
}
