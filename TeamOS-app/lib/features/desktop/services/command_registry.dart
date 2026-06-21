import 'package:flutter/material.dart';

class PaletteCommand {
  final String id;
  final String category;
  final String title;
  final String description;
  final String? shortcut;
  final void Function(BuildContext context) action;

  PaletteCommand({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    this.shortcut,
    required this.action,
  });
}

class CommandRegistry {
  static final CommandRegistry _instance = CommandRegistry._internal();
  factory CommandRegistry() => _instance;

  CommandRegistry._internal() {
    // Register Default System Commands
    registerDefaultCommands();
  }

  final List<PaletteCommand> _commands = [];

  List<PaletteCommand> get commands => List.unmodifiable(_commands);

  void registerCommand(PaletteCommand command) {
    _commands.removeWhere((c) => c.id == command.id);
    _commands.add(command);
  }

  void unregisterCommand(String id) {
    _commands.removeWhere((c) => c.id == id);
  }

  void registerDefaultCommands() {
    // Task Commands
    registerCommand(PaletteCommand(
      id: 'task-create',
      category: 'Tasks',
      title: 'Create Task',
      description: 'Quickly create a new task in active project',
      shortcut: 't',
      action: (context) {
        // Navigation or Modal dialog action
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Triggered Action: Create Task')),
        );
      },
    ));

    registerCommand(PaletteCommand(
      id: 'task-view-my',
      category: 'Tasks',
      title: 'My Assigned Tasks',
      description: 'Filter Kanban to display your active tasks',
      shortcut: 'm',
      action: (context) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Triggered Action: Displaying My Tasks')),
        );
      },
    ));

    // Meeting Commands
    registerCommand(PaletteCommand(
      id: 'meeting-start-huddle',
      category: 'Meetings',
      title: 'Start Voice Huddle',
      description: 'Launch an instant voice huddle in active channel',
      shortcut: 'h',
      action: (context) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Triggered Action: Starting Voice Huddle')),
        );
      },
    ));

    registerCommand(PaletteCommand(
      id: 'meeting-schedule',
      category: 'Meetings',
      title: 'Schedule Meeting',
      description: 'Open calendar to schedule a sync session',
      shortcut: 's',
      action: (context) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Triggered Action: Open Scheduler')),
        );
      },
    ));

    // Document Commands
    registerCommand(PaletteCommand(
      id: 'document-create-wiki',
      category: 'Documents',
      title: 'New Wiki Document',
      description: 'Create a new page in knowledge base wiki',
      shortcut: 'd',
      action: (context) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Triggered Action: Creating Wiki Document')),
        );
      },
    ));

    // AI Commands
    registerCommand(PaletteCommand(
      id: 'ai-explain-code',
      category: 'AI Assistant',
      title: 'Ask AI Workspace Chat',
      description: 'Open conversational AI assistant helper',
      shortcut: 'a',
      action: (context) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Triggered Action: Launch AI Workspace Chat')),
        );
      },
    ));

    // Workspace Commands
    registerCommand(PaletteCommand(
      id: 'workspace-settings',
      category: 'Workspace',
      title: 'Open Settings',
      description: 'Open TeamOS preferences and window launcher',
      shortcut: ',',
      action: (context) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Triggered Action: Opening Desktop Settings')),
        );
      },
    ));
  }
}
