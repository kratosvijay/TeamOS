import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../dashboard/presentation/dashboard_screen.dart';

class SdkDocumentationScreen extends StatelessWidget {
  const SdkDocumentationScreen({super.key});

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
                          'TeamOS Extension SDK Guides',
                          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        _buildDocCard(
                          'Extension Runtime Sandbox Limits',
                          'Plugins are executed inside a secure Node VM sandbox. Network, filesystem, shell execution, and global process access are blocked. Access core capabilities exclusively via the global `sdk` object.',
                        ),
                        const SizedBox(height: 16),
                        _buildCodeDocCard(
                          'Example Plugin Script (Trigger: TaskCreated)',
                          '''
// When a task is created, log details and generate a summary using AI
(async () => {
  const taskId = event.data.taskId;
  console.log(`Plugin Triggered for Task: \${taskId}`);

  // Fetch tasks using the secure sdk (requires READ_TASKS permission)
  const tasks = await sdk.getTasks();
  const targetTask = tasks.find(t => t.id === taskId);
  
  if (targetTask) {
    // Write summary using AI (requires AI_EXECUTE permission)
    const aiResponse = await sdk.executeAi(
      `Summarize this project task: \${targetTask.title}`
    );
    console.log(`Summary: \${aiResponse.text}`);
    result = aiResponse.text;
  }
})();
                          ''',
                        ),
                        const SizedBox(height: 16),
                        _buildDocCard(
                          'Permissions Scopes Reference',
                          'To query APIs, declare necessary permission nodes in your manifest.json:\n'
                              '• READ_TASKS / WRITE_TASKS\n'
                              '• READ_DOCUMENTS / WRITE_DOCUMENTS\n'
                              '• AI_EXECUTE\n'
                              '• ERP_READ / ERP_WRITE\n'
                              '• BILLING_READ',
                        ),
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

  Widget _buildDocCard(String title, String content) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text(content, style: const TextStyle(color: Color(0xFF94A3B8), height: 1.5, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildCodeDocCard(String title, String code) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF111827),
              borderRadius: BorderRadius.circular(8),
            ),
            child: SelectableText(
              code,
              style: const TextStyle(
                color: Colors.greenAccent,
                fontFamily: 'monospace',
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
