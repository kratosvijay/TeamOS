import 'package:flutter/material.dart';

class Microsoft365Screen extends StatefulWidget {
  const Microsoft365Screen({super.key});

  @override
  State<Microsoft365Screen> createState() => _Microsoft365ScreenState();
}

class _Microsoft365ScreenState extends State<Microsoft365Screen> {
  bool _syncOutlook = true;
  bool _syncTeams = true;
  bool _syncOneDrive = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Microsoft 365 Settings', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Outlook Calendar Connections',
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
                      child: const Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Corporate Calendar Link', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              Text('ACTIVE', style: TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 32),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Microsoft 365 Capabilities',
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
                            title: const Text('Outlook Calendar Sync', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                            value: _syncOutlook,
                            activeColor: const Color(0xFF38BDF8),
                            onChanged: (val) {
                              setState(() {
                                _syncOutlook = val;
                              });
                            },
                          ),
                          const Divider(color: Color(0xFF334155), height: 24),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Teams Meeting Integrations', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                            value: _syncTeams,
                            activeColor: const Color(0xFF38BDF8),
                            onChanged: (val) {
                              setState(() {
                                _syncTeams = val;
                              });
                            },
                          ),
                          const Divider(color: Color(0xFF334155), height: 24),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('OneDrive Syncing', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                            value: _syncOneDrive,
                            activeColor: const Color(0xFF38BDF8),
                            onChanged: (val) {
                              setState(() {
                                _syncOneDrive = val;
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
