import 'package:flutter/material.dart';

class ResourcePlanningScreen extends StatefulWidget {
  const ResourcePlanningScreen({super.key});

  @override
  State<ResourcePlanningScreen> createState() => _ResourcePlanningScreenState();
}

class _ResourcePlanningScreenState extends State<ResourcePlanningScreen> {
  final List<ResourceAllocation> _allocations = [
    ResourceAllocation(name: 'Sarah Connor', role: 'Staff Engineer', activeTasks: 6, priorityTasks: 6, meetingHours: 15, utilization: 95),
    ResourceAllocation(name: 'John Doe', role: 'Frontend Engineer', activeTasks: 4, priorityTasks: 3, meetingHours: 8, utilization: 75),
    ResourceAllocation(name: 'Marcus Wright', role: 'DevOps Lead', activeTasks: 3, priorityTasks: 1, meetingHours: 4, utilization: 60),
    ResourceAllocation(name: 'Kyle Reese', role: 'Security Specialist', activeTasks: 7, priorityTasks: 2, meetingHours: 18, utilization: 92),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Resource Planning', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Team Utilization & Allocations',
              style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Audit overcommitments, allocations, and burnout warnings. Warns when high-priority tasks exceed 5.',
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
            ),
            const SizedBox(height: 24),

            // Active Allocations List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _allocations.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final resource = _allocations[index];
                final isBurnoutRisk = resource.priorityTasks > 5;
                final statusColor = isBurnoutRisk
                    ? const Color(0xFFEF4444)
                    : (resource.utilization >= 85 ? const Color(0xFFF59E0B) : const Color(0xFF10B981));

                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isBurnoutRisk ? const Color(0xFFEF4444) : const Color(0xFF334155)),
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
                              Text(resource.name, style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 2),
                              Text(resource.role, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: statusColor, width: 1.5),
                            ),
                            child: Text(
                              isBurnoutRisk ? 'BURNOUT RISK' : '${resource.utilization}% Utilization',
                              style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const Divider(color: Color(0xFF334155), height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildPlanItem('Active Tasks', '${resource.activeTasks} Total'),
                          _buildPlanItem('High Priority', '${resource.priorityTasks} Active', color: resource.priorityTasks > 5 ? const Color(0xFFEF4444) : null),
                          _buildPlanItem('Meeting Load', '${resource.meetingHours} hrs/wk'),
                        ],
                      ),
                      if (isBurnoutRisk) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEF4444).withOpacity(0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.error_outline, color: Color(0xFFEF4444), size: 16),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Developer has >5 active high-priority tasks. Capacity redistribution is highly recommended.',
                                  style: TextStyle(color: Color(0xFFEF4444), fontSize: 11),
                                ),
                              ),
                            ],
                          ),
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

  Widget _buildPlanItem(String label, String value, {Color? color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(color: color ?? Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
      ],
    );
  }
}

class ResourceAllocation {
  final String name;
  final String role;
  final int activeTasks;
  final int priorityTasks;
  final int meetingHours;
  final int utilization;

  ResourceAllocation({
    required this.name,
    required this.role,
    required this.activeTasks,
    required this.priorityTasks,
    required this.meetingHours,
    required this.utilization,
  });
}
