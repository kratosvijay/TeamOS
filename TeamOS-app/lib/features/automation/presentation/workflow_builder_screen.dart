import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WorkflowBuilderScreen extends StatefulWidget {
  const WorkflowBuilderScreen({super.key});

  @override
  State<WorkflowBuilderScreen> createState() => _WorkflowBuilderScreenState();
}

class _WorkflowBuilderScreenState extends State<WorkflowBuilderScreen> {
  final List<BuilderNode> _canvasNodes = [
    BuilderNode(id: '1', type: 'Trigger', name: 'Task Created Trigger', config: 'Event: Task Created'),
    BuilderNode(id: '2', type: 'Approval', name: 'Team Lead Signoff', config: 'Approver: Lead Engineer'),
    BuilderNode(id: '3', type: 'Action', name: 'Create Document Node', config: 'Template: Architecture Wiki'),
  ];

  final _flowNameController = TextEditingController(text: 'Architecture QA Sync Flow');
  String _selectedNodeTypeToAdd = 'Trigger';

  @override
  void dispose() {
    _flowNameController.dispose();
    super.dispose();
  }

  void _addNode() {
    setState(() {
      _canvasNodes.add(
        BuilderNode(
          id: (_canvasNodes.length + 1).toString(),
          type: _selectedNodeTypeToAdd,
          name: 'New $_selectedNodeTypeToAdd Node',
          config: 'Default configuration',
        ),
      );
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Added $_selectedNodeTypeToAdd node to canvas')),
    );
  }

  void _saveWorkflow() {
    if (_flowNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a workflow name')),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Workflow saved successfully as DRAFT')),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Workflow Builder', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        actions: [
          TextButton.icon(
            onPressed: _saveWorkflow,
            icon: const Icon(Icons.save, color: Color(0xFF10B981), size: 18),
            label: const Text('Save Flow', style: TextStyle(color: Color(0xFF10B981))),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Row(
        children: [
          // Left sidebar: Node drawer
          Container(
            width: 250,
            decoration: const BoxDecoration(
              color: Color(0xFF1E293B),
              border: Border(right: BorderSide(color: Color(0xFF334155))),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('AVAILABLE NODES', style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedNodeTypeToAdd,
                  dropdownColor: const Color(0xFF1E293B),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF0F172A),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Trigger', child: Text('Trigger')),
                    DropdownMenuItem(value: 'Condition', child: Text('Condition')),
                    DropdownMenuItem(value: 'Action', child: Text('Action')),
                    DropdownMenuItem(value: 'Approval', child: Text('Approval')),
                    DropdownMenuItem(value: 'Timer', child: Text('Timer')),
                    DropdownMenuItem(value: 'Notification', child: Text('Notification')),
                    DropdownMenuItem(value: 'AI Action', child: Text('AI Action')),
                    DropdownMenuItem(value: 'Webhook', child: Text('Webhook')),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _selectedNodeTypeToAdd = val);
                    }
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: _addNode,
                  icon: const Icon(Icons.add, color: Colors.white, size: 16),
                  label: const Text('Add Node to Canvas', style: TextStyle(color: Colors.white)),
                ),
                const Spacer(),
                TextFormField(
                  controller: _flowNameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Workflow Name',
                    labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
                    filled: true,
                    fillColor: const Color(0xFF0F172A),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ),

          // Central builder canvas
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Drag & Drop Builder Canvas',
                    style: TextStyle(color: Color(0xFF64748B), fontSize: 13, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 24),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _canvasNodes.length,
                    separatorBuilder: (context, idx) => Center(
                      child: Column(
                        children: const [
                          SizedBox(height: 8),
                          Icon(Icons.arrow_downward, color: Color(0xFF334155), size: 24),
                          SizedBox(height: 8),
                        ],
                      ),
                    ),
                    itemBuilder: (context, idx) {
                      final node = _canvasNodes[idx];
                      return Center(
                        child: Container(
                          width: 320,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E293B),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFF334155)),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: _getNodeColor(node.type).withOpacity(0.15),
                                child: Icon(_getNodeIcon(node.type), color: _getNodeColor(node.type)),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(node.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                                    const SizedBox(height: 2),
                                    Text(node.config, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Color(0xFFEF4444), size: 18),
                                onPressed: () {
                                  setState(() => _canvasNodes.removeAt(idx));
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getNodeColor(String type) {
    switch (type.toLowerCase()) {
      case 'trigger':
        return Colors.green;
      case 'condition':
        return Colors.amber;
      case 'approval':
        return Colors.purple;
      case 'action':
        return Colors.blue;
      default:
        return Colors.blueGrey;
    }
  }

  IconData _getNodeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'trigger':
        return Icons.play_circle_outline;
      case 'condition':
        return Icons.alt_route;
      case 'approval':
        return Icons.assignment_turned_in_outlined;
      case 'action':
        return Icons.play_for_work;
      default:
        return Icons.device_hub;
    }
  }
}

class BuilderNode {
  final String id;
  final String type;
  final String name;
  final String config;

  BuilderNode({required this.id, required this.type, required this.name, required this.config});
}
