import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class MeetingSchedulerScreen extends HookWidget {
  const MeetingSchedulerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final titleController = useTextEditingController();
    final descriptionController = useTextEditingController();
    
    final selectedType = useState<String>('SPRINT_PLANNING');
    final selectedRecurrence = useState<String>('ONCE'); // ONCE, DAILY, WEEKLY, MONTHLY
    final selectedTimezone = useState<String>('IST');

    final meetingTypes = [
      {'value': 'INSTANT', 'label': 'Instant Huddle'},
      {'value': 'SCHEDULED', 'label': 'Scheduled Call'},
      {'value': 'VOICE_ONLY', 'label': 'Voice Huddle'},
      {'value': 'TASK_DISCUSSION', 'label': 'Task Discussion'},
      {'value': 'PROJECT_REVIEW', 'label': 'Project Review'},
      {'value': 'SPRINT_PLANNING', 'label': 'Sprint Planning Ceremony'},
      {'value': 'RETROSPECTIVE', 'label': 'Sprint Retrospective'},
    ];

    void handleSave() {
      if (titleController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a meeting title'), backgroundColor: Colors.redAccent),
        );
        return;
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Meeting scheduled successfully! Notifications dispatched.'), backgroundColor: Colors.green),
      );
      context.pop();
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Schedule Ceremony', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title Field
                const Text('MEETING TITLE', style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(
                  controller: titleController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'e.g. Sprint Kickoff',
                    hintStyle: const TextStyle(color: Color(0xFF64748B)),
                    filled: true,
                    fillColor: const Color(0xFF0F172A),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 24),

                // Description Field
                const Text('DESCRIPTION', style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(
                  controller: descriptionController,
                  maxLines: 3,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Agenda or guidelines...',
                    hintStyle: const TextStyle(color: Color(0xFF64748B)),
                    filled: true,
                    fillColor: const Color(0xFF0F172A),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 24),

                // Dropdowns row
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('CEREMONY TYPE', style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(12)),
                            child: DropdownButton<String>(
                              value: selectedType.value,
                              dropdownColor: const Color(0xFF1E293B),
                              underline: const SizedBox.shrink(),
                              isExpanded: true,
                              style: const TextStyle(color: Colors.white),
                              items: meetingTypes.map((t) {
                                return DropdownMenuItem(value: t['value'], child: Text(t['label']!));
                              }).toList(),
                              onChanged: (val) => selectedType.value = val!,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('RECURRENCE', style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(12)),
                            child: DropdownButton<String>(
                              value: selectedRecurrence.value,
                              dropdownColor: const Color(0xFF1E293B),
                              underline: const SizedBox.shrink(),
                              isExpanded: true,
                              style: const TextStyle(color: Colors.white),
                              items: const [
                                DropdownMenuItem(value: 'ONCE', child: Text('One-time')),
                                DropdownMenuItem(value: 'DAILY', child: Text('Daily Standup')),
                                DropdownMenuItem(value: 'WEEKLY', child: Text('Weekly Sync')),
                                DropdownMenuItem(value: 'MONTHLY', child: Text('Monthly Review')),
                              ],
                              onChanged: (val) => selectedRecurrence.value = val!,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Timezone & Duration
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('TIMEZONE', style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(12)),
                            child: DropdownButton<String>(
                              value: selectedTimezone.value,
                              dropdownColor: const Color(0xFF1E293B),
                              underline: const SizedBox.shrink(),
                              isExpanded: true,
                              style: const TextStyle(color: Colors.white),
                              items: const [
                                DropdownMenuItem(value: 'IST', child: Text('IST (GMT+5:30)')),
                                DropdownMenuItem(value: 'UTC', child: Text('UTC')),
                                DropdownMenuItem(value: 'EST', child: Text('EST (GMT-5:00)')),
                              ],
                              onChanged: (val) => selectedTimezone.value = val!,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('DURATION', style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                            width: double.infinity,
                            decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(12)),
                            child: const Text('45 Minutes', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => context.pop(),
                      child: const Text('Cancel', style: TextStyle(color: Color(0xFF94A3B8))),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B82F6),
                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: handleSave,
                      child: const Text('Save Schedule', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
