import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class CustomFieldsScreen extends HookWidget {
  const CustomFieldsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock existing custom fields
    final fields = useState<List<Map<String, dynamic>>>([
      {'id': '1', 'name': 'QA Sign-off', 'type': 'BOOLEAN', 'required': true, 'defaultValue': 'false'},
      {'id': '2', 'name': 'Target Release Version', 'type': 'SELECT', 'required': false, 'defaultValue': 'v1.0.0'},
      {'id': '3', 'name': 'Security Risk Level', 'type': 'SELECT', 'required': true, 'defaultValue': 'Medium'},
      {'id': '4', 'name': 'External Customer Link', 'type': 'URL', 'required': false, 'defaultValue': ''},
      {'id': '5', 'name': 'Deployment Date', 'type': 'DATE', 'required': false, 'defaultValue': ''},
    ]);

    final fieldNameController = useTextEditingController();
    final selectedType = useState<String>('TEXT');
    final isRequired = useState<bool>(false);
    final defaultValueController = useTextEditingController();

    void addField() {
      if (fieldNameController.text.trim().isEmpty) return;
      fields.value = [
        ...fields.value,
        {
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'name': fieldNameController.text.trim(),
          'type': selectedType.value,
          'required': isRequired.value,
          'defaultValue': defaultValueController.text.trim(),
        }
      ];
      fieldNameController.clear();
      defaultValueController.clear();
      isRequired.value = false;
      selectedType.value = 'TEXT';
      Navigator.of(context).pop();
    }

    void deleteField(String id) {
      fields.value = fields.value.where((f) => f['id'] != id).toList();
    }

    void showAddFieldDialog() {
      showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                backgroundColor: const Color(0xFF1E293B),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: Color(0xFF334155))),
                title: const Text('Add Custom Field', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: fieldNameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Field Name',
                          labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
                          filled: true,
                          fillColor: const Color(0xFF0F172A),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: selectedType.value,
                        dropdownColor: const Color(0xFF1E293B),
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Field Type',
                          labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
                          filled: true,
                          fillColor: const Color(0xFF0F172A),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        ),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              selectedType.value = val;
                            });
                          }
                        },
                        items: ['TEXT', 'NUMBER', 'DATE', 'BOOLEAN', 'SELECT', 'MULTI_SELECT', 'USER', 'URL']
                            .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                            .toList(),
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: const Text('Required Field', style: TextStyle(color: Colors.white)),
                        value: isRequired.value,
                        activeColor: const Color(0xFF3B82F6),
                        onChanged: (val) {
                          setState(() {
                            isRequired.value = val;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: defaultValueController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Default Value (Optional)',
                          labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
                          filled: true,
                          fillColor: const Color(0xFF0F172A),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel', style: TextStyle(color: Color(0xFF94A3B8))),
                  ),
                  ElevatedButton(
                    onPressed: addField,
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3B82F6)),
                    child: const Text('Create', style: TextStyle(color: Colors.white)),
                  ),
                ],
              );
            },
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Workspace Custom Fields', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1E293B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: showAddFieldDialog,
        backgroundColor: const Color(0xFF3B82F6),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Field', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(24),
        itemCount: fields.value.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final f = fields.value[index];
          final name = f['name'] as String;
          final type = f['type'] as String;
          final required = f['required'] as bool;
          final defVal = f['defaultValue'] as String;

          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(name, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        if (required) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: Colors.redAccent.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                            child: const Text('REQUIRED', style: TextStyle(color: Colors.redAccent, fontSize: 9, fontWeight: FontWeight.bold)),
                          ),
                        ]
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: const Color(0xFF334155), borderRadius: BorderRadius.circular(6)),
                          child: Text(type, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.bold)),
                        ),
                        if (defVal.isNotEmpty) ...[
                          const SizedBox(width: 12),
                          Text('Default: "$defVal"', style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
                        ]
                      ],
                    )
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                  onPressed: () => deleteField(f['id'] as String),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
