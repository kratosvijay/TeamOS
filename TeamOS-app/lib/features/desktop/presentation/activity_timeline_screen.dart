import 'package:flutter/material.dart';
import '../services/local_cache_service.dart';

class ActivityTimelineScreen extends StatefulWidget {
  const ActivityTimelineScreen({super.key});

  @override
  State<ActivityTimelineScreen> createState() => _ActivityTimelineScreenState();
}

class _ActivityTimelineScreenState extends State<ActivityTimelineScreen> {
  List<Map<String, dynamic>> _timelineItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTimeline();
  }

  Future<void> _loadTimeline() async {
    final cache = LocalCacheService();
    final cachedItems = await cache.getActivityTimeline();

    if (cachedItems.isEmpty) {
      // Seed some demo timeline items to avoid empty UI
      final now = DateTime.now();
      final list = [
        {
          'id': 'a-1',
          'action': 'TASK_CREATE',
          'entityType': 'Task',
          'entityTitle': 'Configure pgvector HNSW Index',
          'actorName': 'Sarah Connor',
          'createdAt': now.subtract(const Duration(minutes: 15)).toIso8601String(),
        },
        {
          'id': 'a-2',
          'action': 'DOCUMENT_UPDATE',
          'entityType': 'Document',
          'entityTitle': 'Offline Resumable Sync Architecture',
          'actorName': 'John Doe',
          'createdAt': now.subtract(const Duration(hours: 1)).toIso8601String(),
        },
        {
          'id': 'a-3',
          'action': 'MEETING_END',
          'entityType': 'Meeting',
          'entityTitle': 'Phase 12 Architecture Review',
          'actorName': 'Alex Mercer',
          'createdAt': now.subtract(const Duration(hours: 3)).toIso8601String(),
        },
        {
          'id': 'a-4',
          'action': 'COMMENT_ADD',
          'entityType': 'Comment',
          'entityTitle': 'Added a query optimizing tip to KanbanBoardView',
          'actorName': 'Sarah Connor',
          'createdAt': now.subtract(const Duration(days: 1)).toIso8601String(),
        },
      ];

      for (var item in list) {
        await cache.addTimelineItem(item);
      }
      _timelineItems = list;
    } else {
      _timelineItems = cachedItems;
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Activity Timeline', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF38BDF8)),
            onPressed: () {
              setState(() {
                _isLoading = true;
              });
              _loadTimeline();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF38BDF8)))
          : _timelineItems.isEmpty
              ? const Center(
                  child: Text(
                    'No timeline activities recorded yet',
                    style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(32),
                  itemCount: _timelineItems.length,
                  itemBuilder: (context, index) {
                    final item = _timelineItems[index];
                    final isLast = index == _timelineItems.length - 1;

                    return IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Timeline indicator
                          Column(
                            children: [
                              Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: _getActionColor(item['action']),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: _getActionColor(item['action']).withOpacity(0.4),
                                      blurRadius: 6,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                              if (!isLast)
                                Expanded(
                                  child: Container(
                                    width: 2,
                                    color: const Color(0xFF334155),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(width: 24),
                          // Content Card
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 24.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1E293B),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFF334155)),
                                ),
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          _getActionLabel(item['action']),
                                          style: TextStyle(
                                            color: _getActionColor(item['action']),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          _formatDate(item['createdAt']),
                                          style: const TextStyle(color: Color(0xFF64748B), fontSize: 11),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      item['entityTitle'] ?? 'Untitled Entity Update',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(Icons.person, color: Color(0xFF64748B), size: 14),
                                        const SizedBox(width: 6),
                                        Text(
                                          item['actorName'] ?? 'Unknown User',
                                          style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                                        ),
                                        const Spacer(),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF0F172A),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            item['entityType'].toString().toUpperCase(),
                                            style: const TextStyle(color: Color(0xFF64748B), fontSize: 10),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }

  Color _getActionColor(String? action) {
    switch (action) {
      case 'TASK_CREATE':
        return const Color(0xFF38BDF8); // blue
      case 'DOCUMENT_UPDATE':
        return const Color(0xFF34D399); // green
      case 'MEETING_END':
        return const Color(0xFFFB7185); // pink
      case 'COMMENT_ADD':
        return const Color(0xFFFBBF24); // amber
      default:
        return const Color(0xFF94A3B8); // gray
    }
  }

  String _getActionLabel(String? action) {
    switch (action) {
      case 'TASK_CREATE':
        return 'TASK CREATED';
      case 'DOCUMENT_UPDATE':
        return 'WIKI UPDATED';
      case 'MEETING_END':
        return 'MEETING ENDED';
      case 'COMMENT_ADD':
        return 'COMMENT ADDED';
      default:
        return 'WORKSPACE UPDATE';
    }
  }

  String _formatDate(String isoString) {
    try {
      final dt = DateTime.parse(isoString);
      final diff = DateTime.now().difference(dt);
      if (diff.inMinutes < 60) {
        return '${diff.inMinutes}m ago';
      } else if (diff.inHours < 24) {
        return '${diff.inHours}h ago';
      } else {
        return '${diff.inDays}d ago';
      }
    } catch (_) {
      return 'just now';
    }
  }
}
