import 'package:flutter/material.dart';

class FormsSubmissionScreen extends StatefulWidget {
  const FormsSubmissionScreen({super.key});

  @override
  State<FormsSubmissionScreen> createState() => _FormsSubmissionScreenState();
}

class _FormsSubmissionScreenState extends State<FormsSubmissionScreen> {
  final List<FormSubmissionData> _submissions = [
    FormSubmissionData(
      id: 'sub-101',
      formName: 'Procurement Request',
      submittedBy: 'Sarah Connor',
      payload: '{"item": "MacBook Pro", "budget": 2500, "dept": "Engineering"}',
      status: 'APPROVED',
      comments: 'Hardware budget approved for Staff deployment.',
      time: '2026-06-21 14:32',
    ),
    FormSubmissionData(
      id: 'sub-102',
      formName: 'Leave Application',
      submittedBy: 'John Doe',
      payload: '{"days": 5, "type": "Annual Leave", "start": "2026-07-10"}',
      status: 'PENDING',
      comments: 'Awaiting HR Director validation signoff.',
      time: '2026-06-22 09:15',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Submissions Register', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dynamic Form Submissions',
              style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Review low-code form requests, trace approval chains, and auditable comment trails.',
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
            ),
            const SizedBox(height: 24),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _submissions.length,
              separatorBuilder: (context, idx) => const SizedBox(height: 16),
              itemBuilder: (context, idx) {
                final sub = _submissions[idx];
                final statusColor = sub.status == 'APPROVED'
                    ? const Color(0xFF10B981)
                    : (sub.status == 'PENDING' ? const Color(0xFFF59E0B) : const Color(0xFFEF4444));

                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(sub.formName, style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 2),
                              Text('Submitted by: ${sub.submittedBy} • ${sub.time}', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              sub.status,
                              style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F172A),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          sub.payload,
                          style: const TextStyle(color: Color(0xFF10B981), fontSize: 11, fontFamily: 'monospace'),
                        ),
                      ),
                      if (sub.comments != null) ...[
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Icon(Icons.comment_outlined, color: Color(0xFF64748B), size: 14),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                sub.comments!,
                                style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontStyle: FontStyle.italic),
                              ),
                            ),
                          ],
                        ),
                      ],
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
}

class FormSubmissionData {
  final String id;
  final String formName;
  final String submittedBy;
  final String payload;
  final String status;
  final String? comments;
  final String time;

  FormSubmissionData({
    required this.id,
    required this.formName,
    required this.submittedBy,
    required this.payload,
    required this.status,
    this.comments,
    required this.time,
  });
}
