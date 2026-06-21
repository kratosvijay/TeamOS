import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class TaskTemplateScreen extends HookWidget {
  const TaskTemplateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock template list
    final templates = useState<List<Map<String, dynamic>>>([
      {
        'id': '1',
        'name': 'Bug Report Template',
        'description': 'Standard template for registering system bugs and crashes.',
        'details': {'type': 'BUG', 'priority': 'HIGH', 'storyPoints': 2, 'title': '[BUG] - Crashes on loading'}
      },
      {
        'id': '2',
        'name': 'Feature Implementation Story',
        'description': 'Agile story structure template for engineering new components.',
        'details': {'type': 'STORY', 'priority': 'MEDIUM', 'storyPoints': 5, 'title': 'Implement feature module'}
      },
      {
        'id': '3',
        'name': 'Hotfix Deployment',
        'description': 'Critical priority deployment checklists.',
        'details': {'type': 'TASK', 'priority': 'CRITICAL', 'storyPoints': 1, 'title': 'Apply hotfix patch'}
      },
    ]);

    final templateNameController = useTextEditingController();
    final templateDescController = useTextEditingController();
    final taskTitleController = useTextEditingController();
    final selectedType = useState<String>('TASK');
    final selectedPriority = useState<String>('MEDIUM');
    final storyPointsController = useTextEditingController();

    void createTemplate() {
      if (templateNameController.text.trim().isEmpty) return;
      templates.value = [
        ...templates.value,
        {
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'name': templateNameController.text.trim(),
          'description': templateDescController.text.trim(),
          'details': {
            'type': selectedType.value,
            'priority': selectedPriority.value,
            'storyPoints': int.tryParse(storyPointsController.text) ?? 1,
            'title': taskTitleController.text.trim(),
          }
        }
      ];
      templateNameController.clear();
      templateDescController.clear();
      taskTitleController.clear();
      storyPointsController.clear();
      selectedType.value = 'TASK';
      selectedPriority.value = 'MEDIUM';
      Navigator.of(context).pop();
    }

    void instantiateTask(Map<String, dynamic> template) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Task "${template['details']['title']}" successfully instantiated!'),
          backgroundColor: Colors.green,
        ),
      );
    }

    void showCreateTemplateDialog() {
      showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                backgroundColor: const Color(0xFF1E293B),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: Color(0xFF334155))),
                title: const Text('New Task Template', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: templateNameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Template Name',
                          labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
                          filled: true,
                          fillColor: const Color(0xFF0F172A),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: templateDescController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Description',
                          labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
                          filled: true,
                          fillColor: const Color(0xFF0F172A),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text('Default Task Parameters', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      TextField(
                        controller: taskTitleController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Default Task Title',
                          labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
                          filled: true,
                          fillColor: const Color(0xFF0F172A),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        ),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: selectedType.value,
                        dropdownColor: const Color(0xFF1E293B),
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Task Type',
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
                        items: ['EPIC', 'STORY', 'TASK', 'BUG', 'SUBTASK']
                            .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                            .toList(),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: selectedPriority.value,
                        dropdownColor: const Color(0xFF1E293B),
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Priority',
                          labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
                          filled: true,
                          fillColor: const Color(0xFF0F172A),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        ),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              selectedPriority.value = val;
                            });
                          }
                        },
                        items: ['LOW', 'MEDIUM', 'HIGH', 'CRITICAL']
                            .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                            .toList(),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: storyPointsController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Story Points',
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
                    onPressed: createTemplate,
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
        title: const Text('Task Templates Library', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1E293B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: showCreateTemplateDialog,
        backgroundColor: const Color(0xFF3B82F6),
        icon: const Icon(Icons.add_circle_outline_rounded, color: Colors.white),
        label: const Text('Create Template', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(24),
        itemCount: templates.value.length,
        separatorBuilder: (context, index) => const SizedBox(height: 20),
        itemBuilder: (context, index) {
          final tpl = templates.value[index];
          final details = tpl['details'] as Map<String, dynamic>;

          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(tpl['name'] as String, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFF3B82F6).withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
                      child: Text(details['type'] as String, style: const TextStyle(color: Color(0xFF3B82F6), fontSize: 11, fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                Text(tpl['description'] as String, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14)),
                const SizedBox(height: 16),
                const Divider(color: Color(0xFF334155)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.priority_high_rounded, size: 16, color: Color(0xFF64748B)),
                        const SizedBox(width: 4),
                        Text('Priority: ${details['priority']}', style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
                        const SizedBox(width: 16),
                        const Icon(Icons.star_outline_rounded, size: 16, color: Color(0xFF64748B)),
                        const SizedBox(width: 4),
                        Text('SP: ${details['storyPoints']}', style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: () => instantiateTask(tpl),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F172A),
                        side: const BorderSide(color: Color(0xFF334155)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      icon: const Icon(Icons.flash_on_rounded, color: Colors.greenAccent, size: 16),
                      label: const Text('Use Template', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                    )
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
