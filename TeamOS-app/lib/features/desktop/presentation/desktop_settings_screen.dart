import 'package:flutter/material.dart';
import '../services/local_cache_service.dart';
import '../services/sync_metrics.dart';

class DesktopSettingsScreen extends StatefulWidget {
  const DesktopSettingsScreen({super.key});

  @override
  State<DesktopSettingsScreen> createState() => _DesktopSettingsScreenState();
}

class _DesktopSettingsScreenState extends State<DesktopSettingsScreen> {
  bool _enableSync = true;
  bool _autoCompact = true;
  bool _detachedWindows = false;
  String _syncInterval = '10 seconds';

  Future<void> _clearCache() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0F172A),
        title: const Text('Clear SQLite cache?', style: TextStyle(color: Colors.white)),
        content: const Text(
          'This will purge all locally cached tasks, projects, document metadata, and timeline logs. Offline mutations will NOT be lost.',
          style: TextStyle(color: Color(0xFF94A3B8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF43F5E)),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Clear Cache', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await LocalCacheService().clearAll();
      await SyncMetrics().reset();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully cleared SQLite Cache & Sync Metrics')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Desktop Settings', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(32),
        children: [
          const Text(
            'Offline Synchronization Settings',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildSwitchTile(
            title: 'Enable Background Synchronization',
            subtitle: 'Automatically sync offline changes when connectivity is restored',
            value: _enableSync,
            onChanged: (val) {
              setState(() {
                _enableSync = val;
              });
            },
          ),
          _buildDropdownTile(
            title: 'Synchronization Check Interval',
            subtitle: 'Frequency to run background mutations check and ping server',
            value: _syncInterval,
            items: ['5 seconds', '10 seconds', '30 seconds', '1 minute', '5 minutes'],
            onChanged: (val) {
              setState(() {
                _syncInterval = val ?? '10 seconds';
              });
            },
          ),
          _buildSwitchTile(
            title: 'Auto Compact Journal',
            subtitle: 'Purge SyncJournal audit trails older than 30 days automatically',
            value: _autoCompact,
            onChanged: (val) {
              setState(() {
                _autoCompact = val;
              });
            },
          ),
          const SizedBox(height: 32),
          const Divider(color: Color(0xFF334155)),
          const SizedBox(height: 32),
          const Text(
            'Multi-Window Support (Experimental)',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildSwitchTile(
            title: 'Detached Windows',
            subtitle: 'Allow chat rooms, notes, and dashboards to launch in separate desktop windows',
            value: _detachedWindows,
            onChanged: (val) {
              setState(() {
                _detachedWindows = val;
              });
            },
          ),
          const SizedBox(height: 32),
          const Divider(color: Color(0xFF334155)),
          const SizedBox(height: 32),
          const Text(
            'System Diagnostics & Cache',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Card(
            color: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Color(0xFF334155)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Local Cache Management',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Purging the cache will clear all offline-cached records. If you are experiencing out-of-sync tasks or missing documents, clearing the local SQLite simulator will force the client to fetch fresh items on reconnect.',
                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13, height: 1.4),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF43F5E).withOpacity(0.12),
                      side: const BorderSide(color: Color(0xFFF43F5E)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    icon: const Icon(Icons.delete_sweep, color: Color(0xFFF43F5E)),
                    label: const Text('Purge SQLite Simulator Cache', style: TextStyle(color: Color(0xFFF43F5E), fontWeight: FontWeight.bold)),
                    onPressed: _clearCache,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: ListTile(
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(subtitle, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF38BDF8),
        ),
      ),
    );
  }

  Widget _buildDropdownTile({
    required String title,
    required String subtitle,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: ListTile(
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(subtitle, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
        trailing: DropdownButton<String>(
          value: value,
          dropdownColor: const Color(0xFF1E293B),
          style: const TextStyle(color: Colors.white, fontSize: 13),
          underline: Container(),
          icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF38BDF8)),
          items: items.map((e) {
            return DropdownMenuItem<String>(
              value: e,
              child: Text(e),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
