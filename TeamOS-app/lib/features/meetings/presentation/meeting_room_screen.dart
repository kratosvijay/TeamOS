import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

// Expandable panels inside the active meeting room workspace
enum ActivePanel {
  NONE,
  NOTES,
  ACTION_ITEMS,
  DECISIONS,
  TRANSCRIPT,
  WAITING_ROOM,
  BREAKOUT_ROOMS,
}

class MeetingRoomScreen extends HookWidget {
  final String meetingId;
  const MeetingRoomScreen({super.key, required this.meetingId});

  @override
  Widget build(BuildContext context) {
    final isMuted = useState<bool>(false);
    final isVideoOn = useState<bool>(true);
    final isScreenSharing = useState<bool>(false);
    final isHandRaised = useState<bool>(false);
    final isRecording = useState<bool>(false);
    
    final currentPanel = useState<ActivePanel>(ActivePanel.NONE);

    // Mock participants in room
    final participants = useState<List<Map<String, dynamic>>>([
      {'name': 'Sarah Jenkins', 'isSpeaking': true, 'videoOn': true, 'handRaised': false},
      {'name': 'Alex Martinez', 'isSpeaking': false, 'videoOn': false, 'handRaised': true},
      {'name': 'John Doe', 'isSpeaking': false, 'videoOn': true, 'handRaised': false},
      {'name': 'You', 'isSpeaking': false, 'videoOn': true, 'handRaised': false},
    ]);

    // Mock action items
    final actionItems = useState<List<String>>([
      'Migrate database schema before deployment (Assignee: Alex)',
      'Verify LiveKit Cloud credentials (Assignee: Sarah)',
    ]);

    // Mock decisions
    final decisions = useState<List<String>>([
      'Approve release candidate v1.2',
      'Move to self-hosted LiveKit in phase 2',
    ]);

    // Mock transcript
    final transcripts = useState<List<Map<String, String>>>([
      {'sender': 'Sarah Jenkins', 'text': 'Let\'s kick off the architecture review.', 'time': '10:01 AM'},
      {'sender': 'Alex Martinez', 'text': 'I updated schema.prisma and verified the client generation.', 'time': '10:02 AM'},
      {'sender': 'You', 'text': 'Awesome, I am configuring the MinIO storage bucket.', 'time': '10:03 AM'},
    ]);

    // Mock waiting room queue
    final waitingRoomQueue = useState<List<Map<String, String>>>([
      {'userId': 'usr-temp-1', 'name': 'External Vendor (Bob)'},
    ]);

    // Mock breakout rooms
    final breakoutRooms = useState<List<Map<String, dynamic>>>([
      {'id': 'b1', 'name': 'Frontend workshop', 'count': 0},
      {'id': 'b2', 'name': 'API refactoring', 'count': 0},
    ]);

    // Simulate speaking toggles periodically
    useEffect(() {
      final timer = Stream.periodic(const Duration(seconds: 4)).listen((_) {
        participants.value = participants.value.map((p) {
          if (p['name'] == 'You') return p;
          final isSpeaking = p['name'] == 'Sarah Jenkins' ? DateTime.now().second % 3 == 0 : DateTime.now().second % 5 == 0;
          return {...p, 'isSpeaking': isSpeaking};
        }).toList();
      });
      return timer.cancel;
    }, const []);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Dev Sync Room', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(width: 12),
            if (isRecording.value)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(6)),
                child: Row(
                  children: const [
                    Icon(Icons.fiber_manual_record_rounded, color: Colors.white, size: 10),
                    SizedBox(width: 4),
                    Text('REC', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
          ],
        ),
        backgroundColor: const Color(0xFF1E293B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.fiber_manual_record_rounded, color: isRecording.value ? Colors.red : const Color(0xFF94A3B8)),
            onPressed: () => isRecording.value = !isRecording.value,
            tooltip: isRecording.value ? 'Stop Recording' : 'Start Recording',
          ),
          IconButton(
            icon: const Icon(Icons.analytics_outlined, color: Colors.white),
            onPressed: () => context.push('/meetings/analytics/meet-active-1'),
            tooltip: 'Live Meeting Analytics',
          ),
        ],
      ),
      body: Row(
        children: [
          // Left Side: Video Grid Area
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.3,
                      ),
                      itemCount: participants.value.length,
                      itemBuilder: (context, index) {
                        final p = participants.value[index];
                        final hasVideo = p['videoOn'] as bool;
                        final isSpeaking = p['isSpeaking'] as bool;
                        final hasHandRaised = p['handRaised'] as bool;

                        return Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E293B),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSpeaking ? Colors.greenAccent : const Color(0xFF334155),
                              width: isSpeaking ? 3 : 1.5,
                            ),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              if (hasVideo)
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF334155),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Center(
                                    child: Icon(Icons.videocam_rounded, color: Colors.white.withOpacity(0.1), size: 64),
                                  ),
                                )
                              else
                                CircleAvatar(
                                  radius: 36,
                                  backgroundColor: const Color(0xFF475569),
                                  child: Text(
                                    (p['name'] as String).substring(0, 1),
                                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              // Bottom bar info overlay
                              Positioned(
                                bottom: 12,
                                left: 12,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), borderRadius: BorderRadius.circular(8)),
                                  child: Text(
                                    p['name'] as String,
                                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              // Hand raised badge overlay
                              if (hasHandRaised)
                                Positioned(
                                  top: 12,
                                  right: 12,
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: const BoxDecoration(color: Colors.amber, shape: BoxShape.circle),
                                    child: const Icon(Icons.front_hand_rounded, color: Color(0xFF0F172A), size: 16),
                                  ),
                                )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Bottom control panel bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                  color: const Color(0xFF1E293B),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Audio, video mute options
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(isMuted.value ? Icons.mic_off_rounded : Icons.mic_rounded),
                            color: isMuted.value ? Colors.redAccent : Colors.white,
                            onPressed: () {
                              isMuted.value = !isMuted.value;
                              participants.value = participants.value.map((p) {
                                if (p['name'] == 'You') {
                                  return {...p, 'isSpeaking': false};
                                }
                                return p;
                              }).toList();
                            },
                          ),
                          const SizedBox(width: 16),
                          IconButton(
                            icon: Icon(isVideoOn.value ? Icons.videocam_rounded : Icons.videocam_off_rounded),
                            color: isVideoOn.value ? Colors.blueAccent : Colors.white,
                            onPressed: () {
                              isVideoOn.value = !isVideoOn.value;
                              participants.value = participants.value.map((p) {
                                if (p['name'] == 'You') return {...p, 'videoOn': isVideoOn.value};
                                return p;
                              }).toList();
                            },
                          ),
                          const SizedBox(width: 16),
                          IconButton(
                            icon: Icon(isScreenSharing.value ? Icons.cancel_presentation_rounded : Icons.present_to_all_rounded),
                            color: isScreenSharing.value ? Colors.greenAccent : Colors.white,
                            onPressed: () => isScreenSharing.value = !isScreenSharing.value,
                          ),
                          const SizedBox(width: 16),
                          IconButton(
                            icon: Icon(Icons.front_hand_rounded, color: isHandRaised.value ? Colors.amber : Colors.white),
                            onPressed: () {
                              isHandRaised.value = !isHandRaised.value;
                              participants.value = participants.value.map((p) {
                                if (p['name'] == 'You') return {...p, 'handRaised': isHandRaised.value};
                                return p;
                              }).toList();
                            },
                          ),
                        ],
                      ),
                      // Tool belt panel selectors
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_note_rounded),
                            color: currentPanel.value == ActivePanel.NOTES ? const Color(0xFF3B82F6) : Colors.white,
                            onPressed: () => currentPanel.value = currentPanel.value == ActivePanel.NOTES ? ActivePanel.NONE : ActivePanel.NOTES,
                          ),
                          IconButton(
                            icon: const Icon(Icons.playlist_add_check_rounded),
                            color: currentPanel.value == ActivePanel.ACTION_ITEMS ? const Color(0xFF3B82F6) : Colors.white,
                            onPressed: () => currentPanel.value = currentPanel.value == ActivePanel.ACTION_ITEMS ? ActivePanel.NONE : ActivePanel.ACTION_ITEMS,
                          ),
                          IconButton(
                            icon: const Icon(Icons.gavel_rounded),
                            color: currentPanel.value == ActivePanel.DECISIONS ? const Color(0xFF3B82F6) : Colors.white,
                            onPressed: () => currentPanel.value = currentPanel.value == ActivePanel.DECISIONS ? ActivePanel.NONE : ActivePanel.DECISIONS,
                          ),
                          IconButton(
                            icon: const Icon(Icons.subtitles_rounded),
                            color: currentPanel.value == ActivePanel.TRANSCRIPT ? const Color(0xFF3B82F6) : Colors.white,
                            onPressed: () => currentPanel.value = currentPanel.value == ActivePanel.TRANSCRIPT ? ActivePanel.NONE : ActivePanel.TRANSCRIPT,
                          ),
                          IconButton(
                            icon: const Icon(Icons.people_outline_rounded),
                            color: currentPanel.value == ActivePanel.WAITING_ROOM ? const Color(0xFF3B82F6) : Colors.white,
                            onPressed: () => currentPanel.value = currentPanel.value == ActivePanel.WAITING_ROOM ? ActivePanel.NONE : ActivePanel.WAITING_ROOM,
                          ),
                          IconButton(
                            icon: const Icon(Icons.door_sliding_rounded),
                            color: currentPanel.value == ActivePanel.BREAKOUT_ROOMS ? const Color(0xFF3B82F6) : Colors.white,
                            onPressed: () => currentPanel.value = currentPanel.value == ActivePanel.BREAKOUT_ROOMS ? ActivePanel.NONE : ActivePanel.BREAKOUT_ROOMS,
                          ),
                        ],
                      ),
                      // Disconnect end meeting button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14)),
                        onPressed: () => context.pop(),
                        child: const Text('Leave', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          
          // Right Side: Workspace panels drawer
          if (currentPanel.value != ActivePanel.NONE)
            Container(
              width: 320,
              decoration: const BoxDecoration(
                color: Color(0xFF1E293B),
                border: Border(left: BorderSide(color: Color(0xFF334155))),
              ),
              child: _buildPanelContent(
                context,
                currentPanel.value,
                actionItems,
                decisions,
                transcripts,
                waitingRoomQueue,
                breakoutRooms,
              ),
            )
        ],
      ),
    );
  }

  // Helper mapping panel views
  Widget _buildPanelContent(
    BuildContext context,
    ActivePanel panel,
    ValueNotifier<List<String>> actionItems,
    ValueNotifier<List<String>> decisions,
    ValueNotifier<List<Map<String, String>>> transcripts,
    ValueNotifier<List<Map<String, String>>> waitingRoomQueue,
    ValueNotifier<List<Map<String, dynamic>>> breakoutRooms,
  ) {
    switch (panel) {
      case ActivePanel.NOTES:
        return const MeetingNotesPanel();
      case ActivePanel.ACTION_ITEMS:
        return MeetingActionItemsPanel(actionItems: actionItems);
      case ActivePanel.DECISIONS:
        return MeetingDecisionsPanel(decisions: decisions);
      case ActivePanel.TRANSCRIPT:
        return MeetingTranscriptPanel(transcripts: transcripts);
      case ActivePanel.WAITING_ROOM:
        return MeetingWaitingRoomPanel(queue: waitingRoomQueue);
      case ActivePanel.BREAKOUT_ROOMS:
        return MeetingBreakoutRoomsPanel(rooms: breakoutRooms);
      default:
        return const SizedBox.shrink();
    }
  }
}

