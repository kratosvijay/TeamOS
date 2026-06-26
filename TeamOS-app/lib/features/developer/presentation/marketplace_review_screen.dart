import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../dashboard/presentation/dashboard_screen.dart';

class MarketplaceReviewScreen extends StatelessWidget {
  const MarketplaceReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> pipeline = [
      {'step': 'Draft', 'status': 'COMPLETED', 'desc': 'App definition and configuration loaded.'},
      {'step': 'Submitted', 'status': 'COMPLETED', 'desc': 'Manifest and package bundles uploaded.'},
      {'step': 'Automated Security Scan', 'status': 'COMPLETED', 'desc': 'Static scan for Prisma bypass or raw fs access.'},
      {'step': 'Manual Review', 'status': 'IN_PROGRESS', 'desc': 'Platform architect code audits.'},
      {'step': 'Approved', 'status': 'PENDING', 'desc': 'Exposed in catalog marketplace.'},
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
                          'Extension Approval Lifecycle Review',
                          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        _buildPipelineProgressCard(),
                        const SizedBox(height: 28),
                        const Text('Review Pipeline Steps', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        ...pipeline.map((p) {
                          final isDone = p['status'] == 'COMPLETED';
                          final isCurrent = p['status'] == 'IN_PROGRESS';
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E293B),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isCurrent ? const Color(0xFF3B82F6) : const Color(0xFF334155),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isDone
                                      ? Icons.check_circle_rounded
                                      : isCurrent
                                          ? Icons.hourglass_top_rounded
                                          : Icons.radio_button_off_rounded,
                                  color: isDone
                                      ? Colors.green
                                      : isCurrent
                                          ? const Color(0xFF3B82F6)
                                          : const Color(0xFF64748B),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        p['step'],
                                        style: TextStyle(
                                          color: isCurrent ? Colors.white : const Color(0xFF94A3B8),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(p['desc'], style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
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

  Widget _buildPipelineProgressCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pipeline Status: Under Review',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Extension package AutoQA Agent is currently in Step 4: Manual Review.',
            style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
          ),
        ],
      ),
    );
  }
}
