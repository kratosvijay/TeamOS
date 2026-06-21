import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ProductivityAnalyticsScreen extends StatefulWidget {
  const ProductivityAnalyticsScreen({super.key});

  @override
  State<ProductivityAnalyticsScreen> createState() => _ProductivityAnalyticsScreenState();
}

class _ProductivityAnalyticsScreenState extends State<ProductivityAnalyticsScreen> {
  bool _isLoading = true;

  double _focusHours = 5.5;
  double _meetingHours = 2.2;
  double _completionRate = 82.0;
  int _docCount = 8;
  int _workspaceHealth = 88;

  @override
  void initState() {
    super.initState();
    _loadMetrics();
  }

  Future<void> _loadMetrics() async {
    // Simulate loading REST api response
    await Future.delayed(const Duration(milliseconds: 700));
    setState(() {
      _focusHours = 6.2;
      _meetingHours = 1.5;
      _completionRate = 88.5;
      _docCount = 12;
      _workspaceHealth = 92;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Productivity Analytics', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF38BDF8)))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // KPI cards row
                  Row(
                    children: [
                      Expanded(
                        child: _buildKPICard(
                          title: 'FOCUS TIME',
                          value: '${_focusHours.toStringAsFixed(1)} hrs',
                          subtitle: 'Daily target: 6.0 hrs',
                          icon: Icons.timer,
                          color: const Color(0xFF38BDF8),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _buildKPICard(
                          title: 'MEETING TIME',
                          value: '${_meetingHours.toStringAsFixed(1)} hrs',
                          subtitle: '45m decrease from yesterday',
                          icon: Icons.video_call,
                          color: const Color(0xFFFB7185),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _buildKPICard(
                          title: 'TASK COMPLETION',
                          value: '${_completionRate.toStringAsFixed(1)}%',
                          subtitle: 'Weekly Sprint efficiency',
                          icon: Icons.task_alt,
                          color: const Color(0xFF34D399),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _buildKPICard(
                          title: 'HEALTH SCORE',
                          value: '$_workspaceHealth / 100',
                          subtitle: 'Optimal resource velocity',
                          icon: Icons.favorite,
                          color: const Color(0xFFA855F7),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Charts Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Weekly Focus time trend (Line chart)
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 380,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E293B),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFF334155)),
                          ),
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Weekly Focus Time Trend',
                                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Active code editing & development hours',
                                style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
                              ),
                              const SizedBox(height: 32),
                              Expanded(
                                child: LineChart(
                                  LineChartData(
                                    gridData: FlGridData(
                                      show: true,
                                      drawVerticalLine: false,
                                      getDrawingHorizontalLine: (val) => const FlLine(
                                        color: Color(0xFF334155),
                                        strokeWidth: 1,
                                      ),
                                    ),
                                    titlesData: FlTitlesData(
                                      leftTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          getTitlesWidget: (val, meta) => Text(
                                            '${val.toInt()}h',
                                            style: const TextStyle(color: Color(0xFF64748B), fontSize: 10),
                                          ),
                                          reservedSize: 30,
                                        ),
                                      ),
                                      bottomTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          getTitlesWidget: (val, meta) {
                                            const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                                            if (val >= 0 && val < days.length) {
                                              return Text(
                                                days[val.toInt()],
                                                style: const TextStyle(color: Color(0xFF64748B), fontSize: 10),
                                              );
                                            }
                                            return const Text('');
                                          },
                                          reservedSize: 22,
                                        ),
                                      ),
                                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    ),
                                    borderData: FlBorderData(show: false),
                                    minX: 0,
                                    maxX: 6,
                                    minY: 0,
                                    maxY: 10,
                                    lineBarsData: [
                                      LineChartBarData(
                                        spots: const [
                                          FlSpot(0, 5.0),
                                          FlSpot(1, 6.2),
                                          FlSpot(2, 4.8),
                                          FlSpot(3, 7.5),
                                          FlSpot(4, 6.8),
                                          FlSpot(5, 2.0),
                                          FlSpot(6, 1.5),
                                        ],
                                        isCurved: true,
                                        color: const Color(0xFF38BDF8),
                                        barWidth: 3.5,
                                        isStrokeCapRound: true,
                                        dotData: const FlDotData(show: false),
                                        belowBarData: BarAreaData(
                                          show: true,
                                          color: const Color(0xFF38BDF8).withOpacity(0.08),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),

                      // Document metrics / Activity break down (Bar chart)
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 380,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E293B),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFF334155)),
                          ),
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Workspace Contributions',
                                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Updates across different modules',
                                style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
                              ),
                              const SizedBox(height: 40),
                              Expanded(
                                child: BarChart(
                                  BarChartData(
                                    barGroups: [
                                      BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 14, color: const Color(0xFF38BDF8), width: 14)]),
                                      BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 8, color: const Color(0xFF34D399), width: 14)]),
                                      BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 5, color: const Color(0xFFFB7185), width: 14)]),
                                      BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 10, color: const Color(0xFFFBBF24), width: 14)]),
                                    ],
                                    titlesData: FlTitlesData(
                                      bottomTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          getTitlesWidget: (val, meta) {
                                            const labels = ['Tasks', 'Wiki', 'DM', 'Repo'];
                                            if (val >= 0 && val < labels.length) {
                                              return Padding(
                                                padding: const EdgeInsets.only(top: 8.0),
                                                child: Text(
                                                  labels[val.toInt()],
                                                  style: const TextStyle(color: Color(0xFF64748B), fontSize: 10),
                                                ),
                                              );
                                            }
                                            return const Text('');
                                          },
                                        ),
                                      ),
                                      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    ),
                                    gridData: const FlGridData(show: false),
                                    borderData: FlBorderData(show: false),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildKPICard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
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
              Text(
                title,
                style: const TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold),
              ),
              Icon(icon, color: color, size: 20),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
          ),
        ],
      ),
    );
  }
}
