import 'package:flutter/material.dart';
import '../services/local_cache_service.dart';

class WorkspaceLauncherScreen extends StatefulWidget {
  const WorkspaceLauncherScreen({super.key});

  @override
  State<WorkspaceLauncherScreen> createState() => _WorkspaceLauncherScreenState();
}

class _WorkspaceLauncherScreenState extends State<WorkspaceLauncherScreen> {
  List<Map<String, dynamic>> _workspaces = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWorkspaces();
  }

  Future<void> _loadWorkspaces() async {
    // Simulate loading workspaces
    await Future.delayed(const Duration(milliseconds: 600));

    setState(() {
      _workspaces = [
        {
          'id': 'ws-1',
          'name': 'TeamOS Corp',
          'domain': 'teamos.workspace',
          'membersCount': 42,
          'projectsCount': 5,
          'avatarUrl': null,
          'color': const Color(0xFF38BDF8),
        },
        {
          'id': 'ws-2',
          'name': 'Enterprise AI Solutions',
          'domain': 'ai-solutions.workspace',
          'membersCount': 18,
          'projectsCount': 3,
          'avatarUrl': null,
          'color': const Color(0xFF8B5CF6),
        },
        {
          'id': 'ws-3',
          'name': 'Alpha R&D Labs',
          'domain': 'alpha-labs.workspace',
          'membersCount': 8,
          'projectsCount': 2,
          'avatarUrl': null,
          'color': const Color(0xFFF43F5E),
        },
      ];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Row(
        children: [
          // Left Side bar (Icon based)
          Container(
            width: 70,
            color: const Color(0xFF1E293B),
            child: Column(
              children: [
                const SizedBox(height: 24),
                // Home Logo Icon
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFF38BDF8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.rocket_launch, color: Colors.white, size: 24),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.settings, color: Color(0xFF64748B)),
                  onPressed: () {
                    Navigator.pushNamed(context, '/desktop-settings');
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Workspace',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Choose a workspace to launch or switch environment',
                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                  ),
                  const SizedBox(height: 40),
                  Expanded(
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(color: Color(0xFF38BDF8)),
                          )
                        : GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 24,
                              mainAxisSpacing: 24,
                              childAspectRatio: 1.6,
                            ),
                            itemCount: _workspaces.length,
                            itemBuilder: (context, index) {
                              final ws = _workspaces[index];
                              return MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Launching workspace: ${ws['name']}')),
                                    );
                                    Navigator.pushReplacementNamed(context, '/dashboard');
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1E293B),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: const Color(0xFF334155), width: 1.5),
                                    ),
                                    padding: const EdgeInsets.all(24),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: 48,
                                              height: 48,
                                              decoration: BoxDecoration(
                                                color: ws['color'].withOpacity(0.12),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  ws['name'][0],
                                                  style: TextStyle(
                                                    color: ws['color'],
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    ws['name'],
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 3),
                                                  Text(
                                                    ws['domain'],
                                                    style: const TextStyle(
                                                      color: Color(0xFF64748B),
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        const Divider(color: Color(0xFF334155)),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${ws['membersCount']} Members',
                                              style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                                            ),
                                            Text(
                                              '${ws['projectsCount']} Projects',
                                              style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
