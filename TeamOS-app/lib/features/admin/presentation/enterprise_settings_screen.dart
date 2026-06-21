import 'package:flutter/material.dart';

class EnterpriseSettingsScreen extends StatefulWidget {
  const EnterpriseSettingsScreen({super.key});

  @override
  State<EnterpriseSettingsScreen> createState() => _EnterpriseSettingsScreenState();
}

class _EnterpriseSettingsScreenState extends State<EnterpriseSettingsScreen> {
  bool _enableTelemetry = true;
  bool _alertOnHighRisk = true;
  String _alertWebhookUrl = 'https://api.acme.com/alerts/webhook';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Enterprise Settings', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Global Settings',
              style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Configure workspace-wide parameters, system telemetry, and alert forwarding.',
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
            ),
            const SizedBox(height: 24),

            // Settings Card
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SwitchListTile(
                    title: const Text('Workspace Telemetry Enabled', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: const Text('Report system usage statistics anonymously for service health monitoring.', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                    value: _enableTelemetry,
                    activeColor: const Color(0xFF3B82F6),
                    inactiveTrackColor: const Color(0xFF334155),
                    onChanged: (val) {
                      setState(() {
                        _enableTelemetry = val;
                      });
                    },
                  ),
                  const Divider(color: Color(0xFF334155), height: 32),
                  SwitchListTile(
                    title: const Text('Alert on High Risk Actions', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: const Text('Generate warning notifications immediately if high-risk session metrics are triggered.', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                    value: _alertOnHighRisk,
                    activeColor: const Color(0xFF3B82F6),
                    inactiveTrackColor: const Color(0xFF334155),
                    onChanged: (val) {
                      setState(() {
                        _alertOnHighRisk = val;
                      });
                    },
                  ),
                  const Divider(color: Color(0xFF334155), height: 32),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Alert Forwarding Webhook URL',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      initialValue: _alertWebhookUrl,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF0F172A),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onChanged: (val) {
                        _alertWebhookUrl = val;
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Settings saved successfully')),
                );
              },
              icon: const Icon(Icons.save, color: Colors.white),
              label: const Text('Save Settings', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
