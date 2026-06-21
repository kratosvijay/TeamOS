import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class SprintRetrospectiveScreen extends HookWidget {
  final String sprintId;
  const SprintRetrospectiveScreen({super.key, required this.sprintId});

  @override
  Widget build(BuildContext context) {
    final wentWellController = useTextEditingController(text: 'Authentication strategies and database setup completed on schedule.');
    final improveController = useTextEditingController(text: 'FCM configurations took longer than anticipated. Need secret vaults mappings.');
    
    final actionItems = useState<List<Map<String, String>>>([
      {'text': 'Optimize FCM vault configuration', 'owner': 'John Doe'},
      {'text': 'Set up automated daily testing report summaries', 'owner': 'Sarah Jenkins'},
    ]);

    final newActionItemController = useTextEditingController();
    final selectedOwner = useState<String>('John Doe');

    void addActionItem() {
      if (newActionItemController.text.trim().isEmpty) return;
      actionItems.value = [
        ...actionItems.value,
        {
          'text': newActionItemController.text.trim(),
          'owner': selectedOwner.value,
        }
      ];
      newActionItemController.clear();
    }

    void removeActionItem(int index) {
      final updated = List<Map<String, String>>.from(actionItems.value);
      updated.removeAt(index);
      actionItems.value = updated;
    }

    void saveRetro() {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sprint Retrospective saved successfully!'), backgroundColor: Colors.green),
      );
      context.pop();
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Sprint Retrospective Wizard', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1E293B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // What went well
            const Text('What went well?', style: TextStyle(color: Colors.greenAccent, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: wentWellController,
              maxLines: 4,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF1E293B),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF334155))),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF334155))),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF3B82F6))),
              ),
            ),
            const SizedBox(height: 24),

            // What could be improved
            const Text('What could be improved?', style: TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: improveController,
              maxLines: 4,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF1E293B),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF334155))),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF334155))),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF3B82F6))),
              ),
            ),
            const SizedBox(height: 32),

            // Action items
            const Text('Action Items', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: actionItems.value.length,
                    separatorBuilder: (context, index) => const Divider(color: Color(0xFF334155), height: 20),
                    itemBuilder: (context, index) {
                      final item = actionItems.value[index];
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item['text']!, style: const TextStyle(color: Colors.white, fontSize: 14)),
                                const SizedBox(height: 4),
                                Text('Owner: ${item['owner']!}', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent, size: 20),
                            onPressed: () => removeActionItem(index),
                          )
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Color(0xFF334155)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: newActionItemController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'New action item...',
                            hintStyle: const TextStyle(color: Color(0xFF64748B)),
                            filled: true,
                            fillColor: const Color(0xFF0F172A),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      DropdownButton<String>(
                        dropdownColor: const Color(0xFF1E293B),
                        style: const TextStyle(color: Colors.white),
                        value: selectedOwner.value,
                        onChanged: (val) {
                          if (val != null) selectedOwner.value = val;
                        },
                        items: ['John Doe', 'Sarah Jenkins', 'Alex Martinez']
                            .map((o) => DropdownMenuItem(value: o, child: Text(o)))
                            .toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: addActionItem,
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F172A), side: const BorderSide(color: Color(0xFF334155))),
                    child: const Text('Add Action Item', style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
            ),
            const SizedBox(height: 36),
            ElevatedButton(
              onPressed: saveRetro,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3B82F6), padding: const EdgeInsets.symmetric(vertical: 16)),
              child: const Text('Save Retrospective', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}
