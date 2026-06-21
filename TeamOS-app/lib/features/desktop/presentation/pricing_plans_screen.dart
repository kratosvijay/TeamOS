import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PricingPlansScreen extends StatefulWidget {
  const PricingPlansScreen({super.key});

  @override
  State<PricingPlansScreen> createState() => _PricingPlansScreenState();
}

class _PricingPlansScreenState extends State<PricingPlansScreen> {
  bool _isYearly = false;

  final List<Map<String, dynamic>> _plans = [
    {
      'name': 'FREE',
      'priceMonthly': '\$0',
      'priceYearly': '\$0',
      'desc': 'For small teams exploring TeamOS',
      'features': [
        '5 Users limit',
        '5 Projects',
        '1 GB Storage quota',
        '5,000 AI Tokens',
        'No Meeting recordings',
        'No Marketplace access',
      ],
      'accent': const Color(0xFF64748B),
      'buttonText': 'Current Plan',
      'isPopular': false,
    },
    {
      'name': 'STARTUP',
      'priceMonthly': '\$29',
      'priceYearly': '\$24',
      'desc': 'For growing product groups',
      'features': [
        '15 Users limit',
        '50 Projects',
        '10 GB Storage quota',
        '50,000 AI Tokens',
        'Integrations enabled',
        'Meeting recordings enabled',
      ],
      'accent': const Color(0xFF38BDF8),
      'buttonText': 'Upgrade to Startup',
      'isPopular': true,
    },
    {
      'name': 'BUSINESS',
      'priceMonthly': '\$99',
      'priceYearly': '\$79',
      'desc': 'For advanced scale operations',
      'features': [
        '100 Users limit',
        '500 Projects',
        '100 GB Storage quota',
        '500,000 AI Tokens',
        'Advanced AI Agents',
        'SSO & Marketplace',
      ],
      'accent': const Color(0xFF818CF8),
      'buttonText': 'Upgrade to Business',
      'isPopular': false,
    },
    {
      'name': 'ENTERPRISE',
      'priceMonthly': 'Custom',
      'priceYearly': 'Custom',
      'desc': 'For bespoke enterprise governance',
      'features': [
        'Unlimited Users & Projects',
        'Custom Storage quota',
        'Custom AI models',
        'Dedicated support SLA',
        'Advanced audit trails & SSO',
        'Self-hosted deployment',
      ],
      'accent': const Color(0xFFC084FC),
      'buttonText': 'Contact Sales',
      'isPopular': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Upgrade Plan & Subscription', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(40),
        children: [
          const Center(
            child: Text(
              'Select Your TeamOS Plan',
              style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text(
              'Scale workspaces, AI processing budgets, and file storage dynamically.',
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 15),
            ),
          ),
          const SizedBox(height: 24),
          // Billing toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Monthly Billing', style: TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.bold)),
              Switch(
                value: _isYearly,
                onChanged: (val) {
                  setState(() {
                    _isYearly = val;
                  });
                },
                activeColor: const Color(0xFF38BDF8),
              ),
              const Text('Yearly Billing (Save 20%)', style: TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 40),
          // Pricing Grid
          LayoutBuilder(
            builder: (context, constraints) {
              return GridView.count(
                crossAxisCount: constraints.maxWidth > 1000 ? 4 : 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 0.65,
                children: _plans.map((plan) {
                  final price = _isYearly ? plan['priceYearly'] : plan['priceMonthly'];
                  final isCurrent = plan['name'] == 'FREE';
                  return Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: plan['isPopular'] ? plan['accent'] as Color : const Color(0xFF334155),
                        width: plan['isPopular'] ? 2.0 : 1.0,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (plan['isPopular']) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: (plan['accent'] as Color).withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'MOST POPULAR',
                              style: TextStyle(color: plan['accent'] as Color, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                        Text(
                          plan['name'] as String,
                          style: TextStyle(color: plan['accent'] as Color, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              price as String,
                              style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                            ),
                            if (price != 'Custom') ...[
                              const SizedBox(width: 4),
                              const Text('/mo', style: TextStyle(color: Color(0xFF64748B), fontSize: 14)),
                            ],
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          plan['desc'] as String,
                          style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                        ),
                        const Divider(color: Color(0xFF334155), height: 32),
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: (plan['features'] as List<String>).length,
                            itemBuilder: (context, index) {
                              final f = (plan['features'] as List<String>)[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 6.0),
                                child: Row(
                                  children: [
                                    const Icon(Icons.check, color: Color(0xFF10B981), size: 14),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        f,
                                        style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 13),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isCurrent ? const Color(0xFF334155) : plan['accent'] as Color,
                              foregroundColor: isCurrent ? const Color(0xFF94A3B8) : const Color(0xFF0F172A),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            onPressed: isCurrent
                                ? null
                                : () {
                                    context.push('/billing/success');
                                  },
                            child: Text(
                              plan['buttonText'] as String,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
