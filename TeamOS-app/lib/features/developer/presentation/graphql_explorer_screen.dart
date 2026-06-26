import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../dashboard/presentation/dashboard_screen.dart';

class GraphqlExplorerScreen extends StatefulWidget {
  const GraphqlExplorerScreen({super.key});

  @override
  State<GraphqlExplorerScreen> createState() => _GraphqlExplorerScreenState();
}

class _GraphqlExplorerScreenState extends State<GraphqlExplorerScreen> {
  final String _defaultQuery = '''
query GetWorkspaceTasks(\$workspaceId: String!) {
  getTasks(workspaceId: \$workspaceId) {
    id
    title
    status
    project {
      name
    }
  }
}
  ''';

  String _queryResult = '{ "data": { "getTasks": [] } }';
  bool _isLoading = false;

  void _runQuery() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      setState(() {
        _isLoading = false;
        _queryResult = '''
{
  "data": {
    "getTasks": [
      {
        "id": "task-101",
        "title": "Implement Sandboxed Extension Runtime",
        "status": "IN_PROGRESS",
        "project": {
          "name": "TeamOS PaaS Core"
        }
      },
      {
        "id": "task-102",
        "title": "Validate REST API v1 Stable Gateways",
        "status": "TODO",
        "project": {
          "name": "TeamOS PaaS Core"
        }
      }
    ]
  }
}
        ''';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  child: Row(
                    children: [
                      // Editor Panel (Left)
                      Expanded(
                        flex: 1,
                        child: Container(
                          color: const Color(0xFF1E293B),
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
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'GraphQL Query Editor',
                                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: _isLoading ? null : _runQuery,
                                    icon: const Icon(Icons.play_arrow_rounded),
                                    label: const Text('Execute'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF3B82F6),
                                      foregroundColor: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 16),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0F172A),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: const Color(0xFF334155)),
                                  ),
                                  child: TextFormField(
                                    initialValue: _defaultQuery,
                                    maxLines: null,
                                    keyboardType: TextInputType.multiline,
                                    style: const TextStyle(
                                      color: Colors.greenAccent,
                                      fontFamily: 'monospace',
                                      fontSize: 13,
                                    ),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      // Results Panel (Right)
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Query Execution Response',
                                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 16),
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1E293B),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: const Color(0xFF334155)),
                                  ),
                                  child: _isLoading
                                      ? const Center(child: CircularProgressIndicator(color: Color(0xFF3B82F6)))
                                      : SingleChildScrollView(
                                          child: SelectableText(
                                            _queryResult,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'monospace',
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
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
}
