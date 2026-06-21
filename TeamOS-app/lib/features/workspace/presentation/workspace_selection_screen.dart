import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WorkspaceSelectionScreen extends StatelessWidget {
  const WorkspaceSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock user workspaces
    final workspaces = [
      {'id': '1', 'name': 'Engineering OS', 'slug': 'engineering', 'role': 'ADMIN'},
      {'id': '2', 'name': 'Product Design Hub', 'slug': 'product-design', 'role': 'OWNER'},
      {'id': '3', 'name': 'Acme Corp', 'slug': 'acme', 'role': 'DEVELOPER'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.space_dashboard_rounded,
                size: 50,
                color: Color(0xFF3B82F6),
              ),
              const SizedBox(height: 16),
              const Text(
                'Select Workspace',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 8),
              const Text(
                'Choose a tenant workspace to launch collaboration panels',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 32),
              
              // Workspace Grid List
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: workspaces.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final ws = workspaces[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF334155)),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      leading: CircleAvatar(
                        backgroundColor: const Color(0xFF3B82F6).withOpacity(0.2),
                        child: Text(
                          ws['name']![0],
                          style: const TextStyle(color: Color(0xFF3B82F6), fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(ws['name']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      subtitle: Text('/${ws['slug']!}', style: const TextStyle(color: Color(0xFF64748B))),
                      trailing: Chip(
                        label: Text(ws['role']!, style: const TextStyle(fontSize: 11, color: Colors.white)),
                        backgroundColor: const Color(0xFF334155),
                      ),
                      onTap: () {
                        // Secure workspace settings cached locally and navigate to dashboard
                        context.go('/dashboard');
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
              
              // Launch Wizard
              OutlinedButton.icon(
                onPressed: () => context.push('/workspace-setup'),
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text('Create New Workspace', style: TextStyle(color: Colors.white)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF3B82F6)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
