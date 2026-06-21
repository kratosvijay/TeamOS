import 'package:flutter/material.dart';

class CustomDashboardScreen extends StatefulWidget {
  const CustomDashboardScreen({super.key});

  @override
  State<CustomDashboardScreen> createState() => _CustomDashboardScreenState();
}

class _CustomDashboardScreenState extends State<CustomDashboardScreen> {
  final List<SavedDashboard> _savedDashboards = [
    SavedDashboard(id: '1', name: 'Security & Compliance Monitor', template: 'Security Posture', widgetsCount: 6),
    SavedDashboard(id: '2', name: 'Engineering Velocity Hub', template: 'Agile Delivery', widgetsCount: 4),
  ];

  final List<String> _widgets = ['Sprint Velocity', 'Compliance Score', 'Security Audit', 'Active Task Count', 'Burnout Warning', 'AI Tokens Limit'];
  final List<String> _activeWidgets = ['Sprint Velocity', 'Compliance Score'];

  final _nameController = TextEditingController();
  String _selectedTemplate = 'Agile Delivery';

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveDashboard() {
    if (_nameController.text.isNotEmpty) {
      setState(() {
        _savedDashboards.add(SavedDashboard(
          id: (_savedDashboards.length + 1).toString(),
          name: _nameController.text,
          template: _selectedTemplate,
          widgetsCount: _activeWidgets.length,
        ));
        _nameController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Custom Dashboard configuration saved')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Custom Dashboards', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dashboard Layout Builder',
              style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Construct personalized dashboards using layout builders, widget registries, and template guides.',
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
            ),
            const SizedBox(height: 24),

            // Saved Dashboards list
            const Text('Saved Configurations', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _savedDashboards.length,
              separatorBuilder: (context, idx) => const SizedBox(height: 12),
              itemBuilder: (context, idx) {
                final dash = _savedDashboards[idx];
                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    title: Text(dash.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: Text('Template: ${dash.template} • ${dash.widgetsCount} widgets active', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Color(0xFFEF4444)),
                      onPressed: () {
                        setState(() {
                          _savedDashboards.removeAt(idx);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Dashboard configuration deleted')),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),

            // Design panel
            const Text('Interactive Layout Editor', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Select Widgets to display:', style: TextStyle(color: Colors.white, fontSize: 13)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _widgets.map((widgetName) {
                      final isActive = _activeWidgets.contains(widgetName);
                      return ChoiceChip(
                        label: Text(widgetName),
                        selected: isActive,
                        selectedColor: const Color(0xFF3B82F6),
                        disabledColor: const Color(0xFF0F172A),
                        backgroundColor: const Color(0xFF0F172A),
                        labelStyle: TextStyle(color: isActive ? Colors.white : const Color(0xFF94A3B8), fontSize: 12),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _activeWidgets.add(widgetName);
                            } else {
                              _activeWidgets.remove(widgetName);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const Divider(color: Color(0xFF334155), height: 32),
                  TextFormField(
                    controller: _nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Dashboard Name',
                      labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
                      filled: true,
                      fillColor: const Color(0xFF0F172A),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedTemplate,
                    style: const TextStyle(color: Colors.white),
                    dropdownColor: const Color(0xFF1E293B),
                    decoration: InputDecoration(
                      labelText: 'Template Framework',
                      labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
                      filled: true,
                      fillColor: const Color(0xFF0F172A),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Agile Delivery', child: Text('Agile Delivery')),
                      DropdownMenuItem(value: 'Security Posture', child: Text('Security Posture')),
                      DropdownMenuItem(value: 'Financial Overview', child: Text('Financial Overview')),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedTemplate = val;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _saveDashboard,
                    child: const Text('Save Custom Layout', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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

class SavedDashboard {
  final String id;
  final String name;
  final String template;
  final int widgetsCount;

  SavedDashboard({required this.id, required this.name, required this.template, required this.widgetsCount});
}
