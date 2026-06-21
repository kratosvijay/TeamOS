import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProjectDetailsScreen extends StatelessWidget {
  final String projectId;
  const ProjectDetailsScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Project Resources', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1E293B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => context.go('/projects'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Head card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Engineering Core OS',
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Key: ECO | Active Members: 8 developers',
                    style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Central backend services repositories, hosting API logic gateways, background BullMQ worker routines, database migrations, and telemetry agents.',
                    style: TextStyle(color: Color(0xFF94A3B8)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Provisioned Project Resources',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            // Resources Grid list
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: [
                buildResourceCard(
                  title: 'Project Chat',
                  icon: Icons.chat_bubble_outline_rounded,
                  details: '#project-chat channel',
                  color: Colors.greenAccent,
                ),
                buildResourceCard(
                  title: 'Meeting Standup',
                  icon: Icons.video_camera_back_rounded,
                  details: 'LiveKit Room Allocated',
                  color: Colors.blueAccent,
                ),
                buildResourceCard(
                  title: 'Wiki Docs Workspace',
                  icon: Icons.article_outlined,
                  details: 'DocSpace: Wiki Home',
                  color: Colors.amberAccent,
                ),
                buildResourceCard(
                  title: 'MinIO Storage Prefix',
                  icon: Icons.folder_zip_outlined,
                  details: 'prefix: /projects/eco/',
                  color: Colors.purpleAccent,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildResourceCard({
    required String title,
    required IconData icon,
    required String details,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Icon(icon, color: color),
            ],
          ),
          Text(details, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
        ],
      ),
    );
  }
}
