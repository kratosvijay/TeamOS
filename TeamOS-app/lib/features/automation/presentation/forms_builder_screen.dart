import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FormsBuilderScreen extends StatefulWidget {
  const FormsBuilderScreen({super.key});

  @override
  State<FormsBuilderScreen> createState() => _FormsBuilderScreenState();
}

class _FormsBuilderScreenState extends State<FormsBuilderScreen> {
  final List<FormFieldItem> _fields = [
    FormFieldItem(name: 'Full Name', type: 'TEXT', isRequired: true),
    FormFieldItem(name: 'Email Address', type: 'EMAIL', isRequired: true),
    FormFieldItem(name: 'Duration Days', type: 'NUMBER', isRequired: false),
  ];

  final _formNameController = TextEditingController(text: 'Leave Request Schema');
  final _fieldNameController = TextEditingController();
  String _selectedFieldType = 'TEXT';
  bool _fieldRequired = true;

  @override
  void dispose() {
    _formNameController.dispose();
    _fieldNameController.dispose();
    super.dispose();
  }

  void _addField() {
    final name = _fieldNameController.text;
    if (name.isNotEmpty) {
      setState(() {
        _fields.add(FormFieldItem(
          name: name,
          type: _selectedFieldType,
          isRequired: _fieldRequired,
        ));
        _fieldNameController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Field "$name" added to schema')),
      );
    }
  }

  void _saveFormSchema() {
    if (_formNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please name this form schema')),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Dynamic form schema saved successfully')),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Dynamic Form Builder', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        actions: [
          TextButton.icon(
            onPressed: _saveFormSchema,
            icon: const Icon(Icons.check, color: Color(0xFF10B981), size: 18),
            label: const Text('Save Form', style: TextStyle(color: Color(0xFF10B981))),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Row(
        children: [
          // Sidebar options
          Container(
            width: 280,
            decoration: const BoxDecoration(
              color: Color(0xFF1E293B),
              border: Border(right: BorderSide(color: Color(0xFF334155))),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('FIELD PROPERTIES', style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _fieldNameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Field Label',
                    labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
                    filled: true,
                    fillColor: const Color(0xFF0F172A),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedFieldType,
                  dropdownColor: const Color(0xFF1E293B),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Field Type',
                    labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
                    filled: true,
                    fillColor: const Color(0xFF0F172A),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'TEXT', child: Text('TEXT')),
                    DropdownMenuItem(value: 'NUMBER', child: Text('NUMBER')),
                    DropdownMenuItem(value: 'DATE', child: Text('DATE')),
                    DropdownMenuItem(value: 'EMAIL', child: Text('EMAIL')),
                    DropdownMenuItem(value: 'SELECT', child: Text('SELECT')),
                    DropdownMenuItem(value: 'FILE', child: Text('FILE')),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _selectedFieldType = val);
                    }
                  },
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Required', style: TextStyle(color: Colors.white, fontSize: 13)),
                  value: _fieldRequired,
                  activeColor: const Color(0xFF3B82F6),
                  onChanged: (v) => setState(() => _fieldRequired = v),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: _addField,
                  icon: const Icon(Icons.add_circle_outline, color: Colors.white, size: 16),
                  label: const Text('Add Field Item', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),

          // Main canvas preview
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Form Schema Preview', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),

                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _fields.length,
                    separatorBuilder: (context, idx) => const SizedBox(height: 16),
                    itemBuilder: (context, idx) {
                      final field = _fields[idx];
                      return Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF334155)),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            const Icon(Icons.drag_indicator, color: Color(0xFF64748B)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(field.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                                      if (field.isRequired)
                                        const Text(' *', style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text('Type: ${field.type}', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Color(0xFFEF4444), size: 18),
                              onPressed: () {
                                setState(() => _fields.removeAt(idx));
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FormFieldItem {
  final String name;
  final String type;
  final bool isRequired;

  FormFieldItem({required this.name, required this.type, required this.isRequired});
}
