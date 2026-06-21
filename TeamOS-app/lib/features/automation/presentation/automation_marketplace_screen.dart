import 'package:flutter/material.dart';

class AutomationMarketplaceScreen extends StatefulWidget {
  const AutomationMarketplaceScreen({super.key});

  @override
  State<AutomationMarketplaceScreen> createState() => _AutomationMarketplaceScreenState();
}

class _AutomationMarketplaceScreenState extends State<AutomationMarketplaceScreen> {
  final List<MarketplaceTemplate> _templates = [
    MarketplaceTemplate(name: 'Employee Onboarding Flow', category: 'HR', rating: 4.8, installs: 1450),
    MarketplaceTemplate(name: 'Leave Request Automation', category: 'HR', rating: 4.9, installs: 2310),
    MarketplaceTemplate(name: 'Procurement & CAPEX Signoff', category: 'Finance', rating: 4.7, installs: 890),
    MarketplaceTemplate(name: 'Sentry Incident Auto-Triage', category: 'Security', rating: 4.6, installs: 620),
    MarketplaceTemplate(name: 'Vendor Risk Assessment Flow', category: 'Legal', rating: 4.5, installs: 380),
    MarketplaceTemplate(name: 'Production Change SOP', category: 'Ops', rating: 4.9, installs: 1740),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Automation Marketplace', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Workflow Templates Directory',
              style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Boost process delivery speeds using pre-audited compliance blueprints and automated templates.',
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
            ),
            const SizedBox(height: 24),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.15,
              ),
              itemCount: _templates.length,
              itemBuilder: (context, idx) {
                final temp = _templates[idx];
                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F172A),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              temp.category,
                              style: const TextStyle(color: Color(0xFF3B82F6), fontSize: 9, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 14),
                              const SizedBox(width: 4),
                              Text('${temp.rating}', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(temp.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(height: 4),
                      Text('${temp.installs} workspaces active', style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
                      const Spacer(),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Template "${temp.name}" installed successfully')),
                            );
                          },
                          icon: const Icon(Icons.download, size: 14, color: Color(0xFF10B981)),
                          label: const Text('Install', style: TextStyle(color: Color(0xFF10B981), fontSize: 12, fontWeight: FontWeight.bold)),
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
    );
  }
}

class MarketplaceTemplate {
  final String name;
  final String category;
  final double rating;
  final int installs;

  MarketplaceTemplate({required this.name, required this.category, required this.rating, required this.installs});
}
