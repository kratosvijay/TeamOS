import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/command_registry.dart';

class CommandPaletteScreen extends StatefulWidget {
  const CommandPaletteScreen({super.key});

  @override
  State<CommandPaletteScreen> createState() => _CommandPaletteScreenState();
}

class _CommandPaletteScreenState extends State<CommandPaletteScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _inputFocusNode = FocusNode();
  List<PaletteCommand> _filteredCommands = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _filteredCommands = CommandRegistry().commands;
    _inputFocusNode.requestFocus();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCommands = CommandRegistry().commands.where((cmd) {
        return cmd.title.toLowerCase().contains(query) ||
            cmd.description.toLowerCase().contains(query) ||
            cmd.category.toLowerCase().contains(query);
      }).toList();
      _selectedIndex = 0;
    });
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        setState(() {
          if (_filteredCommands.isNotEmpty) {
            _selectedIndex = (_selectedIndex + 1) % _filteredCommands.length;
          }
        });
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        setState(() {
          if (_filteredCommands.isNotEmpty) {
            _selectedIndex = (_selectedIndex - 1 + _filteredCommands.length) %
                _filteredCommands.length;
          }
        });
      } else if (event.logicalKey == LogicalKeyboardKey.enter) {
        if (_filteredCommands.isNotEmpty && _selectedIndex < _filteredCommands.length) {
          _filteredCommands[_selectedIndex].action(context);
          Navigator.of(context).pop();
        }
      } else if (event.logicalKey == LogicalKeyboardKey.escape) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: _handleKeyEvent,
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.4),
        body: Center(
          child: Container(
            width: 650,
            height: 450,
            margin: const EdgeInsets.symmetric(vertical: 80),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF334155), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 24,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Column(
              children: [
                // Spotlight Search bar
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _searchController,
                    focusNode: _inputFocusNode,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    decoration: InputDecoration(
                      hintText: 'Type a command or search workspace...',
                      hintStyle: const TextStyle(color: Color(0xFF64748B)),
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF38BDF8)),
                      filled: true,
                      fillColor: const Color(0xFF1E293B),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const Divider(color: Color(0xFF334155), height: 1),

                // Commands list
                Expanded(
                  child: _filteredCommands.isEmpty
                      ? const Center(
                          child: Text(
                            'No matching commands found',
                            style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _filteredCommands.length,
                          itemBuilder: (context, index) {
                            final cmd = _filteredCommands[index];
                            final isSelected = index == _selectedIndex;
                            return Container(
                              color: isSelected
                                  ? const Color(0xFF38BDF8).withOpacity(0.12)
                                  : Colors.transparent,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 12),
                              child: Row(
                                children: [
                                  Icon(
                                    _getCategoryIcon(cmd.category),
                                    color: isSelected
                                        ? const Color(0xFF38BDF8)
                                        : const Color(0xFF64748B),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          cmd.title,
                                          style: TextStyle(
                                            color: isSelected
                                                ? Colors.white
                                                : const Color(0xFFE2E8F0),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          cmd.description,
                                          style: const TextStyle(
                                            color: Color(0xFF94A3B8),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (cmd.shortcut != null)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF1E293B),
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                            color: const Color(0xFF475569)),
                                      ),
                                      child: Text(
                                        cmd.shortcut!.toUpperCase(),
                                        style: const TextStyle(
                                          color: Color(0xFF38BDF8),
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
                // Footer
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1E293B),
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ESC to exit  •  ↑↓ to navigate  •  Enter to select',
                        style: TextStyle(color: Color(0xFF64748B), fontSize: 11),
                      ),
                      Text(
                        'TeamOS Power Shell',
                        style: TextStyle(
                            color: Color(0xFF38BDF8),
                            fontSize: 11,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Tasks':
        return Icons.task_alt;
      case 'Meetings':
        return Icons.video_call;
      case 'Documents':
        return Icons.article;
      case 'AI Assistant':
        return Icons.psychology;
      default:
        return Icons.settings;
    }
  }
}
