import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ObjectiveDetailsScreen extends StatefulWidget {
  final String objectiveId;

  const ObjectiveDetailsScreen({super.key, required this.objectiveId});

  @override
  State<ObjectiveDetailsScreen> createState() => _ObjectiveDetailsScreenState();
}

class _ObjectiveDetailsScreenState extends State<ObjectiveDetailsScreen> {
  late String _objectiveTitle;
  late List<KeyResultData> _krs;

  final _krTitleController = TextEditingController();
  final _krTargetController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Simulate fetching based on ID
    if (widget.objectiveId == '1') {
      _objectiveTitle = 'Achieve SOC2 Compliance Readiness';
      _krs = [
        KeyResultData(title: 'Complete external vulnerability audit', targetValue: 100, currentValue: 100),
        KeyResultData(title: 'Review and sign off all 45 security policies', targetValue: 45, currentValue: 38),
        KeyResultData(title: 'Train 100% of staff on security protocols', targetValue: 100, currentValue: 70),
      ];
    } else if (widget.objectiveId == '2') {
      _objectiveTitle = 'Expand Enterprise Integrations Portfolio';
      _krs = [
        KeyResultData(title: 'Build GitHub integration sync client', targetValue: 1, currentValue: 1),
        KeyResultData(title: 'Build GitLab integration sync client', targetValue: 1, currentValue: 0),
        KeyResultData(title: 'Draft API spec for Slack app integration', targetValue: 100, currentValue: 50),
        KeyResultData(title: 'Obtain Microsoft 365 publisher verification', targetValue: 100, currentValue: 20),
      ];
    } else {
      _objectiveTitle = 'Optimize Team Resource Allocations';
      _krs = [
        KeyResultData(title: 'Map active developers to primary sprints', targetValue: 10, currentValue: 1),
        KeyResultData(title: 'Reduce overcommitted staff alerts to 0', targetValue: 5, currentValue: 5), // lower is better or direct progression
      ];
    }
  }

  @override
  void dispose() {
    _krTitleController.dispose();
    _krTargetController.dispose();
    super.dispose();
  }

  double get _averageProgress {
    if (_krs.isEmpty) return 0.0;
    double totalProgress = 0.0;
    for (var kr in _krs) {
      totalProgress += (kr.currentValue / kr.targetValue).clamp(0.0, 1.0);
    }
    return totalProgress / _krs.length;
  }

  void _addKeyResult() {
    final title = _krTitleController.text;
    final target = double.tryParse(_krTargetController.text) ?? 100.0;

    if (title.isNotEmpty && target > 0) {
      setState(() {
        _krs.add(KeyResultData(
          title: title,
          targetValue: target,
          currentValue: 0.0,
        ));
        _krTitleController.clear();
        _krTargetController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Key Result added to Objective')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final progressPct = (_averageProgress * 100).toStringAsFixed(1);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Objective Details', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header card
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
                  const Text(
                    'OBJECTIVE',
                    style: TextStyle(color: Color(0xFF3B82F6), fontWeight: FontWeight.bold, fontSize: 11),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _objectiveTitle,
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Progress Alignment', style: TextStyle(color: const Color(0xFF94A3B8), fontSize: 13)),
                      Text('$progressPct%', style: const TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: _averageProgress,
                    backgroundColor: const Color(0xFF0F172A),
                    color: const Color(0xFF10B981),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Key Results List
            const Text(
              'Key Results',
              style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _krs.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final kr = _krs[index];
                final krProgress = (kr.currentValue / kr.targetValue).clamp(0.0, 1.0);
                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(kr.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Value: ${kr.currentValue.toStringAsFixed(0)} / ${kr.targetValue.toStringAsFixed(0)}',
                            style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                          ),
                          Text(
                            '${(krProgress * 100).toStringAsFixed(0)}%',
                            style: const TextStyle(color: Color(0xFF3B82F6), fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Slider(
                        value: kr.currentValue,
                        min: 0,
                        max: kr.targetValue,
                        activeColor: const Color(0xFF3B82F6),
                        inactiveColor: const Color(0xFF0F172A),
                        onChanged: (val) {
                          setState(() {
                            kr.currentValue = val;
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 32),

            // Form to Add KR
            const Text(
              'Add Key Result',
              style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _krTitleController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Key Result Title',
                      labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
                      filled: true,
                      fillColor: const Color(0xFF0F172A),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _krTargetController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Target Metric Value',
                      labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
                      filled: true,
                      fillColor: const Color(0xFF0F172A),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _addKeyResult,
                    child: const Text('Add Key Result', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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

class KeyResultData {
  final String title;
  final double targetValue;
  double currentValue;

  KeyResultData({required this.title, required this.targetValue, required this.currentValue});
}
