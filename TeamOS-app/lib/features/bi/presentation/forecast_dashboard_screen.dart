import 'package:flutter/material.dart';

class ForecastDashboardScreen extends StatefulWidget {
  const ForecastDashboardScreen({super.key});

  @override
  State<ForecastDashboardScreen> createState() => _ForecastDashboardScreenState();
}

class _ForecastDashboardScreenState extends State<ForecastDashboardScreen> {
  // Delivery Simulator State
  double _velocity = 30.0;
  double _remainingStoryPoints = 120.0;

  // Burnout Simulator State
  double _activeHighPriorityTasks = 4.0;
  double _meetingHoursPerWeek = 12.0;

  // Capacity Simulator State
  double _teamAvailabilityHours = 160.0;
  double _sprintLoadHours = 135.0;

  // Calculated properties
  String get _estimatedCompletionDate {
    if (_velocity <= 0) return 'Never (Velocity is 0)';
    final sprintsNeeded = (_remainingStoryPoints / _velocity).ceil();
    final daysNeeded = sprintsNeeded * 14; // assume 2-week sprints
    final date = DateTime.now().add(Duration(days: daysNeeded));
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ($sprintsNeeded sprints)';
  }

  bool get _hasBurnoutWarning {
    return _activeHighPriorityTasks > 5;
  }

  double get _remainingCapacityHours {
    return (_teamAvailabilityHours - _sprintLoadHours).clamp(0.0, double.infinity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Forecasting Engine', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Predictive Projections',
              style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Simulate development trends, delivery timeframes, burnout warnings, and allocations.',
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
            ),
            const SizedBox(height: 24),

            // 1. Delivery Forecast
            _buildSectionCard(
              title: 'Delivery Forecast (Sprints & Timelines)',
              icon: Icons.timeline,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Sprint Velocity: ${_velocity.round()} pts', style: const TextStyle(color: Colors.white)),
                      Text('Remaining Story Points: ${_remainingStoryPoints.round()} pts', style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Slider(
                    value: _velocity,
                    min: 5,
                    max: 80,
                    divisions: 15,
                    activeColor: const Color(0xFF3B82F6),
                    inactiveColor: const Color(0xFF0F172A),
                    onChanged: (v) => setState(() => _velocity = v),
                  ),
                  Slider(
                    value: _remainingStoryPoints,
                    min: 10,
                    max: 300,
                    divisions: 29,
                    activeColor: const Color(0xFF3B82F6),
                    inactiveColor: const Color(0xFF0F172A),
                    onChanged: (v) => setState(() => _remainingStoryPoints = v),
                  ),
                  const Divider(color: Color(0xFF334155), height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Estimated Completion Date', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
                      Text(
                        _estimatedCompletionDate,
                        style: const TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 2. Burnout & Risk Warning
            _buildSectionCard(
              title: 'Burnout & Risk Prediction',
              icon: Icons.warning_amber_rounded,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('High-Priority Active Tasks: ${_activeHighPriorityTasks.round()}', style: const TextStyle(color: Colors.white)),
                      Text('Weekly Meeting Load: ${_meetingHoursPerWeek.round()} hrs', style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Slider(
                    value: _activeHighPriorityTasks,
                    min: 0,
                    max: 10,
                    divisions: 10,
                    activeColor: const Color(0xFF3B82F6),
                    inactiveColor: const Color(0xFF0F172A),
                    onChanged: (v) => setState(() => _activeHighPriorityTasks = v),
                  ),
                  Slider(
                    value: _meetingHoursPerWeek,
                    min: 0,
                    max: 40,
                    divisions: 8,
                    activeColor: const Color(0xFF3B82F6),
                    inactiveColor: const Color(0xFF0F172A),
                    onChanged: (v) => setState(() => _meetingHoursPerWeek = v),
                  ),
                  const Divider(color: Color(0xFF334155), height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Burnout Health Status', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _hasBurnoutWarning ? const Color(0xFFEF4444).withOpacity(0.15) : const Color(0xFF10B981).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: _hasBurnoutWarning ? const Color(0xFFEF4444) : const Color(0xFF10B981)),
                        ),
                        child: Text(
                          _hasBurnoutWarning ? 'WARNING: HIGH RISK' : 'NORMAL / STABLE',
                          style: TextStyle(
                            color: _hasBurnoutWarning ? const Color(0xFFEF4444) : const Color(0xFF10B981),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_hasBurnoutWarning) ...[
                    const SizedBox(height: 12),
                    const Text(
                      'Rule: >5 Active High Priority Tasks creates critical overload status.',
                      style: TextStyle(color: Color(0xFFEF4444), fontSize: 11, fontStyle: FontStyle.italic),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 3. Capacity Forecast
            _buildSectionCard(
              title: 'Sprint Capacity Allocations',
              icon: Icons.people_outline,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Allocated Capacity: ${_teamAvailabilityHours.round()} hrs', style: const TextStyle(color: Colors.white)),
                      Text('Sprint Target Load: ${_sprintLoadHours.round()} hrs', style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Slider(
                    value: _teamAvailabilityHours,
                    min: 80,
                    max: 400,
                    divisions: 16,
                    activeColor: const Color(0xFF3B82F6),
                    inactiveColor: const Color(0xFF0F172A),
                    onChanged: (v) => setState(() => _teamAvailabilityHours = v),
                  ),
                  Slider(
                    value: _sprintLoadHours,
                    min: 40,
                    max: 400,
                    divisions: 18,
                    activeColor: const Color(0xFF3B82F6),
                    inactiveColor: const Color(0xFF0F172A),
                    onChanged: (v) => setState(() => _sprintLoadHours = v),
                  ),
                  const Divider(color: Color(0xFF334155), height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Remaining Available Capacity', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
                      Text(
                        '${_remainingCapacityHours.round()} hrs remaining',
                        style: TextStyle(
                          color: _remainingCapacityHours > 20 ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 4. Financial / Risk Forecast
            _buildSectionCard(
              title: 'Strategic Revenue & Budget Forecast',
              icon: Icons.monetization_on_outlined,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFinancialItem('Estimated Q3 Runway', '\$420,000 / \$500,000', 0.84, const Color(0xFF10B981)),
                  const SizedBox(height: 12),
                  _buildFinancialItem('AI Compute Spending Forecast', '\$12,400 / \$10,000', 1.0, const Color(0xFFEF4444)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required IconData icon, required Widget child}) {
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
            children: [
              Icon(icon, color: const Color(0xFF3B82F6), size: 20),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _buildFinancialItem(String label, String val, double progress, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 13)),
            Text(val, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: const Color(0xFF0F172A),
          color: color,
          minHeight: 6,
          borderRadius: BorderRadius.circular(3),
        ),
      ],
    );
  }
}
