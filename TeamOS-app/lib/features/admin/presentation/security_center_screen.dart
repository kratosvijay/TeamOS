import 'package:flutter/material.dart';

class SecurityCenterScreen extends StatefulWidget {
  const SecurityCenterScreen({super.key});

  @override
  State<SecurityCenterScreen> createState() => _SecurityCenterScreenState();
}

class _SecurityCenterScreenState extends State<SecurityCenterScreen> {
  bool _requireMFA = true;
  bool _allowPasswordLogin = false;
  final TextEditingController _ipController = TextEditingController();
  final List<String> _ipAllowlist = ['192.168.1.1', '10.0.0.1', '172.16.0.4'];

  @override
  void dispose() {
    _ipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Security Center', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Workspace Security Policy',
              style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Enforce authentication standards, session limits, and access controls.',
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
            ),
            const SizedBox(height: 24),

            // MFA Card
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Require Multi-Factor Authentication', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: const Text('All members must verify via authenticator app or backup codes.', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
                    value: _requireMFA,
                    activeColor: const Color(0xFF3B82F6),
                    inactiveTrackColor: const Color(0xFF334155),
                    onChanged: (val) {
                      setState(() {
                        _requireMFA = val;
                      });
                    },
                  ),
                  const Divider(color: Color(0xFF334155), height: 32),
                  SwitchListTile(
                    title: const Text('Allow Password Login', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: const Text('If disabled, users can only authenticate via configured SSO provider.', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
                    value: _allowPasswordLogin,
                    activeColor: const Color(0xFF3B82F6),
                    inactiveTrackColor: const Color(0xFF334155),
                    onChanged: (val) {
                      setState(() {
                        _allowPasswordLogin = val;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // IP Allowlist Card
            const Text(
              'IP Access Allowlist',
              style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Only allow client requests from the specified list of corporate IP ranges.',
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _ipController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Enter corporate IP address (e.g. 192.168.1.1)',
                            hintStyle: const TextStyle(color: Color(0xFF64748B)),
                            filled: true,
                            fillColor: const Color(0xFF0F172A),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFF334155)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          if (_ipController.text.isNotEmpty) {
                            setState(() {
                              _ipAllowlist.add(_ipController.text);
                              _ipController.clear();
                            });
                          }
                        },
                        child: const Text('Add IP', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _ipAllowlist.map((ip) {
                      return Chip(
                        backgroundColor: const Color(0xFF334155),
                        label: Text(ip, style: const TextStyle(color: Colors.white)),
                        deleteIcon: const Icon(Icons.close, size: 16, color: Colors.red),
                        onDeleted: () {
                          setState(() {
                            _ipAllowlist.remove(ip);
                          });
                        },
                      );
                    }).toList(),
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
