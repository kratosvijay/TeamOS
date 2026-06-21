import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class VoiceRoomScreen extends HookWidget {
  final String huddleId;
  const VoiceRoomScreen({super.key, required this.huddleId});

  @override
  Widget build(BuildContext context) {
    final isMuted = useState<bool>(false);
    final isVideoOn = useState<bool>(false);
    final isScreenSharing = useState<bool>(false);
    final connectionStatus = useState<String>('Connected'); // Connected, Connecting, Reconnecting

    // Mock participants with active speaking states
    final participants = useState<List<Map<String, dynamic>>>([
      {'name': 'Sarah Jenkins', 'isSpeaking': true, 'isMuted': false, 'role': 'Lead Designer'},
      {'name': 'Alex Martinez', 'isSpeaking': false, 'isMuted': true, 'role': 'Backend Engineer'},
      {'name': 'John Doe', 'isSpeaking': false, 'isMuted': false, 'role': 'Product Manager'},
      {'name': 'You', 'isSpeaking': false, 'isMuted': false, 'role': 'Fullstack Engineer'},
    ]);

    // Use a periodic timer to simulate active speakers (voice huddle activity)
    useEffect(() {
      final timer = Stream.periodic(const Duration(seconds: 3)).listen((_) {
        participants.value = participants.value.map((p) {
          if (p['name'] == 'You') return p;
          // Randomly toggle speaking indicator for other mock users
          final shouldSpeak = (p['name'] == 'Sarah Jenkins' && DateTime.now().second % 6 == 0) ||
              (p['name'] == 'John Doe' && DateTime.now().second % 4 == 0);
          return {...p, 'isSpeaking': shouldSpeak};
        }).toList();
      });
      return timer.cancel;
    }, const []);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Dev Sync Huddle', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(color: Colors.greenAccent, shape: BoxShape.circle),
                ),
                const SizedBox(width: 6),
                Text(
                  '${connectionStatus.value} • ${participants.value.length} in huddle',
                  style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                ),
              ],
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
            icon: const Icon(Icons.info_outline_rounded, color: Color(0xFF94A3B8)),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Participant Grid Area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: participants.value.length,
                  itemBuilder: (context, index) {
                    final p = participants.value[index];
                    final isSpeaking = p['isSpeaking'] as bool;
                    final pMuted = p['isMuted'] as bool;

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSpeaking ? Colors.greenAccent : const Color(0xFF334155),
                          width: isSpeaking ? 3 : 1.5,
                        ),
                        boxShadow: isSpeaking
                            ? [
                                BoxShadow(
                                  color: Colors.greenAccent.withOpacity(0.15),
                                  blurRadius: 12,
                                  spreadRadius: 2,
                                )
                              ]
                            : [],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Avatar with speaker wave
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  if (isSpeaking)
                                    const AnimatedWaveRing(),
                                  CircleAvatar(
                                    radius: 36,
                                    backgroundColor: isSpeaking
                                        ? const Color(0xFF059669)
                                        : const Color(0xFF334155),
                                    child: Text(
                                      (p['name'] as String).substring(0, 1),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                p['name'] as String,
                                style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                p['role'] as String,
                                style: const TextStyle(color: Color(0xFF64748B), fontSize: 11),
                              ),
                            ],
                          ),
                          // Top Right status icons
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Row(
                              children: [
                                if (pMuted)
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.redAccent,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.mic_off_rounded, color: Colors.white, size: 12),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            // Controls Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: const BoxDecoration(
                color: Color(0xFF1E293B),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Mute / Unmute Button
                  HuddleControlBtn(
                    icon: isMuted.value ? Icons.mic_off_rounded : Icons.mic_rounded,
                    color: isMuted.value ? Colors.redAccent : const Color(0xFF334155),
                    iconColor: Colors.white,
                    onTap: () {
                      isMuted.value = !isMuted.value;
                      // Update "You" status in participants list
                      participants.value = participants.value.map((p) {
                        if (p['name'] == 'You') {
                          return {...p, 'isMuted': isMuted.value};
                        }
                        return p;
                      }).toList();
                    },
                  ),

                  // Video Toggle Button
                  HuddleControlBtn(
                    icon: isVideoOn.value ? Icons.videocam_rounded : Icons.videocam_off_rounded,
                    color: isVideoOn.value ? Colors.blueAccent : const Color(0xFF334155),
                    iconColor: Colors.white,
                    onTap: () => isVideoOn.value = !isVideoOn.value,
                  ),

                  // Screen Share Button
                  HuddleControlBtn(
                    icon: isScreenSharing.value ? Icons.cancel_presentation_rounded : Icons.present_to_all_rounded,
                    color: isScreenSharing.value ? Colors.amberAccent : const Color(0xFF334155),
                    iconColor: isScreenSharing.value ? const Color(0xFF0F172A) : Colors.white,
                    onTap: () => isScreenSharing.value = !isScreenSharing.value,
                  ),

                  // Speaker Sound Toggle
                  HuddleControlBtn(
                    icon: Icons.volume_up_rounded,
                    color: const Color(0xFF334155),
                    iconColor: Colors.white,
                    onTap: () {},
                  ),

                  // Disconnect / Leave Button
                  HuddleControlBtn(
                    icon: Icons.call_end_rounded,
                    color: Colors.red,
                    iconColor: Colors.white,
                    onTap: () => context.pop(),
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

class HuddleControlBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color iconColor;
  final VoidCallback onTap;

  const HuddleControlBtn({
    super.key,
    required this.icon,
    required this.color,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Icon(icon, color: iconColor, size: 24),
      ),
    );
  }
}

class AnimatedWaveRing extends HookWidget {
  const AnimatedWaveRing({super.key});

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(
      duration: const Duration(seconds: 2),
    );

    useEffect(() {
      animationController.repeat();
      return null;
    }, const []);

    final scaleAnimation = useAnimation(
      Tween<double>(begin: 0.9, end: 1.6).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeOut),
      ),
    );

    final opacityAnimation = useAnimation(
      Tween<double>(begin: 0.6, end: 0.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeOut),
      ),
    );

    return Container(
      width: 72 * scaleAnimation,
      height: 72 * scaleAnimation,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.greenAccent.withOpacity(opacityAnimation),
          width: 3,
        ),
      ),
    );
  }
}
