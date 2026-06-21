import 'package:flutter/material.dart';

class KPIBuilderScreen extends StatefulWidget {
  const KPIBuilderScreen({super.key});

  @override
  State<KPIBuilderScreen> createState() => _KPIBuilderScreenState();
}

class _KPIBuilderScreenState extends State<KPIBuilderScreen> {
  final List<KPIData> _kpis = [
    KPIData(name: 'Sprint Velocity Target', metricType: 'VELOCITY', targetValue: 50.0, currentValue: 45.0),
    KPIData(name: 'Task Delivery SLA', metricType: 'HOURS', targetValue: 24.0, currentValue: 28.5),
    KPIData(name: 'Platform Test Coverage', metricType: 'PERCENTAGE', targetValue: 90.0, currentValue: 88.2),
    KPIData(name: 'AI Tokens Spent Quota', metricType: 'TOKENS', targetValue: 500000.0, currentValue: 420000.0),
  ];

  final _nameController = TextEditingController();
  final _targetController = TextEditingController();
  String _selectedMetricType = 'VELOCITY';

  final List<String> _metricTypes = [
    'VELOCITY',
    'PERCENTAGE',
    'HOURS',
    'TOKENS',
    'COUNT',
    'BYTES'
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  void _addKPI() {
    final name = _nameController.text;
    final target = double.tryParse(_targetController.text) ?? 0.0;

    if (name.isNotEmpty && target > 0) {
      setState(() {
        _kpis.add(KPIData(
          name: name,
          metricType: _selectedMetricType,
          targetValue: target,
          currentValue: 0.0,
        ));
        _nameController.clear();
        _targetController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('KPI defined successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('KPI Builder', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enterprise KPIs',
              style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Design custom indicators, establish thresholds, and monitor real-time workspace metrics.',
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
            ),
            const SizedBox(height: 24),

            // KPIs Grid/List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _kpis.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final kpi = _kpis[index];
                final progressPct = kpi.targetValue > 0 ? (kpi.currentValue / kpi.targetValue) : 0.0;
                final isOverTarget = kpi.currentValue >= kpi.targetValue;
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
                          Expanded(
                            child: Text(
                              kpi.name,
                              style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F172A),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              kpi.metricType,
                              style: const TextStyle(color: Color(0xFF3B82F6), fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Target Value', style: TextStyle(color: Color(0xFF64748B), fontSize: 11)),
                              const SizedBox(height: 4),
                              Text(kpi.targetValue.toStringAsFixed(1), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text('Current Value', style: TextStyle(color: Color(0xFF64748B), fontSize: 11)),
                              const SizedBox(height: 4),
                              Text(
                                kpi.currentValue.toStringAsFixed(1),
                                style: TextStyle(
                                  color: isOverTarget ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      LinearProgressIndicator(
                        value: progressPct.clamp(0.0, 1.0),
                        backgroundColor: const Color(0xFF0F172A),
                        color: isOverTarget ? const Color(0xFF10B981) : const Color(0xFF3B82F6),
                        minHeight: 4,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 32),

            // Form to Add KPI
            const Text(
              'Build New KPI',
              style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'KPI Name',
                      labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
                      filled: true,
                      fillColor: const Color(0xFF0F172A),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: _selectedMetricType,
                    style: const TextStyle(color: Colors.white),
                    dropdownColor: const Color(0xFF1E293B),
                    decoration: InputDecoration(
                      labelText: 'Metric Type',
                      labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
                      filled: true,
                      fillColor: const Color(0xFF0F172A),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    items: _metricTypes.map((type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedMetricType = val;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _targetController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Target Threshold Value',
                      labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
                      filled: true,
                      fillColor: const Color(0xFF0F172A),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _addKPI,
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text('Register KPI Indicator', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class KPIData {
  final String name;
  final String metricType;
  final double targetValue;
  final double currentValue;

  KPIData({required this.name, required this.metricType, required this.targetValue, required this.currentValue});
}
