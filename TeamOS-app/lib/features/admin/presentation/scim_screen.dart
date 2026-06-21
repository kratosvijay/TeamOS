import 'package:flutter/material.dart';

class ScimScreen extends StatefulWidget {
  const ScimScreen({super.key});

  @override
  State<ScimScreen> createState() => _ScimScreenState();
}

class _ScimScreenState extends State<ScimScreen> {
  final _tokenController = TextEditingController(text: 'scim-sync-token-eyj0exaioijkv1qilcjhbgcioijsuzi1niisin...');
  bool _syncEnabled = true;

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('SCIM Directory Sync', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'SCIM User Provisioning',
              style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Automatically provision, update, and de-provision users from Okta or Azure AD directories.',
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
            ),
            const SizedBox(height: 24),

            // Provision Config Card
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SwitchListTile(
                    title: const Text('Automated SCIM Provisioning', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: const Text('Allow directory synchronization via SCIM v2.0 protocol endpoints.', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
                    value: _syncEnabled,
                    activeColor: const Color(0xFF3B82F6),
                    inactiveTrackColor: const Color(0xFF334155),
                    onChanged: (val) {
                      setState(() {
                        _syncEnabled = val;
                      });
                    },
                  ),
                  const Divider(color: Color(0xFF334155), height: 32),
                  const Text(
                    'SCIM Connector Token',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _tokenController,
                    readOnly: true,
                    style: const TextStyle(color: Color(0xFF10B981), fontFamily: 'monospace'),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF0F172A),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.copy, color: Color(0xFF3B82F6)),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('SCIM token copied to clipboard')),
                          );
                        },
                      ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Use this token in your Okta or Azure AD SCIM connection header options.',
                    style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      const Icon(Icons.info_outline, color: Color(0xFF3B82F6), size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'SCIM Base URL: https://api.teamos.com/scim/v2/workspaces/your-workspace-id',
                          style: TextStyle(color: const Color(0xFF94A3B8).withOpacity(0.9), fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
