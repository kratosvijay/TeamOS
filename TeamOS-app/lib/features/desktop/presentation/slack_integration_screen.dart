import 'package:flutter/material.dart';

class SlackIntegrationScreen extends StatefulWidget {
  const SlackIntegrationScreen({super.key});

  @override
  State<SlackIntegrationScreen> createState() => _SlackIntegrationScreenState();
}

class _SlackIntegrationScreenState extends State<SlackIntegrationScreen> {
  bool _syncChannels = true;
  bool _broadcastAlerts = true;
  bool _aiBroadcastSummaries = true;

  final List<Map<String, String>> _mappedChannels = [
    {'teamos': '#development', 'slack': '#teamos-dev', 'sync': 'Bi-directional'},
    {'teamos': '#general', 'slack': '#teamos-announcements', 'sync': 'TeamOS -> Slack'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Slack Connector Settings', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                      'Mapped Chat Channels',
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
                        itemCount: _mappedChannels.length,
                        separatorBuilder: (context, index) => const Divider(color: Color(0xFF334155), height: 1),
                        itemBuilder: (context, index) {
                          final channel = _mappedChannels[index];
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                            leading: const Icon(Icons.link, color: Color(0xFF38BDF8)),
                            title: Text('${channel['teamos']} ⟷ ${channel['slack']}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            subtitle: Text('Sync direction: ${channel['sync']}', style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline, color: Color(0xFFF43F5E)),
                              onPressed: () {},
                            ),
                          );
                        },
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
                      'Slack Notifications Bot',
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
                            title: const Text('Bi-directional Channel Sync', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                            value: _syncChannels,
                            activeColor: const Color(0xFF38BDF8),
                            onChanged: (val) {
                              setState(() {
                                _syncChannels = val;
                              });
                            },
                          ),
                          const Divider(color: Color(0xFF334155), height: 24),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Broadcast Sprint Alerts', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                            value: _broadcastAlerts,
                            activeColor: const Color(0xFF38BDF8),
                            onChanged: (val) {
                              setState(() {
                                _broadcastAlerts = val;
                              });
                            },
                          ),
                          const Divider(color: Color(0xFF334155), height: 24),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Broadcast AI Summaries', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                            value: _aiBroadcastSummaries,
                            activeColor: const Color(0xFF38BDF8),
                            onChanged: (val) {
                              setState(() {
                                _aiBroadcastSummaries = val;
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
