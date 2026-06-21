import 'package:flutter/material.dart';

class ComplianceCenterScreen extends StatefulWidget {
  const ComplianceCenterScreen({super.key});

  @override
  State<ComplianceCenterScreen> createState() => _ComplianceCenterScreenState();
}

class _ComplianceCenterScreenState extends State<ComplianceCenterScreen> {
  String _selectedStandard = 'SOC2';

  @override
  Widget build(BuildContext context) {
    // Mock checklist mapping based on standard
    final checklist = _getChecklistFor(_selectedStandard);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Compliance Center', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Regulatory Compliance Standards',
              style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Audit your workspace configuration against industry security frameworks.',
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
            ),
            const SizedBox(height: 24),

            // Tabs/Selector
            Row(
              children: ['SOC2', 'ISO27001', 'GDPR', 'HIPAA'].map((std) {
                final isSelected = _selectedStandard == std;
                return Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: ChoiceChip(
                    label: Text(std, style: TextStyle(color: isSelected ? Colors.white : const Color(0xFF94A3B8))),
                    selected: isSelected,
                    selectedColor: const Color(0xFF3B82F6),
                    backgroundColor: const Color(0xFF1E293B),
                    onSelected: (val) {
                      if (val) {
                        setState(() {
                          _selectedStandard = std;
                        });
                      }
                    },
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Score Card
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$_selectedStandard Readiness Score',
                        style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Your configurations satisfy 88% of core constraints',
                        style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                      ),
                    ],
                  ),
                  const CircleAvatar(
                    radius: 36,
                    backgroundColor: Color(0xFF10B981),
                    child: Text(
                      '88%',
                      style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Checklist
            const Text(
              'Audit Checklist Items',
              style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: checklist.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = checklist[index];
                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: Icon(
                      item.passed ? Icons.check_circle : Icons.cancel,
                      color: item.passed ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                    ),
                    title: Text(item.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: Text(item.description, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  List<ChecklistItem> _getChecklistFor(String standard) {
    if (standard == 'SOC2') {
      return [
        ChecklistItem(title: 'MFA Enforcement', description: 'Require Multi-Factor Authentication globally for all accounts.', passed: true),
        ChecklistItem(title: 'Access Auditing', description: 'Cryptographic immutable chaining enabled on workspace audits.', passed: true),
        ChecklistItem(title: 'IP Allowlist Configured', description: 'Secure access policies configured with IP allowlists.', passed: false),
        ChecklistItem(title: 'System Firewalls Active', description: 'External endpoints are secured under security proxies.', passed: true),
      ];
    } else if (standard == 'ISO27001') {
      return [
        ChecklistItem(title: 'Data Classification Rules', description: 'DLP patterns established for API keys and secrets.', passed: true),
        ChecklistItem(title: 'Cryptographic Hash Chains', description: 'Log chain verification enabled and untampered.', passed: true),
        ChecklistItem(title: 'Legal Hold Retention', description: 'Ensure legal hold override works correctly.', passed: true),
        ChecklistItem(title: 'Device Registry Audits', description: 'Unregistered user devices blocked automatically.', passed: false),
      ];
    } else if (standard == 'GDPR') {
      return [
        ChecklistItem(title: 'Data Deletion Rules', description: 'Configured data retention schedules for meetings and messages.', passed: true),
        ChecklistItem(title: 'Data Portability Exports', description: 'Users can download full account records in JSON format.', passed: true),
        ChecklistItem(title: 'MFA on Sensitive Routes', description: 'Require MFA to configure administrative routes.', passed: true),
      ];
    } else {
      return [
        ChecklistItem(title: 'DLP Scans Active', description: 'Automatically quarantine SSN and patient billing details.', passed: true),
        ChecklistItem(title: 'Audited File Access', description: 'Detailed file read/write audit trails registered.', passed: true),
        ChecklistItem(title: 'VPN Routing Enforcement', description: 'Restrict access to compliance centers to VPN routes.', passed: false),
      ];
    }
  }
}

class ChecklistItem {
  final String title;
  final String description;
  final bool passed;

  ChecklistItem({required this.title, required this.description, required this.passed});
}
