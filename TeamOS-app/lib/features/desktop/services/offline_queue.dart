import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class LocalMutation {
  final String id;
  final String action; // CREATE, UPDATE, DELETE, APPEND
  final String entity; // Task, Document, Setting, Comment
  final String entityId;
  final Map<String, dynamic> data;
  final String clientUpdatedAt;

  LocalMutation({
    required this.id,
    required this.action,
    required this.entity,
    required this.entityId,
    required this.data,
    required this.clientUpdatedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'action': action,
        'entity': entity,
        'entityId': entityId,
        'data': data,
        'clientUpdatedAt': clientUpdatedAt,
      };

  factory LocalMutation.fromJson(Map<String, dynamic> json) => LocalMutation(
        id: json['id'],
        action: json['action'],
        entity: json['entity'],
        entityId: json['entityId'],
        data: Map<String, dynamic>.from(json['data']),
        clientUpdatedAt: json['clientUpdatedAt'],
      );
}

class OfflineQueue {
  static final OfflineQueue _instance = OfflineQueue._internal();
  factory OfflineQueue() => _instance;
  OfflineQueue._internal();

  File? _queueFile;
  List<LocalMutation> _queue = [];
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    try {
      final dir = await getApplicationDocumentsDirectory();
      _queueFile = File('${dir.path}/teamos_offline_queue.json');
      if (await _queueFile!.exists()) {
        final content = await _queueFile!.readAsString();
        final List<dynamic> list = jsonDecode(content);
        _queue = list.map((item) => LocalMutation.fromJson(item)).toList();
      }
      _initialized = true;
    } catch (e) {
      print('OfflineQueue: Failed to initialize offline queue: $e');
    }
  }

  Future<void> _save() async {
    if (_queueFile == null) return;
    try {
      await _queueFile!.writeAsString(jsonEncode(_queue.map((e) => e.toJson()).toList()));
    } catch (e) {
      print('OfflineQueue: Failed to save offline queue: $e');
    }
  }

  Future<void> addMutation(LocalMutation mutation) async {
    await init();
    _queue.add(mutation);
    await _save();
  }

  Future<List<LocalMutation>> getQueue() async {
    await init();
    return List<LocalMutation>.from(_queue);
  }

  Future<void> removeMutation(String mutationId) async {
    await init();
    _queue.removeWhere((item) => item.id == mutationId);
    await _save();
  }

  Future<void> clearQueue() async {
    await init();
    _queue.clear();
    await _save();
  }
}
