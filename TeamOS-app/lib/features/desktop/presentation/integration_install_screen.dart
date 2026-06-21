import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class IntegrationInstallScreen extends StatefulWidget {
  final String integrationId;
  const IntegrationInstallScreen({super.key, required this.integrationId});

  @override
  State<IntegrationInstallScreen> createState() => _IntegrationInstallScreenState();
}

class _IntegrationInstallScreenState extends State<IntegrationInstallScreen> {
  final _formKey = GlobalKey<FormState>();
  String _clientId = '';
  String _clientSecret = '';
  String _webhookUrl = 'https://teamos.local/webhooks/incoming';
  bool _isConnecting = false;
  String _permissionLevel = 'READ_WRITE';

  String _getIntegrationName() {
    switch (widget.integrationId) {
      case 'github':
        return 'GitHub';
      case 'slack':
        return 'Slack';
      case 'google':
        return 'Google Workspace';
      case 'microsoft':
        return 'Microsoft 365';
      case 'gitlab':
        return 'GitLab';
      case 'bitbucket':
        return 'BitBucket';
      default:
        return widget.integrationId.toUpperCase();
    }
  }

  void _runSetup() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isConnecting = true;
      });
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _isConnecting = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: const Color(0xFF10B981),
              content: Text('${_getIntegrationName()} integration successfully installed! Initial sync running...'),
            ),
          );
          context.pop();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: Text('Install ${_getIntegrationName()}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          margin: const EdgeInsets.symmetric(vertical: 40),
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF334155)),
          ),
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add_to_photos, color: Color(0xFF38BDF8), size: 40),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Text(
                    'Configure Connection for ${_getIntegrationName()}',
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                const Center(
                  child: Text(
                    'Provide custom authorization keys to link resources securely.',
                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                  ),
                ),
                const SizedBox(height: 32),
                // Client ID
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Client ID / Application Key',
                    labelStyle: TextStyle(color: Color(0xFF64748B)),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF334155))),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF38BDF8))),
                  ),
                  validator: (val) => val == null || val.isEmpty ? 'Client ID is required' : null,
                  onSaved: (val) => _clientId = val ?? '',
                ),
                const SizedBox(height: 20),
                // Client Secret
                TextFormField(
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Client Secret / Private Access Key',
                    labelStyle: TextStyle(color: Color(0xFF64748B)),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF334155))),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF38BDF8))),
                  ),
                  validator: (val) => val == null || val.isEmpty ? 'Client Secret is required' : null,
                  onSaved: (val) => _clientSecret = val ?? '',
                ),
                const SizedBox(height: 20),
                // Callback URL Info
                TextFormField(
                  initialValue: _webhookUrl,
                  readOnly: true,
                  style: const TextStyle(color: Color(0xFF94A3B8)),
                  decoration: const InputDecoration(
                    labelText: 'OAuth / Webhook Callback URL',
                    labelStyle: TextStyle(color: Color(0xFF64748B)),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF334155))),
                  ),
                ),
                const SizedBox(height: 24),
                // RBAC permission
                DropdownButtonFormField<String>(
                  value: _permissionLevel,
                  dropdownColor: const Color(0xFF1E293B),
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Assigned Workspace Permission',
                    labelStyle: TextStyle(color: Color(0xFF64748B)),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF334155))),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'READ_ONLY', child: Text('READ_ONLY')),
                    DropdownMenuItem(value: 'READ_WRITE', child: Text('READ_WRITE')),
                    DropdownMenuItem(value: 'ADMIN', child: Text('ADMIN')),
                  ],
                  onChanged: (val) {
                    setState(() {
                      _permissionLevel = val ?? 'READ_WRITE';
                    });
                  },
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF38BDF8),
                    foregroundColor: const Color(0xFF0F172A),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: _isConnecting ? null : _runSetup,
                  child: _isConnecting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF0F172A)),
                        )
                      : const Text('Authorize & Install', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => context.pop(),
                  child: const Text('Cancel & Return', style: TextStyle(color: Color(0xFF64748B))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
