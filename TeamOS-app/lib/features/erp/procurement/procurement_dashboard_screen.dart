import 'package:flutter/material.dart';

class ProcurementDashboardScreen extends StatelessWidget {
  const ProcurementDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Procurement Center', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Procurement Overview',
              style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Coordinate purchase requests, monitor pending orders, and assess vendor risk ratings.',
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: _buildProcureCard('PENDING REQUESTS', '5', Colors.amber)),
                const SizedBox(width: 12),
                Expanded(child: _buildProcureCard('ACTIVE ORDERS', '12', Colors.blue)),
                const SizedBox(width: 12),
                Expanded(child: _buildProcureCard('VENDORS REGISTERED', '42', Colors.green)),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Purchase Orders Activity',
              style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              padding: const EdgeInsets.all(16),
              child: const Column(
                children: [
                  _OrderRow('PO-2026-004', 'Dell Hardware Corp', '\$24,000', 'APPROVED'),
                  Divider(color: Color(0xFF334155)),
                  _OrderRow('PO-2026-003', 'Office Supply Co', '\$1,500', 'APPROVED'),
                  Divider(color: Color(0xFF334155)),
                  _OrderRow('PO-2026-002', 'AWS Cloud Services', '\$15,000', 'PENDING'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProcureCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _OrderRow extends StatelessWidget {
  final String poNumber;
  final String vendor;
  final String total;
  final String status;

  const _OrderRow(this.poNumber, this.vendor, this.total, this.status);

  @override
  Widget build(BuildContext context) {
    final statusColor = status == 'APPROVED' ? const Color(0xFF22C55E) : const Color(0xFFF59E0B);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(poNumber, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(vendor, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(total, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(status, style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
