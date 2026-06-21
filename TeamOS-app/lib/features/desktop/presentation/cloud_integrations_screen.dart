import 'package:flutter/material.dart';

class CloudIntegrationsScreen extends StatefulWidget {
  const CloudIntegrationsScreen({super.key});

  @override
  State<CloudIntegrationsScreen> createState() => _CloudIntegrationsScreenState();
}

class _CloudIntegrationsScreenState extends State<CloudIntegrationsScreen> {
  final List<Map<String, dynamic>> _cloudMetrics = [
    {
      'provider': 'Amazon Web Services (AWS)',
      'costThisMonth': '\$3,124.50',
      'forecastCost': '\$4,200.00',
      'activeAlerts': 0,
      'status': 'HEALTHY',
    },
    {
      'provider': 'Google Cloud Platform (GCP)',
      'costThisMonth': '\$1,045.20',
      'forecastCost': '\$1,200.00',
      'activeAlerts': 1,
      'status': 'WARNING',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Cloud Infrastructure Control', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(32),
        children: [
          const Text(
            'Cloud Account Statuses & Costs',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            'Consolidated cloud infrastructure cost tracking and health diagnostics.',
            style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
          ),
          const SizedBox(height: 32),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.6,
            children: _cloudMetrics.map((metric) {
              final isHealthy = metric['status'] == 'HEALTHY';
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
                        Text(metric['provider']!, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: isHealthy ? const Color(0xFF10B981).withOpacity(0.12) : const Color(0xFFF59E0B).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            metric['status']!,
                            style: TextStyle(
                              color: isHealthy ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Month-to-Date Cost', style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                            const SizedBox(height: 6),
                            Text(metric['costThisMonth']!, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Forecasted Cost', style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                            const SizedBox(height: 6),
                            Text(metric['forecastCost']!, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 20, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                    const Divider(color: Color(0xFF334155), height: 32),
                    Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: metric['activeAlerts'] > 0 ? const Color(0xFFF43F5E) : const Color(0xFF64748B),
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${metric['activeAlerts']} Active Incident Alerts',
                          style: TextStyle(
                            color: metric['activeAlerts'] > 0 ? const Color(0xFFF43F5E) : const Color(0xFF64748B),
                            fontSize: 13,
                          ),
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
