import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SubscriptionManagementScreen extends StatefulWidget {
  const SubscriptionManagementScreen({super.key});

  @override
  State<SubscriptionManagementScreen> createState() => _SubscriptionManagementScreenState();
}

class _SubscriptionManagementScreenState extends State<SubscriptionManagementScreen> {
  bool _isLaunchingPortal = false;

  void _launchStripePortal() {
    setState(() {
      _isLaunchingPortal = true;
    });
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _isLaunchingPortal = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Color(0xFF10B981),
            content: Text('Simulated Stripe Billing Portal opened in default browser.'),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Workspace Subscription', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                _buildSidebarItem(context, Icons.credit_card, 'Overview & Plan', '/billing/subscription', active: true),
                _buildSidebarItem(context, Icons.bar_chart, 'Usage Metering', '/billing/usage'),
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
                  'Subscription Details',
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Review plan thresholds, payment cycles, and corporate invoice setups.',
                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                ),
                const SizedBox(height: 32),
                // Current Plan Card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF38BDF8).withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.stars, color: Color(0xFF38BDF8), size: 32),
                      ),
                      const SizedBox(width: 24),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'STARTUP PLAN',
                              style: TextStyle(color: Color(0xFF38BDF8), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.0),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Active Subscription (\$29/mo)',
                              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Renews automatically on July 21, 2026. Billed to card Visa ending in 4242.',
                              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF38BDF8),
                          foregroundColor: const Color(0xFF0F172A),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        icon: _isLaunchingPortal
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF0F172A)),
                              )
                            : const Icon(Icons.launch, size: 18),
                        label: const Text('Stripe Billing Portal', style: TextStyle(fontWeight: FontWeight.bold)),
                        onPressed: _isLaunchingPortal ? null : _launchStripePortal,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Payment Method
                const Text(
                  'Active Payment Methods',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.credit_card, color: Color(0xFF38BDF8), size: 28),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Visa ending in 4242',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Expires 12/2028 • Primary payment source',
                              style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFF334155))),
                        onPressed: _launchStripePortal,
                        child: const Text('Replace', style: TextStyle(color: Colors.white)),
                      ),
                    ],
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
}
