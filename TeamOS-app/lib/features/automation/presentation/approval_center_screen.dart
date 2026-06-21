import 'package:flutter/material.dart';

class ApprovalCenterScreen extends StatefulWidget {
  const ApprovalCenterScreen({super.key});

  @override
  State<ApprovalCenterScreen> createState() => _ApprovalCenterScreenState();
}

class _ApprovalCenterScreenState extends State<ApprovalCenterScreen> {
  final List<ApprovalItem> _approvals = [
    ApprovalItem(id: 'app-101', title: 'Procurement: MacBook Pro', requester: 'Sarah Connor', amount: '\$2,500', comments: 'Hardware lifecycle upgrade request.'),
    ApprovalItem(id: 'app-102', title: 'Leave Application (5 Days)', requester: 'John Doe', amount: 'Annual Leave', comments: 'Planning family vacation trip.'),
  ];

  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _handleApprove(int index) {
    final item = _approvals[index];
    setState(() {
      _approvals.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Approved "${item.title}" successfully')),
    );
  }

  void _handleReject(int index) {
    final item = _approvals[index];
    setState(() {
      _approvals.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Rejected "${item.title}"')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Approval Inbox', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pending Authorization Queue',
              style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Authorise procurement thresholds, leave days limits, and software releases workflows.',
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
            ),
            const SizedBox(height: 24),

            if (_approvals.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 48.0),
                  child: Text('All caught up! No pending approvals.', style: TextStyle(color: Color(0xFF64748B), fontSize: 14)),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _approvals.length,
                separatorBuilder: (context, idx) => const SizedBox(height: 16),
                itemBuilder: (context, idx) {
                  final req = _approvals[idx];
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
                            Text(req.title, style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                            Text(
                              req.amount,
                              style: const TextStyle(color: Color(0xFF3B82F6), fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text('Requested by: ${req.requester}', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                        const SizedBox(height: 12),
                        Text(req.comments, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                        const Divider(color: Color(0xFF334155), height: 32),

                        // Action inputs
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _commentController,
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                                decoration: InputDecoration(
                                  hintText: 'Add response comments...',
                                  hintStyle: const TextStyle(color: Color(0xFF64748B)),
                                  filled: true,
                                  fillColor: const Color(0xFF0F172A),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            IconButton(
                              icon: const Icon(Icons.close, color: Color(0xFFEF4444)),
                              onPressed: () => _handleReject(idx),
                            ),
                            IconButton(
                              icon: const Icon(Icons.check, color: Color(0xFF10B981)),
                              onPressed: () => _handleApprove(idx),
                            ),
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
}

class ApprovalItem {
  final String id;
  final String title;
  final String requester;
  final String amount;
  final String comments;

  ApprovalItem({required this.id, required this.title, required this.requester, required this.amount, required this.comments});
}
