import 'package:flutter/material.dart';

class WorkflowExecutionScreen extends StatelessWidget {
  const WorkflowExecutionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ExecutionStep> steps = [
      ExecutionStep(
        nodeId: 'trigger-1',
        name: 'Form Submitted Trigger',
        status: 'COMPLETED',
        message: 'Form submission received with payload: { days: 4, type: "Vacation" }',
        time: '2026-06-22 10:00:02',
      ),
      ExecutionStep(
        nodeId: 'rule-2',
        name: 'Evaluation Rule: Days > 3',
        status: 'COMPLETED',
        message: 'Condition evaluated to true (days=4)',
        time: '2026-06-22 10:00:03',
      ),
      ExecutionStep(
        nodeId: 'approval-3',
        name: 'HR Lead Approval Node',
        status: 'PENDING',
        message: 'Awaiting response from hr-lead. SLA escalates in 12 hours.',
        time: '2026-06-22 10:00:05',
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Workflow Execution Logs', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Header Card
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'RUN ID: ex-f389a-002d',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF59E0B).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFF59E0B)),
                        ),
                        child: const Text(
                          'RUNNING',
                          style: TextStyle(color: Color(0xFFF59E0B), fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Workflow: Leave Application & HR Approval',
                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                  ),
                  const Divider(color: Color(0xFF334155), height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMetaCol('Started At', '2026-06-22 10:00:02'),
                      _buildMetaCol('Trigger Source', 'Form Submission'),
                      _buildMetaCol('Duration', '2m 14s'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            const Text(
              'Step Execution Path',
              style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Step Timeline
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: steps.length,
              itemBuilder: (context, index) {
                final step = steps[index];
                final isLast = index == steps.length - 1;
                final statusColor = step.status == 'COMPLETED'
                    ? const Color(0xFF10B981)
                    : (step.status == 'PENDING' ? const Color(0xFFF59E0B) : const Color(0xFFEF4444));

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dot and line
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: statusColor.withOpacity(0.15),
                          child: Icon(
                            step.status == 'COMPLETED' ? Icons.check : Icons.hourglass_empty,
                            size: 14,
                            color: statusColor,
                          ),
                        ),
                        if (!isLast)
                          Container(
                            width: 2,
                            height: 60,
                            color: const Color(0xFF334155),
                          ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    // Card Details
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF334155)),
                        ),
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  step.name,
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                                Text(
                                  step.time,
                                  style: const TextStyle(color: Color(0xFF64748B), fontSize: 10),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              step.message,
                              style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetaCol(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
      ],
    );
  }
}

class ExecutionStep {
  final String nodeId;
  final String name;
  final String status;
  final String message;
  final String time;

  ExecutionStep({required this.nodeId, required this.name, required this.status, required this.message, required this.time});
}