// Sub panel widget components inside meeting room
class MeetingNotesPanel extends HookWidget {
  const MeetingNotesPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(text: '# Meeting Notes\n- Discussing sprint rollover\n- Allocating resources...');

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('COLLABORATIVE NOTES', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 16),
          Expanded(
            child: TextField(
              controller: controller,
              maxLines: null,
              style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 13, height: 1.5),
              decoration: const InputDecoration(border: InputBorder.none),
            ),
          )
        ],
      ),
    );
  }
}

class MeetingActionItemsPanel extends HookWidget {
  final ValueNotifier<List<String>> actionItems;
  const MeetingActionItemsPanel({super.key, required this.actionItems});

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();

    void addAction() {
      if (controller.text.trim().isEmpty) return;
      actionItems.value = [...actionItems.value, controller.text.trim()];
      controller.clear();
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('ACTION ITEMS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: actionItems.value.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(8)),
                  child: Text(actionItems.value[index], style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 12)),
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  decoration: InputDecoration(
                    hintText: 'New action item...',
                    hintStyle: const TextStyle(color: Color(0xFF64748B)),
                    filled: true,
                    fillColor: const Color(0xFF0F172A),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(onPressed: addAction, icon: const Icon(Icons.add_rounded, color: Color(0xFF3B82F6))),
            ],
          )
        ],
      ),
    );
  }
}

