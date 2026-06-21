import 'package:flutter/material.dart';
import '../services/sync_engine.dart';
import '../services/sync_metrics.dart';
import '../services/offline_queue.dart';

class OfflineSyncScreen extends StatefulWidget {
  const OfflineSyncScreen({super.key});

  @override
  State<OfflineSyncScreen> createState() => _OfflineSyncScreenState();
}

class _OfflineSyncScreenState extends State<OfflineSyncScreen> {
  SyncState _engineState = SyncState.online;
  int _pendingCount = 0;
  int _failedCount = 0;
  int _conflictCount = 0;
  double _avgDuration = 0.0;
  String _lastSync = 'Never';
  bool _isLoading = true;
  List<LocalMutation> _pendingMutations = [];

  @override
  void initState() {
    super.initState();
    _loadSyncEngineStats();
    // Listen to sync engine changes
    SyncEngine().stateStream.listen((state) {
      if (mounted) {
        setState(() {
          _engineState = state;
        });
        _loadSyncEngineStats();
      }
    });
  }

  Future<void> _loadSyncEngineStats() async {
    final metrics = SyncMetrics();
    await metrics.init();
    final queue = await OfflineQueue().getQueue();

    if (mounted) {
      setState(() {
        _engineState = SyncEngine().state;
        _pendingCount = queue.length;
        _pendingMutations = queue;
        _failedCount = metrics.failedMutationsCount;
        _conflictCount = metrics.conflictCount;
        _avgDuration = metrics.averageSyncDurationMs;
        _lastSync = metrics.lastSyncTime != null
            ? '${metrics.lastSyncTime!.hour.toString().padLeft(2, '0')}:${metrics.lastSyncTime!.minute.toString().padLeft(2, '0')}:${metrics.lastSyncTime!.second.toString().padLeft(2, '0')}'
            : 'Never';
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleEngineState() async {
    final engine = SyncEngine();
    if (engine.state == SyncState.offline) {
      await engine.simulateGoOnline();
    } else {
      await engine.simulateGoOffline();
    }
    _loadSyncEngineStats();
  }

  Future<void> _forceSync() async {
    setState(() {
      _isLoading = true;
    });
    await SyncEngine().triggerSync();
    _loadSyncEngineStats();
  }

  Future<void> _addMockMutation() async {
    final mutation = LocalMutation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      action: 'UPDATE',
      entity: 'Task',
      entityId: 'mock-task-id',
      data: {'title': 'Offline Edited Task Title', 'status': 'IN_PROGRESS'},
      clientUpdatedAt: DateTime.now().toIso8601String(),
    );
    await OfflineQueue().addMutation(mutation);
    _loadSyncEngineStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Offline Sync Dashboard', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF38BDF8)))
          : Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Engine Status Header card
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF334155)),
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        _buildStatusIndicator(),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Engine State: ${_engineState.name.toUpperCase()}',
                                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Last successful batch sync: $_lastSync',
                                style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _engineState == SyncState.offline
                                ? const Color(0xFF34D399)
                                : const Color(0xFFF43F5E),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                          ),
                          icon: Icon(
                            _engineState == SyncState.offline ? Icons.wifi : Icons.wifi_off,
                            color: Colors.white,
                          ),
                          label: Text(
                            _engineState == SyncState.offline ? 'Go Online' : 'Go Offline',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          onPressed: _toggleEngineState,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Stats overview row
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatTile('Pending Mutations', '$_pendingCount items', Icons.pending, const Color(0xFF38BDF8)),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _buildStatTile('Failed Syncs', '$_failedCount batches', Icons.error_outline, const Color(0xFFF43F5E)),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _buildStatTile('Conflicts Resolved', '$_conflictCount conflicts', Icons.merge_type, const Color(0xFFFBBF24)),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _buildStatTile('Avg Sync Duration', '${_avgDuration.toStringAsFixed(0)} ms', Icons.speed, const Color(0xFF34D399)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Actions row
                  Row(
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF38BDF8),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        ),
                        icon: const Icon(Icons.sync, color: Colors.white),
                        label: const Text('Force Trigger Sync', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        onPressed: _engineState == SyncState.offline ? null : _forceSync,
                      ),
                      const SizedBox(width: 16),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF475569)),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        ),
                        icon: const Icon(Icons.add, color: Color(0xFF94A3B8)),
                        label: const Text('Simulate Offline Task Edit', style: TextStyle(color: Color(0xFFE2E8F0))),
                        onPressed: _addMockMutation,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Queue listing
                  const Text(
                    'Offline Mutation Queue Buffer',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _pendingMutations.isEmpty
                        ? const Center(
                            child: Text(
                              'Queue is empty. Toggle offline mode and create changes to view them here.',
                              style: TextStyle(color: Color(0xFF64748B)),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _pendingMutations.length,
                            itemBuilder: (context, index) {
                              final item = _pendingMutations[index];
                              return Card(
                                color: const Color(0xFF1E293B),
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: const BorderSide(color: Color(0xFF334155)),
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: const Color(0xFF38BDF8).withOpacity(0.12),
                                    child: const Icon(Icons.code, color: Color(0xFF38BDF8)),
                                  ),
                                  title: Text(
                                    '${item.action} ${item.entity.toUpperCase()} (${item.entityId})',
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                  subtitle: Text(
                                    'Payload: ${item.data.toString()}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete, color: Color(0xFFF43F5E), size: 18),
                                    onPressed: () async {
                                      await OfflineQueue().removeMutation(item.id);
                                      _loadSyncEngineStats();
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildStatusIndicator() {
    Color color;
    switch (_engineState) {
      case SyncState.online:
        color = const Color(0xFF34D399); // green
        break;
      case SyncState.syncing:
        color = const Color(0xFF38BDF8); // blue
        break;
      case SyncState.offline:
        color = const Color(0xFF64748B); // gray
        break;
      case SyncState.conflict:
      case SyncState.error:
        color = const Color(0xFFF43F5E); // red
        break;
    }

    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildStatTile(String label, String value, IconData icon, Color color) {
    return Container(
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
              Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold)),
              Icon(icon, color: color, size: 18),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
