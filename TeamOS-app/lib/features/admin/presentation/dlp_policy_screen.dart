import 'package:flutter/material.dart';

class DlpPolicyScreen extends StatefulWidget {
  const DlpPolicyScreen({super.key});

  @override
  State<DlpPolicyScreen> createState() => _DlpPolicyScreenState();
}

class _DlpPolicyScreenState extends State<DlpPolicyScreen> {
  final List<DlpRuleData> _rules = [
    DlpRuleData(name: 'Credit Cards', pattern: '\\b\\d{4}[- ]?\\d{4}[- ]?\\d{4}[- ]?\\d{4}\\b', action: 'Block'),
    DlpRuleData(name: 'SSN', pattern: '\\b\\d{3}-\\d{2}-\\d{4}\\b', action: 'Quarantine'),
    DlpRuleData(name: 'API Keys', pattern: '(api[-_]?key|secret|token).*[a-zA-Z0-9]{32}', action: 'Warn'),
    DlpRuleData(name: 'Private Keys', pattern: '-----BEGIN PRIVATE KEY-----', action: 'Block'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Data Loss Prevention (DLP)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'DLP Scanning Policies',
              style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Scan messages and documents to detect leakage of credentials or sensitive data.',
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
            ),
            const SizedBox(height: 24),

            // Rules List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _rules.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final rule = _rules[index];
                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(rule.name, style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                          DropdownButton<String>(
                            value: rule.action,
                            style: const TextStyle(color: Colors.white),
                            dropdownColor: const Color(0xFF1E293B),
                            underline: Container(),
                            items: ['Warn', 'Block', 'Quarantine'].map((act) {
                              return DropdownMenuItem(
                                value: act,
                                child: Text(
                                  act,
                                  style: TextStyle(
                                    color: act == 'Block' ? const Color(0xFFEF4444) : (act == 'Quarantine' ? const Color(0xFFF59E0B) : const Color(0xFF3B82F6)),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  rule.action = val;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text('Regex Pattern Matcher', style: TextStyle(color: Color(0xFF64748B), fontSize: 11)),
                      const SizedBox(height: 4),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F172A),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF334155)),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Text(
                          rule.pattern,
                          style: const TextStyle(fontFamily: 'monospace', color: Color(0xFF06B6D4), fontSize: 13),
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

class DlpRuleData {
  final String name;
  final String pattern;
  String action;

  DlpRuleData({required this.name, required this.pattern, required this.action});
}
