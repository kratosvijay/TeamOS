import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class AIBudgetScreen extends HookWidget {
  const AIBudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final limit = useState<double>(100.0);
    final warning = useState<double>(80.0);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('AI Budget Governance', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
            const Text('AI Cost Controls', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Enforce limits to prevent unexpected provider usage bills.',
                style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
            const SizedBox(height: 32),

            // Limit Slider
            Text('Monthly Budget Limit: \$${limit.value.round()}',
                style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Slider(
              value: limit.value,
              min: 10.0,
              max: 500.0,
              divisions: 49,
              activeColor: const Color(0xFF6366F1),
              inactiveColor: const Color(0xFF334155),
              onChanged: (val) {
                limit.value = val;
                if (warning.value > val) {
                  warning.value = val;
                }
              },
            ),
            const SizedBox(height: 32),

            // Warning Threshold Slider
            Text('Warning Notification Threshold: \$${warning.value.round()}',
                style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Slider(
              value: warning.value,
              min: 5.0,
              max: limit.value,
              divisions: 100,
              activeColor: Colors.amberAccent,
              inactiveColor: const Color(0xFF334155),
              onChanged: (val) {
                warning.value = val;
              },
            ),
            const SizedBox(height: 48),

            // Save Button
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('AI Cost Governance budgets updated successfully.'), backgroundColor: Colors.green),
                );
                context.pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F46E5),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Save Budget Rules', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
