import 'package:flutter/material.dart';

class GoogleWorkspaceScreen extends StatefulWidget {
  const GoogleWorkspaceScreen({super.key});

  @override
  State<GoogleWorkspaceScreen> createState() => _GoogleWorkspaceScreenState();
}

class _GoogleWorkspaceScreenState extends State<GoogleWorkspaceScreen> {
  bool _syncCalendar = true;
  bool _syncMeetLink = true;
  bool _syncDocsIndex = true;
  bool _importingDoc = false;

  final List<Map<String, String>> _linkedCalendars = [
    {'name': 'Work & Sprint Events (primary)', 'status': 'Synced', 'events': '21 events/week'},
    {'name': 'Client Demos & Releases', 'status': 'Synced', 'events': '4 events/week'},
  ];

  void _importGoogleDoc() {
    setState(() {
      _importingDoc = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _importingDoc = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Color(0xFF10B981),
            content: Text('Successfully imported Google Doc "Q3 Product Architecture Spec" into Wiki Documents Space.'),
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
        title: const Text('Google Workspace Settings', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(32),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main Options
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Linked Google Calendars',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF334155)),
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _linkedCalendars.length,
                        separatorBuilder: (context, index) => const Divider(color: Color(0xFF334155), height: 1),
                        itemBuilder: (context, index) {
                          final cal = _linkedCalendars[index];
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                            leading: const Icon(Icons.calendar_today, color: Color(0xFF38BDF8)),
                            title: Text(cal['name']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            subtitle: Text(cal['events']!, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981).withOpacity(0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                cal['status']!,
                                style: const TextStyle(color: Color(0xFF10B981), fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Google Docs & Drive Importer',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF334155)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Import documents from Google Drive and sync changes directly into the TeamOS Wiki knowledge graph.',
                            style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13, height: 1.4),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF38BDF8),
                              foregroundColor: const Color(0xFF0F172A),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            icon: _importingDoc
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF0F172A)),
                                  )
                                : const Icon(Icons.drive_file_move, size: 18),
                            label: const Text('Simulate Google Drive Import', style: TextStyle(fontWeight: FontWeight.bold)),
                            onPressed: _importingDoc ? null : _importGoogleDoc,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 32),
              // Side Toggles
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sync Capabilities',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF334155)),
                      ),
                      child: Column(
                        children: [
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Auto-sync Calendar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                            subtitle: const Text('Generate TeamOS Rooms for calendar links', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                            value: _syncCalendar,
                            activeColor: const Color(0xFF38BDF8),
                            onChanged: (val) {
                              setState(() {
                                _syncCalendar = val;
                              });
                            },
                          ),
                          const Divider(color: Color(0xFF334155), height: 24),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Link Google Meet', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                            subtitle: const Text('Attach Meet fallback links to audio huddles', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                            value: _syncMeetLink,
                            activeColor: const Color(0xFF38BDF8),
                            onChanged: (val) {
                              setState(() {
                                _syncMeetLink = val;
                              });
                            },
                          ),
                          const Divider(color: Color(0xFF334155), height: 24),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Index Drive in Search', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                            subtitle: const Text('Index imported docs for hybrid semantic search', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                            value: _syncDocsIndex,
                            activeColor: const Color(0xFF38BDF8),
                            onChanged: (val) {
                              setState(() {
                                _syncDocsIndex = val;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
