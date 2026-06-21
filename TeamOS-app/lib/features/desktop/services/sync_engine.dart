import 'dart:async';
import 'package:uuid/uuid.dart';
import 'offline_queue.dart';
import 'sync_metrics.dart';
import 'local_cache_service.dart';

enum SyncState { online, syncing, offline, conflict, error }

class SyncEngine {
  static final SyncEngine _instance = SyncEngine._internal();
  factory SyncEngine() => _instance;
  SyncEngine._internal() {
    // Periodically check connectivity and update pending count
    _connectivityTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      checkConnectivity();
    });
  }

  SyncState _state = SyncState.online;
  SyncState get state => _state;

  final _stateController = StreamController<SyncState>.broadcast();
  Stream<SyncState> get stateStream => _stateController.stream;

  Timer? _connectivityTimer;
  int _sequenceNumber = 1;
  final String _deviceId = const Uuid().v4(); // Generate unique device ID for session

  void dispose() {
    _connectivityTimer?.cancel();
    _stateController.close();
  }

  void _updateState(SyncState newState) {
    _state = newState;
    _stateController.add(_state);
  }

  Future<void> checkConnectivity() async {
    // Simulate connectivity check. In production, this can perform a ping request
    final queue = await OfflineQueue().getQueue();
    await SyncMetrics().updatePendingCount(queue.length);
  }

  Future<void> simulateGoOffline() async {
    _updateState(SyncState.offline);
  }

  Future<void> simulateGoOnline() async {
    _updateState(SyncState.online);
    await triggerSync();
  }

  Future<void> triggerSync() async {
    if (_state == SyncState.offline || _state == SyncState.syncing) {
      return;
    }

    final queue = await OfflineQueue().getQueue();
    if (queue.isEmpty) {
      _updateState(SyncState.online);
      return;
    }

    _updateState(SyncState.syncing);
    final stopwatch = Stopwatch()..start();

    try {
      final batchId = const Uuid().v4();

      // Package mutations in SyncBatch format
      final syncBatch = {
        'batchId': batchId,
        'deviceId': _deviceId,
        'sequenceNumber': _sequenceNumber,
        'mutations': queue.map((e) => e.toJson()).toList(),
        'createdAt': DateTime.now().toIso8601String(),
      };

      // Simulating API POST call to /offline/sync
      // In production: await dio.post('/offline/sync', data: syncBatch);
      await Future.delayed(const Duration(seconds: 1)); // Simulate round-trip latency

      // Apply locally cached mutations to local SQLite simulator
      final cacheService = LocalCacheService();
      for (final mutation in queue) {
        if (mutation.entity == 'Task') {
          if (mutation.action == 'CREATE' || mutation.action == 'UPDATE') {
            await cacheService.saveTask(mutation.data);
          } else if (mutation.action == 'DELETE') {
            await cacheService.deleteTask(mutation.entityId);
          }
        } else if (mutation.entity == 'Document') {
          await cacheService.saveDocument(mutation.data);
        } else if (mutation.entity == 'Setting') {
          await cacheService.saveProject(mutation.data); // mock settings update
        }
      }

      stopwatch.stop();
      _sequenceNumber++;

      // Record metrics success
      await SyncMetrics().recordSyncSuccess(stopwatch.elapsedMilliseconds.toDouble());
      await OfflineQueue().clearQueue();

      _updateState(SyncState.online);
    } catch (e) {
      stopwatch.stop();
      print('SyncEngine: Synchronization failed: $e');
      await SyncMetrics().recordSyncFailure();
      _updateState(SyncState.error);
    }
  }
}
