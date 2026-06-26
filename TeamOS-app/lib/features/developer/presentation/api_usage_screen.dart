import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../dashboard/presentation/dashboard_screen.dart';

class ApiUsageScreen extends StatelessWidget {
  const ApiUsageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> logs = [
      {'method': 'GET', 'path': '/api/v1/tasks', 'status': 200, 'time': '12:04:15', 'duration': '12ms'},
      {'method': 'POST', 'path': '/api/v1/tasks', 'status': 201, 'time': '12:04:40', 'duration': '45ms'},
      {'method': 'GET', 'path': '/api/v1/documents', 'status': 429, 'time': '12:05:00', 'duration': '1ms'}, // Rate limit hit
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Row(
        children: [
          const SidebarWidget(isCollapsed: false),
          Expanded(
            child: Column(
              children: [
                const TopBarWidget(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () => context.go('/developer'),
                          child: const Row(
                            children: [
                              Icon(Icons.arrow_back_rounded, color: Color(0xFF3B82F6), size: 16),
                              SizedBox(width: 4),
                              Text('Back to Developer Portal', style: TextStyle(color: Color(0xFF3B82F6))),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'API Usage & Rate Limiting Logs',
                          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        _buildRateLimitCard(),
                        const SizedBox(height: 28),
                        const Text('Real-Time Request Gateway Logs', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: logs.length,
                          itemBuilder: (context, index) {
                            final log = logs[index];
                            final isSuccess = log['status'] < 300;
                            final isRateLimited = log['status'] == 429;
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E293B),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFF334155)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: log['method'] == 'GET' ? Colors.blue.withOpacity(0.2) : Colors.green.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          log['method'],
                                          style: TextStyle(
                                            color: log['method'] == 'GET' ? Colors.blue : Colors.green,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(log['path'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                          const SizedBox(height: 4),
                                          Text('Time: ${log['time']} | Duration: ${log['duration']}', style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
                                        ],
                                      )
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: isSuccess
                                          ? Colors.green.withOpacity(0.2)
                                          : isRateLimited
                                              ? Colors.orange.withOpacity(0.2)
                                              : Colors.red.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      isRateLimited ? '429 Rate Limit' : log['status'].toString(),
                                      style: TextStyle(
                                        color: isSuccess
                                            ? Colors.green
                                            : isRateLimited
                                                ? Colors.orange
                                                : Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRateLimitCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rate Limiting Summary Status',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'Limit: 100 requests per minute. Reset window: Sliding 60 seconds.',
            style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
          ),
        ],
      ),
    );
  }
}
