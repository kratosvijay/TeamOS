import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AIArtifactsScreen extends StatelessWidget {
  const AIArtifactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final artifacts = [
      {'id': 'art-1', 'title': 'Sprint 15 Allocated Plan', 'type': 'SPRINT_PLAN', 'date': 'June 20, 2026'},
      {'id': 'art-2', 'title': 'Production Release Spec', 'type': 'TECH_SPEC', 'date': 'June 18, 2026'},
      {'id': 'art-3', 'title': 'CI/CD Failures Runbook', 'type': 'RUNBOOK', 'date': 'June 15, 2026'},
      {'id': 'art-4', 'title': 'Sprint 14 Retrospective Artifact', 'type': 'MEETING_SUMMARY', 'date': 'June 05, 2026'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('AI Artifact Library', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24.0),
        itemCount: artifacts.length,
        itemBuilder: (context, index) {
          final item = artifacts[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: InkWell(
              onTap: () => context.push('/ai/artifact-details/${item['id']}'),
              child: Row(
                children: [
                  const Icon(Icons.description_outlined, color: Color(0xFF6366F1), size: 32),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['title']!, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Text('Type: ${item['type']} | Generated: ${item['date']}',
                            style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFF94A3B8), size: 16)
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
