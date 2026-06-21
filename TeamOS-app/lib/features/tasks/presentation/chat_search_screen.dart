import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class ChatSearchScreen extends HookWidget {
  const ChatSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = useTextEditingController();
    final selectedFilter = useState<String>('ALL'); // ALL, CHANNELS, DMS, Senders
    final results = useState<List<Map<String, dynamic>>>([]);
    final isSearching = useState<bool>(false);

    // Mock index of chat history for search
    final mockHistory = [
      {
        'sender': 'Sarah Jenkins',
        'content': 'We need to migrate database schema first. Did you run the prisma generate command?',
        'room': 'announcements',
        'time': '10:14 AM',
        'type': 'CHANNEL',
        'path': '/chat/channel/announcements',
      },
      {
        'sender': 'Alex Martinez',
        'content': 'Yes, prisma generate completed successfully. Compiling the NestJS backend has no errors now.',
        'room': 'general',
        'time': '10:16 AM',
        'type': 'CHANNEL',
        'path': '/chat/channel/general',
      },
      {
        'sender': 'John Doe',
        'content': 'FCM credentials and BullMQ provisioning workers are fully operational in the background.',
        'room': 'general',
        'time': '10:20 AM',
        'type': 'CHANNEL',
        'path': '/chat/channel/general',
      },
      {
        'sender': 'Sarah Jenkins',
        'content': 'Hey, did you look at the velocity report? We are averaging 13 story points.',
        'room': 'Sarah Jenkins',
        'time': 'Yesterday',
        'type': 'DM',
        'path': '/chat/dm/Sarah Jenkins',
      },
    ];

    void performSearch(String query) {
      if (query.trim().isEmpty) {
        results.value = [];
        return;
      }
      isSearching.value = true;
      
      // Simulate network lag / OpenSearch query response
      Future.delayed(const Duration(milliseconds: 300), () {
        final queryLower = query.toLowerCase();
        final matched = mockHistory.where((msg) {
          final contentMatch = (msg['content'] as String).toLowerCase().contains(queryLower);
          final senderMatch = (msg['sender'] as String).toLowerCase().contains(queryLower);
          final roomMatch = (msg['room'] as String).toLowerCase().contains(queryLower);

          if (!contentMatch && !senderMatch && !roomMatch) return false;

          if (selectedFilter.value == 'CHANNELS') return msg['type'] == 'CHANNEL';
          if (selectedFilter.value == 'DMS') return msg['type'] == 'DM';
          
          return true;
        }).toList();

        results.value = matched;
        isSearching.value = false;
      });
    }

    // Trigger search when filter changes
    useEffect(() {
      performSearch(searchController.text);
      return null;
    }, [selectedFilter.value]);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Search Messages', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1E293B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          // Search Input Area
          Container(
            padding: const EdgeInsets.all(20),
            color: const Color(0xFF1E293B),
            child: Column(
              children: [
                TextField(
                  controller: searchController,
                  style: const TextStyle(color: Colors.white),
                  onChanged: performSearch,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Search for messages, files, or people...',
                    hintStyle: const TextStyle(color: Color(0xFF64748B)),
                    prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF64748B)),
                    suffixIcon: searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close_rounded, color: Color(0xFF64748B)),
                            onPressed: () {
                              searchController.clear();
                              performSearch('');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: const Color(0xFF0F172A),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Filter chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      FilterChipWidget(
                        label: 'All Results',
                        isSelected: selectedFilter.value == 'ALL',
                        onTap: () => selectedFilter.value = 'ALL',
                      ),
                      const SizedBox(width: 8),
                      FilterChipWidget(
                        label: 'Channels',
                        isSelected: selectedFilter.value == 'CHANNELS',
                        onTap: () => selectedFilter.value = 'CHANNELS',
                      ),
                      const SizedBox(width: 8),
                      FilterChipWidget(
                        label: 'DMs Only',
                        isSelected: selectedFilter.value == 'DMS',
                        onTap: () => selectedFilter.value = 'DMS',
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

          // Search Results
          Expanded(
            child: isSearching.value
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF3B82F6)),
                  )
                : results.value.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              searchController.text.isEmpty
                                  ? Icons.search_rounded
                                  : Icons.search_off_rounded,
                              size: 64,
                              color: const Color(0xFF334155),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              searchController.text.isEmpty
                                  ? 'Type something to search'
                                  : 'No matches found',
                              style: const TextStyle(color: Color(0xFF64748B), fontSize: 15),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(24),
                        itemCount: results.value.length,
                        separatorBuilder: (context, index) => const Divider(color: Color(0xFF1E293B), height: 32),
                        itemBuilder: (context, index) {
                          final item = results.value[index];
                          final isDm = item['type'] == 'DM';

                          return InkWell(
                            onTap: () => context.push(item['path'] as String),
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: isDm ? const Color(0xFF0369A1) : const Color(0xFF1E293B),
                                    radius: 18,
                                    child: Icon(
                                      isDm ? Icons.person_rounded : Icons.tag_rounded,
                                      color: isDm ? Colors.lightBlueAccent : const Color(0xFF94A3B8),
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              item['sender'] as String,
                                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                            ),
                                            Text(
                                              item['time'] as String,
                                              style: const TextStyle(color: Color(0xFF64748B), fontSize: 11),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Text(
                                              isDm ? 'Direct Message' : '#${item['room']}',
                                              style: const TextStyle(
                                                color: Color(0xFF3B82F6),
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          item['content'] as String,
                                          style: const TextStyle(
                                            color: Color(0xFFCBD5E1),
                                            fontSize: 13,
                                            height: 1.4,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class FilterChipWidget extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const FilterChipWidget({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFF0F172A),
          border: Border.all(
            color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFF334155),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF94A3B8),
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