class MeetingDecisionsPanel extends HookWidget {
  final ValueNotifier<List<String>> decisions;
  const MeetingDecisionsPanel({super.key, required this.decisions});

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();

    void addDecision() {
      if (controller.text.trim().isEmpty) return;
      decisions.value = [...decisions.value, controller.text.trim()];
      controller.clear();
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('DECISION LOG', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: decisions.value.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(8)),
                  child: Text(decisions.value[index], style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 12)),
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  decoration: InputDecoration(
                    hintText: 'Log decision...',
                    hintStyle: const TextStyle(color: Color(0xFF64748B)),
                    filled: true,
                    fillColor: const Color(0xFF0F172A),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(onPressed: addDecision, icon: const Icon(Icons.add_rounded, color: Color(0xFF3B82F6))),
            ],
          )
        ],
      ),
    );
  }
}

class MeetingTranscriptPanel extends HookWidget {
  final ValueNotifier<List<Map<String, String>>> transcripts;
  const MeetingTranscriptPanel({super.key, required this.transcripts});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('REALTIME TRANSCRIPT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: transcripts.value.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final tx = transcripts.value[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(tx['sender']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                        Text(tx['time']!, style: const TextStyle(color: Color(0xFF64748B), fontSize: 9)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(tx['text']!, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class MeetingWaitingRoomPanel extends HookWidget {
  final ValueNotifier<List<Map<String, String>>> queue;
  const MeetingWaitingRoomPanel({super.key, required this.queue});

  @override
  Widget build(BuildContext context) {
    void handleAdmission(String id, bool approve) {
      queue.value = queue.value.where((q) => q['userId'] != id).toList();
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('WAITING ROOM QUEUE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 16),
          Expanded(
            child: queue.value.isEmpty
                ? const Center(child: Text('No guests waiting', style: TextStyle(color: Color(0xFF64748B), fontSize: 12)))
                : ListView.separated(
                    itemCount: queue.value.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final guest = queue.value[index];
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text(guest['name']!, style: const TextStyle(color: Colors.white, fontSize: 12))),
                            Row(
                              children: [
                                IconButton(icon: const Icon(Icons.check, color: Colors.greenAccent), onPressed: () => handleAdmission(guest['userId']!, true)),
                                IconButton(icon: const Icon(Icons.close, color: Colors.redAccent), onPressed: () => handleAdmission(guest['userId']!, false)),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
}

class MeetingBreakoutRoomsPanel extends HookWidget {
  final ValueNotifier<List<Map<String, dynamic>>> rooms;
  const MeetingBreakoutRoomsPanel({super.key, required this.rooms});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('BREAKOUT ALLOCATION', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: rooms.value.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final r = rooms.value[index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(r['name'] as String, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF334155)),
                        onPressed: () {},
                        child: const Text('Move to', style: TextStyle(color: Colors.white)),
                      )
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
