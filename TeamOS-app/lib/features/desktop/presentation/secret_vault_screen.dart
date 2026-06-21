import 'package:flutter/material.dart';

class SecretVaultScreen extends StatefulWidget {
  const SecretVaultScreen({super.key});

  @override
  State<SecretVaultScreen> createState() => _SecretVaultScreenState();
}

class _SecretVaultScreenState extends State<SecretVaultScreen> {
  final List<Map<String, dynamic>> _secrets = [
    {
      'key': 'GITHUB_OAUTH_TOKEN',
      'owner': 'Workspace Admin',
      'maskedValue': 'gho_••••••••••••••••••••••••••••••••3a8f',
      'algorithm': 'aes-256-cbc',
      'lastRotated': '10 days ago',
    },
    {
      'key': 'SLACK_BOT_TOKEN',
      'owner': 'Project Manager',
      'maskedValue': 'xoxb-••••••••••••••••••••••••••••••••89de',
      'algorithm': 'aes-256-cbc',
      'lastRotated': 'Yesterday',
    },
    {
      'key': 'AWS_ACCESS_KEY_SECRET',
      'owner': 'Workspace Admin',
      'maskedValue': '••••••••••••••••••••••••••••••••f9c1',
      'algorithm': 'aes-256-cbc',
      'lastRotated': '30 days ago',
    },
  ];

  bool _rotatingSecret = false;
  String _rotationMessage = '';

  void _rotateKeys() {
    setState(() {
      _rotatingSecret = true;
      _rotationMessage = '';
    });
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        setState(() {
          _rotatingSecret = false;
          _rotationMessage = 'Vault keys rotated successfully. All secrets re-encrypted using new master seed.';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Color(0xFF10B981),
            content: Text('Secret Vault keys rotated successfully.'),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Secrets Cryptography Vault', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(32),
        children: [
          Card(
            color: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Color(0xFF334155)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.shield_outlined, color: Color(0xFF38BDF8), size: 36),
                  ),
                  const SizedBox(width: 24),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AES-256-CBC Vault Active',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Workspace credentials are isolated and encrypted at rest. Raw keys are never exposed in log streams or UI dashboards.',
                          style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF38BDF8),
                      foregroundColor: const Color(0xFF0F172A),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    ),
                    icon: _rotatingSecret
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF0F172A)),
                          )
                        : const Icon(Icons.cached, size: 18),
                    label: const Text('Rotate Vault Seed', style: TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: _rotatingSecret ? null : _rotateKeys,
                  ),
                ],
              ),
            ),
          ),
          if (_rotationMessage.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF10B981)),
              ),
              child: Text(
                _rotationMessage,
                style: const TextStyle(color: Color(0xFF10B981), fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
          ],
          const SizedBox(height: 32),
          const Text(
            'Encrypted Secret Keys',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          // Secrets Table
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _secrets.length,
              separatorBuilder: (context, index) => const Divider(color: Color(0xFF334155), height: 1),
              itemBuilder: (context, index) {
                final secret = _secrets[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  title: Text(secret['key']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(secret['maskedValue']!, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13, fontFamily: 'monospace')),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Algorithm: ${secret['algorithm']}',
                        style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Rotated: ${secret['lastRotated']}',
                        style: const TextStyle(color: Color(0xFF64748B), fontSize: 11),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
