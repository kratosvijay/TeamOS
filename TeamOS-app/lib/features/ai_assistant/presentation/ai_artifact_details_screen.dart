import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class AIArtifactDetailsScreen extends HookWidget {
  final String artifactId;
  const AIArtifactDetailsScreen({super.key, required this.artifactId});

  @override
  Widget build(BuildContext context) {
    final status = useState<String>('PENDING');

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: Text('Artifact Review: $artifactId', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status bar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: status.value == 'PENDING'
                    ? Colors.orange.withOpacity(0.15)
                    : status.value == 'APPROVED'
                        ? Colors.green.withOpacity(0.15)
                        : Colors.red.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: status.value == 'PENDING'
                      ? Colors.orangeAccent
                      : status.value == 'APPROVED'
                          ? Colors.greenAccent
                          : Colors.redAccent,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Approval Status: ${status.value}',
                    style: TextStyle(
                      color: status.value == 'PENDING'
                          ? Colors.orangeAccent
                          : status.value == 'APPROVED'
                              ? Colors.greenAccent
                              : Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (status.value == 'PENDING')
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () => status.value = 'APPROVED',
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                          child: const Text('Approve', style: TextStyle(color: Colors.white)),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton(
                          onPressed: () => status.value = 'REJECTED',
                          style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.redAccent)),
                          child: const Text('Reject', style: TextStyle(color: Colors.redAccent)),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Content Viewer
            const Text('Generated Document Content', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: const Text(
                '# Sprint 15 Capacity Planning Specifications\n\n'
                '## Team Resource Allocation:\n'
                '- Engineering lead is assigned at 100% capacity.\n'
                '- QA resource is dedicated to sprint regression testing.\n\n'
                '## Velocity Target:\n'
                '- Recommended commitment: 26 Story Points.',
                style: TextStyle(color: Color(0xFFCBD5E1), fontSize: 14, height: 1.6),
              ),
            ),
            const SizedBox(height: 24),

            // Conversion Options
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Successfully converted artifact to wiki page.')),
                );
              },
              icon: const Icon(Icons.book_rounded, color: Colors.white),
              label: const Text('Convert To Wiki Document', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F46E5),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
