import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InvoiceHistoryScreen extends StatefulWidget {
  const InvoiceHistoryScreen({super.key});

  @override
  State<InvoiceHistoryScreen> createState() => _InvoiceHistoryScreenState();
}

class _InvoiceHistoryScreenState extends State<InvoiceHistoryScreen> {
  final List<Map<String, String>> _invoices = [
    {
      'date': '2026-06-21',
      'id': 'in_1Moc88421a8cd2e71',
      'amount': '\$29.00',
      'status': 'PAID',
    },
    {
      'date': '2026-05-21',
      'id': 'in_1Moc88421a8cd2e70',
      'amount': '\$29.00',
      'status': 'PAID',
    },
    {
      'date': '2026-04-21',
      'id': 'in_1Moc88421a8cd2e69',
      'amount': '\$29.00',
      'status': 'PAID',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Invoices Archive', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Row(
        children: [
          // Sidebar menu
          Container(
            width: 240,
            color: const Color(0xFF1E293B),
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              children: [
                const Text(
                  'BILLING PLATFORM',
                  style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                ),
                const SizedBox(height: 12),
                _buildSidebarItem(context, Icons.credit_card, 'Overview & Plan', '/billing/subscription'),
                _buildSidebarItem(context, Icons.bar_chart, 'Usage Metering', '/billing/usage'),
                _buildSidebarItem(context, Icons.history, 'Invoices Archive', '/billing/invoices', active: true),
                _buildSidebarItem(context, Icons.list_alt_rounded, 'Plans Pricing', '/billing/plans'),
              ],
            ),
          ),
          // Main panel
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(40),
              children: [
                const Text(
                  'Past Billing Statements',
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Download transaction history statements and PDF receipts.',
                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                ),
                const SizedBox(height: 32),
                // Table layout
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  child: Table(
                    columnWidths: const {
                      0: FlexColumnWidth(1.5),
                      1: FlexColumnWidth(3.0),
                      2: FlexColumnWidth(1.2),
                      3: FlexColumnWidth(1.2),
                      4: FlexColumnWidth(1.5),
                    },
                    children: [
                      // Header Row
                      const TableRow(
                        decoration: BoxDecoration(
                          color: Color(0xFF0F172A),
                          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                        ),
                        children: [
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text('DATE', style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text('INVOICE ID', style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text('AMOUNT', style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text('STATUS', style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text('ACTIONS', style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      // Data Rows
                      ..._invoices.map((inv) {
                        return TableRow(
                          decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(color: Color(0xFF334155))),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(inv['date']!, style: const TextStyle(color: Colors.white, fontSize: 13)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(inv['id']!, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontFamily: 'monospace')),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(inv['amount']!, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                inv['status']!,
                                style: const TextStyle(color: Color(0xFF10B981), fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              child: TextButton.icon(
                                style: TextButton.styleFrom(padding: EdgeInsets.zero, alignment: Alignment.centerLeft),
                                icon: const Icon(Icons.download, size: 16, color: Color(0xFF38BDF8)),
                                label: const Text('Download PDF', style: TextStyle(color: Color(0xFF38BDF8), fontSize: 12)),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Downloading receipt PDF file...')),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(BuildContext context, IconData icon, String title, String path, {bool active = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: active ? const Color(0xFF0F172A) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(icon, color: active ? const Color(0xFF38BDF8) : const Color(0xFF64748B), size: 18),
        title: Text(
          title,
          style: TextStyle(color: active ? Colors.white : const Color(0xFF94A3B8), fontWeight: active ? FontWeight.bold : FontWeight.normal),
        ),
        onTap: () {
          if (!active) {
            context.push(path);
          }
        },
      ),
    );
  }
}
