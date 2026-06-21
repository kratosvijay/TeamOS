import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class WorklogWidget extends HookWidget {
  final double estimated;
  final double logged;

  const WorklogWidget({
    super.key,
    required this.estimated,
    required this.logged,
  });

  @override
  Widget build(BuildContext context) {
    final hoursController = useTextEditingController();
    final noteController = useTextEditingController();
    final remaining = estimated - logged;

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
          const Text('Work Log telemetry', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),
          
          // Hours progress indicator bar
          LinearProgressIndicator(
            value: estimated > 0 ? (logged / estimated) : 0,
            backgroundColor: const Color(0xFF0F172A),
            color: const Color(0xFF3B82F6),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Estimated: ${estimated}h', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
              Text('Logged: ${logged}h', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
              Text('Remaining: ${remaining}h', style: TextStyle(color: remaining < 0 ? Colors.redAccent : const Color(0xFF94A3B8), fontSize: 12)),
            ],
          ),
          const SizedBox(height: 20),
          
          // Log new work fields
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: hoursController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Log Hours',
                    labelStyle: const TextStyle(color: Color(0xFF64748B)),
                    filled: true,
                    fillColor: const Color(0xFF0F172A),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {
                  // Post logged hours API trigger
                  hoursController.clear();
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3B82F6)),
                child: const Text('Add Log', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
