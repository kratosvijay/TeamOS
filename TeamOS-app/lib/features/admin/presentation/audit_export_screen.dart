import 'package:flutter/material.dart';

class AuditExportScreen extends StatefulWidget {
  const AuditExportScreen({super.key});

  @override
  State<AuditExportScreen> createState() => _AuditExportScreenState();
}

class _AuditExportScreenState extends State<AuditExportScreen> {
  String _exportFormat = 'CSV';
  final List<String> _selectedSources = ['Authentication', 'Tasks', 'Projects'];
  final List<String> _allSources = [
    'Authentication',
    'Tasks',
    'Projects',
    'Meetings',
    'Documents',
    'AI',
    'Billing',
    'Integrations',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Audit Export Center', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Export Audit Trails',
              style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Package and download detailed compliance audit logs for internal reviews or SOC2 verification.',
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
            ),
            const SizedBox(height: 24),

            // Form
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
                  DropdownButtonFormField<String>(
                    value: _exportFormat,
                    style: const TextStyle(color: Colors.white),
                    dropdownColor: const Color(0xFF1E293B),
                    decoration: InputDecoration(
                      labelText: 'Log Package Format',
                      labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
                      filled: true,
                      fillColor: const Color(0xFF0F172A),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    items: ['CSV', 'PDF', 'JSON']
                        .map((fmt) => DropdownMenuItem(value: fmt, child: Text(fmt)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _exportFormat = val;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Select Audit Log Sources',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _allSources.map((source) {
                      final isSelected = _selectedSources.contains(source);
                      return FilterChip(
                        label: Text(source, style: TextStyle(color: isSelected ? Colors.white : const Color(0xFF94A3B8))),
                        selected: isSelected,
                        selectedColor: const Color(0xFF3B82F6),
                        checkmarkColor: Colors.white,
                        backgroundColor: const Color(0xFF0F172A),
                        onSelected: (val) {
                          setState(() {
                            if (val) {
                              _selectedSources.add(source);
                            } else {
                              _selectedSources.remove(source);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Audit log packaged in $_exportFormat format. Download started.')),
                      );
                    },
                    icon: const Icon(Icons.download, color: Colors.white),
                    label: const Text('Compile & Export Logs', style: TextStyle(color: Colors.white)),
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
