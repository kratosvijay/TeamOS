import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OKRDashboardScreen extends StatefulWidget {
  const OKRDashboardScreen({super.key});

  @override
  State<OKRDashboardScreen> createState() => _OKRDashboardScreenState();
}

class _OKRDashboardScreenState extends State<OKRDashboardScreen> {
  final List<ObjectiveData> _objectives = [
    ObjectiveData(id: '1', title: 'Achieve SOC2 Compliance Readiness', progress: 85, krs: 3),
    ObjectiveData(id: '2', title: 'Expand Enterprise Integrations Portfolio', progress: 42, krs: 4),
    ObjectiveData(id: '3', title: 'Optimize Team Resource Allocations', progress: 10, krs: 2),
  ];

  final _titleController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Objectives & Key Results', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'OKR Center',
              style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Align company vision with department and engineering workspace objectives.',
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
            ),
            const SizedBox(height: 24),

            // Objectives List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _objectives.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final obj = _objectives[index];
                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    title: Text(obj.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${obj.krs} Key Results', style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
                            Text('${obj.progress}% Complete', style: const TextStyle(color: Color(0xFF3B82F6), fontWeight: FontWeight.bold, fontSize: 11)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        LinearProgressIndicator(
                          value: obj.progress / 100,
                          backgroundColor: const Color(0xFF0F172A),
                          color: const Color(0xFF3B82F6),
                          minHeight: 4,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.chevron_right, color: Color(0xFF64748B)),
                    onTap: () => context.push('/okr/objectives/${obj.id}'),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),

            // Create Objective Form
            const Text(
              'Create Objective',
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
                    controller: _titleController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Objective Title',
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
                      if (_titleController.text.isNotEmpty) {
                        setState(() {
                          _objectives.add(ObjectiveData(
                            id: (_objectives.length + 1).toString(),
                            title: _titleController.text,
                            progress: 0,
                            krs: 0,
                          ));
                          _titleController.clear();
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Objective created successfully')),
                        );
                      }
                    },
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text('Add Objective', style: TextStyle(color: Colors.white)),
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

class ObjectiveData {
  final String id;
  final String title;
  final int progress;
  final int krs;

  ObjectiveData({required this.id, required this.title, required this.progress, required this.krs});
}
