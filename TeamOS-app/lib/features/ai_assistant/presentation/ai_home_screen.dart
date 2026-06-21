import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AIHomeScreen extends StatelessWidget {
  const AIHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('AI Workspace Platform', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Welcome to TeamOS AI', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Your context-aware enterprise orchestration engine is active.', style: TextStyle(color: Color(0xFFE0E7FF), fontSize: 14)),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text('AI Command Control', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            // Grid of Actions
            GridView.count(
              crossAxisCount: MediaQuery.of(context).size.width > 900 ? 4 : 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildCard(context, 'AI Workspace Chat', Icons.chat_bubble_outline_rounded, '/ai/chat/new', Colors.tealAccent),
                _buildCard(context, 'Unified AI Search', Icons.saved_search_rounded, '/ai/search', Colors.cyanAccent),
                _buildCard(context, 'Prompt Templates', Icons.article_outlined, '/ai/prompts', Colors.pinkAccent),
                _buildCard(context, 'Generated Artifacts', Icons.folder_open_rounded, '/ai/artifacts', Colors.amberAccent),
                _buildCard(context, 'Active Automations', Icons.autorenew_rounded, '/ai/automations', Colors.lightBlueAccent),
                _buildCard(context, 'Model Routing Rules', Icons.route_rounded, '/ai/model-policies', Colors.purpleAccent),
                _buildCard(context, 'Cost Governance', Icons.analytics_outlined, '/ai/usage', Colors.greenAccent),
                _buildCard(context, 'Quality Evaluations', Icons.fact_check_rounded, '/ai/evaluations', Colors.orangeAccent),
                _buildCard(context, 'Pending Approvals', Icons.lock_person_rounded, '/ai/approvals', Colors.redAccent),
                _buildCard(context, 'Workspace Memory', Icons.memory_rounded, '/ai/memory', Colors.teal),
                _buildCard(context, 'Platform Governance', Icons.gavel_rounded, '/ai/governance', Colors.indigoAccent),
                _buildCard(context, 'Learning Insights', Icons.trending_up_rounded, '/ai/learning-dashboard', Colors.limeAccent),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, IconData icon, String route, Color accentColor) {
    return InkWell(
      onTap: () => context.push(route),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF334155)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: accentColor, size: 36),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
