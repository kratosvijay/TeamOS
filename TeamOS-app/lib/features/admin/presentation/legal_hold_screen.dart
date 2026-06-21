import 'package:flutter/material.dart';

class LegalHoldScreen extends StatefulWidget {
  const LegalHoldScreen({super.key});

  @override
  State<LegalHoldScreen> createState() => _LegalHoldScreenState();
}

class _LegalHoldScreenState extends State<LegalHoldScreen> {
  final List<LegalHoldData> _holds = [
    LegalHoldData(name: 'Q3 Financial Audit Compliance Hold', reason: 'DOJ document review regarding transaction reports.', active: true),
    LegalHoldData(name: 'HR Internal Investigation Hold', reason: 'Preserve employee DM chat history for active inquiry.', active: false),
  ];

  final _nameController = TextEditingController();
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Legal Hold Registry', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Active Legal Holds',
              style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Legal holds override workspace retention policies to prevent deletion of critical evidence.',
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
            ),
            const SizedBox(height: 24),

            // Active Holds List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _holds.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final hold = _holds[index];
                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    title: Text(hold.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 6),
                        Text(hold.reason, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                      ],
                    ),
                    trailing: Switch(
                      value: hold.active,
                      activeColor: const Color(0xFF3B82F6),
                      inactiveTrackColor: const Color(0xFF334155),
                      onChanged: (val) {
                        setState(() {
                          hold.active = val;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Legal hold status updated')),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),

            // Add Hold Panel
            const Text(
              'Add Legal Hold',
              style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Legal Hold Name',
                      labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
                      filled: true,
                      fillColor: const Color(0xFF0F172A),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _reasonController,
                    maxLines: 2,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Legal Reason / Scope',
                      labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
                      filled: true,
                      fillColor: const Color(0xFF0F172A),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      if (_nameController.text.isNotEmpty) {
                        setState(() {
                          _holds.add(LegalHoldData(
                            name: _nameController.text,
                            reason: _reasonController.text,
                            active: true,
                          ));
                          _nameController.clear();
                          _reasonController.clear();
                        });
                      }
                    },
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text('Initialize Legal Hold', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LegalHoldData {
  final String name;
  final String reason;
  bool active;

  LegalHoldData({required this.name, required this.reason, required this.active});
}
