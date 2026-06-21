import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class SyncMetrics {
  static final SyncMetrics _instance = SyncMetrics._internal();
  factory SyncMetrics() => _instance;
  SyncMetrics._internal();

  DateTime? lastSyncTime;
  int pendingMutationsCount = 0;
  int failedMutationsCount = 0;
  int conflictCount = 0;
  double averageSyncDurationMs = 0.0;

  List<double> _syncDurations = [];
  File? _metricsFile;
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    try {
      final dir = await getApplicationDocumentsDirectory();
      _metricsFile = File('${dir.path}/teamos_sync_metrics.json');
      if (await _metricsFile!.exists()) {
        final content = await _metricsFile!.readAsString();
        final Map<String, dynamic> data = jsonDecode(content);
        if (data['lastSyncTime'] != null) {
          lastSyncTime = DateTime.parse(data['lastSyncTime']);
        }
        pendingMutationsCount = data['pendingMutationsCount'] ?? 0;
        failedMutationsCount = data['failedMutationsCount'] ?? 0;
        conflictCount = data['conflictCount'] ?? 0;
        averageSyncDurationMs = (data['averageSyncDurationMs'] ?? 0.0).toDouble();
        if (data['syncDurations'] != null) {
          _syncDurations = List<double>.from(
            (data['syncDurations'] as List).map((e) => (e as num).toDouble()),
          );
        }
      }
      _initialized = true;
    } catch (e) {
      print('SyncMetrics: Failed to initialize sync metrics: $e');
    }
  }

  Future<void> save() async {
    if (_metricsFile == null) return;
    try {
      final data = {
        'lastSyncTime': lastSyncTime?.toIso8601String(),
        'pendingMutationsCount': pendingMutationsCount,
        'failedMutationsCount': failedMutationsCount,
        'conflictCount': conflictCount,
        'averageSyncDurationMs': averageSyncDurationMs,
        'syncDurations': _syncDurations,
      };
      await _metricsFile!.writeAsString(jsonEncode(data));
    } catch (e) {
      print('SyncMetrics: Failed to save sync metrics: $e');
    }
  }

  Future<void> recordSyncSuccess(double durationMs) async {
    await init();
    lastSyncTime = DateTime.now();
    _syncDurations.add(durationMs);
    if (_syncDurations.length > 50) {
      _syncDurations.removeAt(0);
    }
    averageSyncDurationMs = _syncDurations.reduce((a, b) => a + b) / _syncDurations.length;
    pendingMutationsCount = 0;
    await save();
  }

  Future<void> recordSyncFailure() async {
    await init();
    failedMutationsCount++;
    await save();
  }

  Future<void> recordConflict() async {
    await init();
    conflictCount++;
    await save();
  }

  Future<void> updatePendingCount(int count) async {
    await init();
    pendingMutationsCount = count;
    await save();
  }

  Future<void> reset() async {
    await init();
    lastSyncTime = null;
    pendingMutationsCount = 0;
    failedMutationsCount = 0;
    conflictCount = 0;
    averageSyncDurationMs = 0.0;
    _syncDurations.clear();
    await save();
  }
}
