import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AIEvaluationsScreen extends StatelessWidget {
  const AIEvaluationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final evaluations = [
      {'model': 'Claude 3.5 Sonnet', 'accuracy': '96%', 'citation': '98%', 'helpfulness': '95%', 'latency': '1.2s'},
      {'model': 'GPT-4o', 'accuracy': '94%', 'citation': '92%', 'helpfulness': '93%', 'latency': '0.9s'},
      {'model': 'Gemini 1.5 Pro', 'accuracy': '91%', 'citation': '90%', 'helpfulness': '90%', 'latency': '0.6s'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('AI Evaluations Console', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
            const Text('Model Benchmark Comparison', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: evaluations.length,
              itemBuilder: (context, index) {
                final item = evaluations[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['model']!, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildMetricCol('Accuracy', item['accuracy']!),
                          _buildMetricCol('Citation', item['citation']!),
                          _buildMetricCol('Helpful', item['helpfulness']!),
                          _buildMetricCol('Latency', item['latency']!),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCol(String title, String val) {
    return Column(
      children: [
        Text(title, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
        const SizedBox(height: 4),
        Text(val, style: const TextStyle(color: Colors.greenAccent, fontSize: 13, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
