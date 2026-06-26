import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../dashboard/presentation/dashboard_screen.dart';

class ExtensionDetailsScreen extends StatefulWidget {
  final String extensionId;
  const ExtensionDetailsScreen({super.key, required this.extensionId});

  @override
  State<ExtensionDetailsScreen> createState() => _ExtensionDetailsScreenState();
}

class _ExtensionDetailsScreenState extends State<ExtensionDetailsScreen> {
  bool _isInstalled = false;

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
                        InkWell(
                          onTap: () => context.go('/developer/store'),
                          child: const Row(
                            children: [
                              Icon(Icons.arrow_back_rounded, color: Color(0xFF3B82F6), size: 16),
                              SizedBox(width: 4),
                              Text('Back to Marketplace Store', style: TextStyle(color: Color(0xFF3B82F6))),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildMainDetails(),
                        const SizedBox(height: 28),
                        _buildDependenciesCard(),
                        const SizedBox(height: 28),
                        _buildReviewsSection(),
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

  Widget _buildMainDetails() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 36,
            backgroundColor: Color(0xFF1E1E2E),
            child: Icon(Icons.extension_rounded, color: Color(0xFF3B82F6), size: 40),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'GitHub Integration Connector',
                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                const Text(
                  'By TeamOS Core • Version 1.2.0 • 1.5k Downloads',
                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Synchronize code repositories commits, releases, pull requests, and checks status dashboards with sprint boards in real-time, matching workspace context.',
                  style: TextStyle(color: Colors.white70, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isInstalled = !_isInstalled;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _isInstalled ? Colors.redAccent : const Color(0xFF3B82F6),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
            child: Text(_isInstalled ? 'Uninstall' : 'Install Extension'),
          ),
        ],
      ),
    );
  }

  Widget _buildDependenciesCard() {
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
            'Extension Dependencies Check',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.green, size: 16),
              SizedBox(width: 8),
              Text('TeamOS Core SDK v1.0.0 (Satisfied)', style: TextStyle(color: Color(0xFF94A3B8))),
            ],
          ),
          SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.green, size: 16),
              SizedBox(width: 8),
              Text('Node VM Sandbox runtime environment (Satisfied)', style: TextStyle(color: Color(0xFF94A3B8))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection() {
    final List<Map<String, dynamic>> reviews = [
      {'reviewer': 'Alice Dev', 'rating': 5, 'text': 'Perfect! Syncs issues automatically.'},
      {'reviewer': 'Bob Manager', 'rating': 4, 'text': 'Saves hours of status updates. Highly recommended.'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Developer Reviews & Ratings',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...reviews.map((r) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
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
                      Text(r['reviewer'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      Row(
                        children: List.generate(
                          5,
                          (i) => Icon(
                            Icons.star_rounded,
                            color: i < r['rating'] ? Colors.amber : const Color(0xFF334155),
                            size: 14,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(r['text'], style: const TextStyle(color: Color(0xFF94A3B8))),
                ],
              ),
            ))
      ],
    );
  }
}
