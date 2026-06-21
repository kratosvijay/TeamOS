import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class LocalCacheService {
  static final LocalCacheService _instance = LocalCacheService._internal();
  factory LocalCacheService() => _instance;
  LocalCacheService._internal();

  File? _cacheFile;
  Map<String, dynamic> _data = {
    'tasks': [],
    'projects': [],
    'documents': [],
    'meetings': [],
    'recent_searches': [],
    'activity_timeline': [],
  };

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    try {
      final dir = await getApplicationDocumentsDirectory();
      _cacheFile = File('${dir.path}/teamos_local_sqlite_cache.json');
      if (await _cacheFile!.exists()) {
        final content = await _cacheFile!.readAsString();
        _data = jsonDecode(content);
      } else {
        await _save();
      }
      _initialized = true;
    } catch (e) {
      print('LocalCacheService: Failed to initialize SQLite cache: $e');
    }
  }

  Future<void> _save() async {
    if (_cacheFile == null) return;
    try {
      await _cacheFile!.writeAsString(jsonEncode(_data));
    } catch (e) {
      print('LocalCacheService: Failed to save SQLite cache: $e');
    }
  }

  // --- SQLite Query Simulations (Drift API-like Interface) ---

  // Tasks
  Future<List<Map<String, dynamic>>> getTasks() async {
    await init();
    return List<Map<String, dynamic>>.from(_data['tasks']);
  }

  Future<void> saveTask(Map<String, dynamic> task) async {
    await init();
    final list = List<Map<String, dynamic>>.from(_data['tasks']);
    list.removeWhere((item) => item['id'] == task['id']);
    list.add(task);
    _data['tasks'] = list;
    await _save();
  }

  Future<void> deleteTask(String taskId) async {
    await init();
    final list = List<Map<String, dynamic>>.from(_data['tasks']);
    list.removeWhere((item) => item['id'] == taskId);
    _data['tasks'] = list;
    await _save();
  }

  // Projects
  Future<List<Map<String, dynamic>>> getProjects() async {
    await init();
    return List<Map<String, dynamic>>.from(_data['projects']);
  }

  Future<void> saveProject(Map<String, dynamic> project) async {
    await init();
    final list = List<Map<String, dynamic>>.from(_data['projects']);
    list.removeWhere((item) => item['id'] == project['id']);
    list.add(project);
    _data['projects'] = list;
    await _save();
  }

  // Documents
  Future<List<Map<String, dynamic>>> getDocuments() async {
    await init();
    return List<Map<String, dynamic>>.from(_data['documents']);
  }

  Future<void> saveDocument(Map<String, dynamic> doc) async {
    await init();
    final list = List<Map<String, dynamic>>.from(_data['documents']);
    list.removeWhere((item) => item['id'] == doc['id']);
    list.add(doc);
    _data['documents'] = list;
    await _save();
  }

  // Meetings
  Future<List<Map<String, dynamic>>> getMeetings() async {
    await init();
    return List<Map<String, dynamic>>.from(_data['meetings']);
  }

  Future<void> saveMeeting(Map<String, dynamic> meeting) async {
    await init();
    final list = List<Map<String, dynamic>>.from(_data['meetings']);
    list.removeWhere((item) => item['id'] == meeting['id']);
    list.add(meeting);
    _data['meetings'] = list;
    await _save();
  }

  // Recent Searches
  Future<List<String>> getRecentSearches() async {
    await init();
    return List<String>.from(_data['recent_searches']);
  }

  Future<void> addRecentSearch(String query) async {
    await init();
    final list = List<String>.from(_data['recent_searches']);
    list.remove(query);
    list.insert(0, query);
    if (list.length > 20) list.removeLast();
    _data['recent_searches'] = list;
    await _save();
  }

  // Activity Timeline
  Future<List<Map<String, dynamic>>> getActivityTimeline() async {
    await init();
    return List<Map<String, dynamic>>.from(_data['activity_timeline']);
  }

  Future<void> addTimelineItem(Map<String, dynamic> item) async {
    await init();
    final list = List<Map<String, dynamic>>.from(_data['activity_timeline']);
    list.add(item);
    // Sort chronologically descending
    list.sort((a, b) => b['createdAt'].compareTo(a['createdAt']));
    _data['activity_timeline'] = list;
    await _save();
  }

  Future<void> clearAll() async {
    await init();
    _data = {
      'tasks': [],
      'projects': [],
      'documents': [],
      'meetings': [],
      'recent_searches': [],
      'activity_timeline': [],
    };
    await _save();
  }
}
