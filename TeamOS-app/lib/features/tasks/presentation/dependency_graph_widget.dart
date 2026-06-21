import 'package:flutter/material.dart';

class DependencyGraphWidget extends StatelessWidget {
  final List<Map<String, String>> dependencies;

  const DependencyGraphWidget({
    super.key,
    required this.dependencies,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Task Dependencies', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),
          
          if (dependencies.isEmpty)
            const Text('No dependencies mapped to this task.', style: TextStyle(color: Color(0xFF64748B)))
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: dependencies.length,
              separatorBuilder: (context, index) => const Divider(color: Color(0xFF334155)),
              itemBuilder: (context, index) {
                final dep = dependencies[index];
                final isBlocker = dep['type'] == 'BLOCKS' || dep['type'] == 'DEPENDS_ON';
                
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: isBlocker ? Colors.redAccent.withOpacity(0.2) : Colors.blueAccent.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            dep['type']!,
                            style: TextStyle(color: isBlocker ? Colors.redAccent : Colors.blueAccent, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(dep['taskKey']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Text(dep['status']!, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }
}
