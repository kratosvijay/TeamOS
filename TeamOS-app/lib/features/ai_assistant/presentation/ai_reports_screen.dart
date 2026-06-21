import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AIReportsScreen extends StatelessWidget {
  const AIReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reports = [
      {'id': 'rep-1', 'title': 'Weekly Executive Health Summary', 'type': 'WEEKLY', 'date': 'June 19, 2026', 'size': '182 KB'},
      {'id': 'rep-2', 'title': 'Sprint 15 Velocity Trend Analytics', 'type': 'SPRINT', 'date': 'June 12, 2026', 'size': '210 KB'},
      {'id': 'rep-3', 'title': 'Monthly Team Efficiency Report', 'type': 'MONTHLY', 'date': 'May 31, 2026', 'size': '345 KB'},
    ];

    void triggerNewReport() {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('AI Status Report compilation queued...'),
          backgroundColor: Colors.indigo,
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('AI Executive Reports', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded, color: Colors.indigoAccent),
            onPressed: triggerNewReport,
          )
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24.0),
        itemCount: reports.length,
        itemBuilder: (context, index) {
          final item = reports[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Row(
              children: [
                const Icon(Icons.picture_as_pdf_rounded, color: Colors.redAccent, size: 36),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['title']!, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text('Compiled: ${item['date']} | Size: ${item['size']}', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.download_rounded, color: Colors.indigoAccent),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Downloading ${item['title']}...')),
                    );
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
