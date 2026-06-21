import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class TaskReportsScreen extends HookWidget {
  const TaskReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isPdfExporting = useState<bool>(false);
    final isCsvExporting = useState<bool>(false);

    // Mock burndown points
    final burndownPoints = [
      {'day': 0, 'actual': 45.0, 'ideal': 45.0},
      {'day': 2, 'actual': 40.0, 'ideal': 38.5},
      {'day': 4, 'actual': 32.0, 'ideal': 32.0},
      {'day': 6, 'actual': 28.0, 'ideal': 25.5},
      {'day': 8, 'actual': 20.0, 'ideal': 19.0},
      {'day': 10, 'actual': 12.0, 'ideal': 12.5},
      {'day': 12, 'actual': 5.0, 'ideal': 6.0},
      {'day': 14, 'actual': 0.0, 'ideal': 0.0},
    ];

    void exportPdf() async {
      isPdfExporting.value = true;
      await Future.delayed(const Duration(seconds: 2));
      isPdfExporting.value = false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sprint PDF Report downloaded successfully!'), backgroundColor: Colors.green),
      );
    }

    void exportCsv() async {
      isCsvExporting.value = true;
      await Future.delayed(const Duration(milliseconds: 1200));
      isCsvExporting.value = false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sprint CSV Report downloaded successfully!'), backgroundColor: Colors.green),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Sprint Reports & Analytics', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1E293B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Export actions row
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isPdfExporting.value ? null : exportPdf,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E293B),
                      side: const BorderSide(color: Color(0xFF334155)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: isPdfExporting.value
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Icon(Icons.picture_as_pdf_rounded, color: Colors.redAccent),
                    label: const Text('Export PDF', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isCsvExporting.value ? null : exportCsv,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E293B),
                      side: const BorderSide(color: Color(0xFF334155)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: isCsvExporting.value
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Icon(Icons.grid_on_rounded, color: Colors.greenAccent),
                    label: const Text('Export CSV', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Burndown Chart Simulation Card
            const Text('Sprint Burndown Chart', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Column(
                children: [
                  // Burndown lines drawing simulation
                  SizedBox(
                    height: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: burndownPoints.map((pt) {
                        final actualHeight = (pt['actual'] as double) * 2.8;
                        final idealHeight = (pt['ideal'] as double) * 2.8;

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  width: 8,
                                  height: actualHeight,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF3B82F6),
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(2), topRight: Radius.circular(2)),
                                  ),
                                ),
                                const SizedBox(width: 2),
                                Container(
                                  width: 8,
                                  height: idealHeight,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade700,
                                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(2), topRight: Radius.circular(2)),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text('D${pt['day']}', style: const TextStyle(color: Color(0xFF64748B), fontSize: 10)),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(width: 12, height: 12, color: const Color(0xFF3B82F6)),
                      const SizedBox(width: 8),
                      const Text('Actual Remaining', style: TextStyle(color: Colors.white, fontSize: 12)),
                      const SizedBox(width: 24),
                      Container(width: 12, height: 12, color: Colors.grey.shade700),
                      const SizedBox(width: 8),
                      const Text('Ideal remaining', style: TextStyle(color: Colors.white, fontSize: 12)),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Backlog Health Card
            const Text('Backlog Health', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Column(
                children: [
                  buildHealthIndicator('Unestimated Issues', '4 issues', Colors.amberAccent),
                  const Divider(color: Color(0xFF334155), height: 24),
                  buildHealthIndicator('Unassigned Tasks', '2 tasks', Colors.redAccent),
                  const Divider(color: Color(0xFF334155), height: 24),
                  buildHealthIndicator('Critical Path Blockers', '1 blockers', Colors.redAccent),
                  const Divider(color: Color(0xFF334155), height: 24),
                  buildHealthIndicator('High Priority Backlog', '7 issues', Colors.amberAccent),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Capacity planning
            const Text('Capacity Planning', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Column(
                children: [
                  buildCapacityRow('John Doe', '12 SP / 40h', '32h Logged'),
                  const Divider(color: Color(0xFF334155), height: 24),
                  buildCapacityRow('Sarah Jenkins', '8 SP / 32h', '30h Logged'),
                  const Divider(color: Color(0xFF334155), height: 24),
                  buildCapacityRow('Alex Martinez', '10 SP / 35h', '35h Logged'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHealthIndicator(String title, String val, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14)),
        Text(val, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }

  Widget buildCapacityRow(String devName, String load, String logged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(devName, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(load, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
            const SizedBox(height: 2),
            Text(logged, style: const TextStyle(color: Colors.greenAccent, fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        )
      ],
    );
  }
}
