import 'package:flutter/material.dart';
import '../services/local_cache_service.dart';

class GlobalSearchScreen extends StatefulWidget {
  const GlobalSearchScreen({super.key});

  @override
  State<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends State<GlobalSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _allResults = [];
  List<Map<String, dynamic>> _filteredResults = [];
  List<String> _recentSearches = [];
  String _selectedFilter = 'ALL';

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
    _searchController.addListener(_onSearchQueryChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadRecentSearches() async {
    final searches = await LocalCacheService().getRecentSearches();
    setState(() {
      _recentSearches = searches;
    });
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _allResults = [];
        _filteredResults = [];
      });
      return;
    }

    final cache = LocalCacheService();
    final tasks = await cache.getTasks();
    final docs = await cache.getDocuments();
    final meetings = await cache.getMeetings();
    final projects = await cache.getProjects();

    final List<Map<String, dynamic>> results = [];

    // Search tasks
    for (final task in tasks) {
      if (task['title'].toString().toLowerCase().contains(query.toLowerCase()) ||
          (task['description'] ?? '').toString().toLowerCase().contains(query.toLowerCase())) {
        results.add({
          'id': task['id'],
          'type': 'TASK',
          'title': task['title'],
          'subtitle': 'Status: ${task['status'] ?? 'TODO'} • Priority: ${task['priority'] ?? 'MEDIUM'}',
          'icon': Icons.task_alt,
          'color': const Color(0xFF38BDF8),
        });
      }
    }

    // Search documents
    for (final doc in docs) {
      if (doc['title'].toString().toLowerCase().contains(query.toLowerCase()) ||
          (doc['plainText'] ?? '').toString().toLowerCase().contains(query.toLowerCase())) {
        results.add({
          'id': doc['id'],
          'type': 'DOCUMENT',
          'title': doc['title'],
          'subtitle': 'Wiki document space',
          'icon': Icons.article,
          'color': const Color(0xFF34D399),
        });
      }
    }

    // Search meetings
    for (final meeting in meetings) {
      if (meeting['title'].toString().toLowerCase().contains(query.toLowerCase())) {
        results.add({
          'id': meeting['id'],
          'type': 'MEETING',
          'title': meeting['title'],
          'subtitle': 'Meeting Host: ${meeting['hostName'] ?? 'Host'}',
          'icon': Icons.video_call,
          'color': const Color(0xFFFB7185),
        });
      }
    }

    // Search projects
    for (final proj in projects) {
      if (proj['name'].toString().toLowerCase().contains(query.toLowerCase())) {
        results.add({
          'id': proj['id'],
          'type': 'PROJECT',
          'title': proj['name'],
          'subtitle': 'Project Workspace',
          'icon': Icons.folder,
          'color': const Color(0xFFFBBF24),
        });
      }
    }

    // Add to recent search
    await cache.addRecentSearch(query);
    _loadRecentSearches();

    setState(() {
      _allResults = results;
      _applyFilter();
    });
  }

  void _onSearchQueryChanged() {
    _performSearch(_searchController.text);
  }

  void _applyFilter() {
    if (_selectedFilter == 'ALL') {
      _filteredResults = _allResults;
    } else {
      _filteredResults = _allResults.where((r) => r['type'] == _selectedFilter).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Global Workspace Search', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Row(
        children: [
          // Filter Panel (Left)
          Container(
            width: 220,
            decoration: const BoxDecoration(
              color: Color(0xFF1E293B),
              border: Border(right: BorderSide(color: Color(0xFF334155))),
            ),
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 18),
              children: [
                _buildFilterItem('ALL', 'All Results', Icons.all_inclusive),
                _buildFilterItem('TASK', 'Tasks', Icons.task_alt),
                _buildFilterItem('DOCUMENT', 'Documents', Icons.article),
                _buildFilterItem('MEETING', 'Meetings', Icons.video_call),
                _buildFilterItem('PROJECT', 'Projects', Icons.folder),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Divider(color: Color(0xFF334155)),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('RECENT SEARCHES', style: TextStyle(color: Color(0xFF64748B), fontSize: 10, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 8),
                ..._recentSearches.map((s) => ListTile(
                      title: Text(s, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
                      dense: true,
                      onTap: () {
                        _searchController.text = s;
                      },
                    )),
              ],
            ),
          ),

          // Search Input & Results (Right)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search for tasks, docs, meetings, projects...',
                      hintStyle: const TextStyle(color: Color(0xFF64748B)),
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF38BDF8)),
                      filled: true,
                      fillColor: const Color(0xFF1E293B),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF38BDF8), width: 1.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF334155)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: _filteredResults.isEmpty
                        ? const Center(
                            child: Text(
                              'Type query or adjust filters to view results',
                              style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _filteredResults.length,
                            itemBuilder: (context, index) {
                              final item = _filteredResults[index];
                              return Card(
                                color: const Color(0xFF1E293B),
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: const BorderSide(color: Color(0xFF334155)),
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: item['color'].withOpacity(0.12),
                                    child: Icon(item['icon'], color: item['color']),
                                  ),
                                  title: Text(
                                    item['title'],
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    item['subtitle'],
                                    style: const TextStyle(color: Color(0xFF94A3B8)),
                                  ),
                                  trailing: const Icon(Icons.chevron_right, color: Color(0xFF64748B)),
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Opening ${item['type']}: ${item['title']}')),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterItem(String filter, String label, IconData icon) {
    final isSelected = _selectedFilter == filter;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF38BDF8).withOpacity(0.12) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(icon, color: isSelected ? const Color(0xFF38BDF8) : const Color(0xFF64748B), size: 18),
        title: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFFE2E8F0),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
        dense: true,
        onTap: () {
          setState(() {
            _selectedFilter = filter;
            _applyFilter();
          });
        },
      ),
    );
  }
}
