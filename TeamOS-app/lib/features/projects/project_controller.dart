import 'package:flutter_riverpod/flutter_riverpod.dart';

class Project {
  final String id;
  final String name;
  final String description;

  Project({required this.id, required this.name, required this.description});
}

class ProjectState {
  final List<Project> projects;
  final bool isLoading;
  final String? errorMessage;

  ProjectState({
    this.projects = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  ProjectState copyWith({
    List<Project>? projects,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ProjectState(
      projects: projects ?? this.projects,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class ProjectNotifier extends StateNotifier<ProjectState> {
  ProjectNotifier() : super(ProjectState());

  Future<void> fetchProjects(String workspaceId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      // Simulate API fetch delay
      await Future.delayed(const Duration(seconds: 1));
      
      final mockProjects = [
        Project(id: '1', name: 'Engineering Roadmap', description: 'Core product plans'),
        Project(id: '2', name: 'Marketing Campaign', description: 'Q3 Launch prep'),
      ];
      
      state = state.copyWith(isLoading: false, projects: mockProjects);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> createProject(String name, String description) async {
    state = state.copyWith(isLoading: true);
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final newProject = Project(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        description: description,
      );
      state = state.copyWith(
        isLoading: false,
        projects: [...state.projects, newProject],
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}

final projectProvider = StateNotifierProvider<ProjectNotifier, ProjectState>((ref) {
  return ProjectNotifier();
});
