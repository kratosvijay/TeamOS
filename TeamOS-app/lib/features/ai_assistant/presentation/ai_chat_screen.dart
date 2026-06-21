import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class AIChatScreen extends HookWidget {
  final String conversationId;
  const AIChatScreen({super.key, required this.conversationId});

  @override
  Widget build(BuildContext context) {
    const activeConversationId = 'conv-441-alpha';
    final messages = useState<List<Map<String, String>>>([
      {'role': 'assistant', 'content': 'Hello! I am the TeamOS Coordinator Agent. How can I assist you with your tasks, sprints, or meetings today?'},
    ]);
    final chatController = useTextEditingController();
    final isGenerating = useState<bool>(false);

    void sendMessage() {
      final text = chatController.text.trim();
      if (text.isEmpty) return;

      messages.value = [
        ...messages.value,
        {'role': 'user', 'content': text},
      ];
      chatController.clear();
      isGenerating.value = true;

      // Simulate streaming chunks
      Future.delayed(const Duration(milliseconds: 1000), () {
        messages.value = [
          ...messages.value,
          {
            'role': 'assistant',
            'content': 'I have scanned our projects and meetings context. Here is the compiled information:\n\n'
                '1. Sprint 15 velocity is trending at 26 points.\n'
                '2. Standard incident runbooks are linked to tasks TOS-102.\n\n'
                '[Citations: Document: "Deployment Architecture", Meeting: "Sprint Review"]'
          },
        ];
        isGenerating.value = false;
      });
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: Text('AI Assistant - ${conversationId == 'new' ? activeConversationId : conversationId}',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: messages.value.length,
              itemBuilder: (context, index) {
                final msg = messages.value[index];
                final isUser = msg['role'] == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                    decoration: BoxDecoration(
                      color: isUser ? const Color(0xFF4F46E5) : const Color(0xFF1E293B),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: isUser ? const Radius.circular(16) : Radius.zero,
                        bottomRight: isUser ? Radius.zero : const Radius.circular(16),
                      ),
                      border: isUser ? null : Border.all(color: const Color(0xFF334155)),
                    ),
                    child: Text(
                      msg['content'] ?? '',
                      style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
                    ),
                  ),
                );
              },
            ),
          ),

          // Thinking state loading indicator
          if (isGenerating.value)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(color: Color(0xFF6366F1), strokeWidth: 2),
                  ),
                  SizedBox(width: 12),
                  Text('AI is thinking...', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
                ],
              ),
            ),

          // Input field
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            color: const Color(0xFF1E293B),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: chatController,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: const InputDecoration(
                      hintText: 'Ask AI about tasks, documents, or meetings...',
                      hintStyle: TextStyle(color: Color(0xFF64748B)),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send_rounded, color: Color(0xFF6366F1)),
                  onPressed: sendMessage,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
