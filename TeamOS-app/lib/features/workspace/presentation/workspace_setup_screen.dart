import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class WorkspaceSetupScreen extends HookWidget {
  const WorkspaceSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentStep = useState(0);
    final workspaceName = useTextEditingController();
    final logoUrl = useTextEditingController();
    final memberEmail = useTextEditingController();
    final invitedEmails = useState<List<String>>([]);

    Widget buildStepContent() {
      switch (currentStep.value) {
        case 0:
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Step 1: Workspace Name',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 8),
              const Text('What is the name of your company or team workspace?', style: TextStyle(color: Color(0xFF94A3B8))),
              const SizedBox(height: 24),
              TextField(
                controller: workspaceName,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Workspace Name',
                  labelStyle: const TextStyle(color: Color(0xFF64748B)),
                  filled: true,
                  fillColor: const Color(0xFF1E293B),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
            ],
          );
        case 1:
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Step 2: Workspace Logo',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 8),
              const Text('Add a logo image URL to brand your workspace.', style: TextStyle(color: Color(0xFF94A3B8))),
              const SizedBox(height: 24),
              TextField(
                controller: logoUrl,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Logo Image URL (Optional)',
                  labelStyle: const TextStyle(color: Color(0xFF64748B)),
                  filled: true,
                  fillColor: const Color(0xFF1E293B),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
            ],
          );
        case 2:
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Step 3: Invite Team Members',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 8),
              const Text('Invite team members by email to start collaborating.', style: TextStyle(color: Color(0xFF94A3B8))),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: memberEmail,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                        labelStyle: const TextStyle(color: Color(0xFF64748B)),
                        filled: true,
                        fillColor: const Color(0xFF1E293B),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: () {
                      if (memberEmail.text.trim().isNotEmpty) {
                        invitedEmails.value = [...invitedEmails.value, memberEmail.text.trim()];
                        memberEmail.clear();
                      }
                    },
                    style: IconButton.styleFrom(backgroundColor: const Color(0xFF3B82F6)),
                    icon: const Icon(Icons.add),
                  )
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children: invitedEmails.value.map((email) {
                  return Chip(
                    label: Text(email, style: const TextStyle(color: Colors.white)),
                    backgroundColor: const Color(0xFF1E293B),
                    deleteIconColor: Colors.redAccent,
                    onDeleted: () {
                      invitedEmails.value = invitedEmails.value.where((e) => e != email).toList();
                    },
                  );
                }).toList(),
              ),
            ],
          );
        case 3:
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Step 4: Review & Create',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 8),
              const Text('Confirm your details before creation.', style: TextStyle(color: Color(0xFF94A3B8))),
              const SizedBox(height: 24),
              ListTile(
                title: const Text('Workspace Name', style: TextStyle(color: Color(0xFF64748B))),
                subtitle: Text(workspaceName.text, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              ListTile(
                title: const Text('Logo URL', style: TextStyle(color: Color(0xFF64748B))),
                subtitle: Text(logoUrl.text.isEmpty ? 'Default Brand Icon' : logoUrl.text, style: const TextStyle(color: Colors.white)),
              ),
              ListTile(
                title: const Text('Invited Members', style: TextStyle(color: Color(0xFF64748B))),
                subtitle: Text('${invitedEmails.value.length} team members will be invited', style: const TextStyle(color: Colors.white)),
              ),
            ],
          );
        default:
          return const SizedBox.shrink();
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Workspace Setup Wizard', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Progress indicator dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  return Container(
                    width: 12,
                    height: 12,
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: currentStep.value == index
                          ? const Color(0xFF3B82F6)
                          : const Color(0xFF334155),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 40),
              buildStepContent(),
              const SizedBox(height: 40),
              
              // Navigation buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (currentStep.value > 0)
                    OutlinedButton(
                      onPressed: () => currentStep.value--,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF334155)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: const Text('Back', style: TextStyle(color: Colors.white)),
                    )
                  else
                    const SizedBox.shrink(),
                  
                  ElevatedButton(
                    onPressed: () {
                      if (currentStep.value < 3) {
                        if (currentStep.value == 0 && workspaceName.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Workspace name is required')),
                          );
                          return;
                        }
                        currentStep.value++;
                      } else {
                        // Create Workspace API trigger and redirect to selection
                        context.go('/dashboard');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: Text(
                      currentStep.value == 3 ? 'Create Workspace' : 'Continue',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
