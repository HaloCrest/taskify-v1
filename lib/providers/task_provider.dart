import 'package:flutter/material.dart';
import 'package:taskify/models/task.dart';

class TaskProvider extends ChangeNotifier {
  final List<Task> _tasks = [];
  bool _isLoading = false;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;

  List<Task> get activeTasks => _tasks.where((task) => !task.isCompleted && !task.isArchived).toList();
  List<Task> get completedTasks => _tasks.where((task) => task.isCompleted && !task.isArchived).toList();
  List<Task> get archivedTasks => _tasks.where((task) => task.isArchived).toList();

  TaskProvider() {
    _loadDummyTasks();
  }

  void _loadDummyTasks() {
    _tasks.addAll([
      Task(
        id: '1',
        title: 'Complete Taskify UI Design',
        description: 'Finish the UI design for the Taskify app including all screens and components.',
        deadline: DateTime.now().add(const Duration(days: 2)),
        priority: TaskPriority.high,
        tags: ['Design', 'UI/UX'],
      ),
      Task(
        id: '2',
        title: 'Research Flutter Animation Libraries',
        description: 'Look into different animation libraries for Flutter to implement smooth transitions.',
        deadline: DateTime.now().add(const Duration(days: 5)),
        priority: TaskPriority.medium,
        tags: ['Research', 'Flutter'],
      ),
      Task(
        id: '3',
        title: 'Buy groceries',
        description: 'Milk, eggs, bread, fruits, and vegetables.',
        deadline: DateTime.now().add(const Duration(days: 1)),
        priority: TaskPriority.low,
        tags: ['Personal'],
        isCompleted: true,
      ),
      Task(
        id: '4',
        title: 'Prepare presentation',
        description: 'Create slides for the upcoming team meeting.',
        deadline: DateTime.now().add(const Duration(days: 3)),
        priority: TaskPriority.high,
        tags: ['Work', 'Presentation'],
      ),
      Task(
        id: '5',
        title: 'Call mom',
        description: "Don't forget to wish her happy birthday!",
        deadline: DateTime.now(),
        priority: TaskPriority.medium,
        tags: ['Personal', 'Family'],
      ),
    ]);
  }

  Future<void> addTask(Task task) async {
    _isLoading = true;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    _tasks.add(task);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateTask(Task updatedTask) async {
    _isLoading = true;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteTask(String taskId) async {
    _isLoading = true;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    _tasks.removeWhere((task) => task.id == taskId);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleTaskCompletion(String taskId) async {
    final index = _tasks.indexWhere((task) => task.id == taskId);
    if (index != -1) {
      final task = _tasks[index];
      _tasks[index] = task.copyWith(isCompleted: !task.isCompleted);
      notifyListeners();
    }
  }

  Future<void> archiveTask(String taskId) async {
    final index = _tasks.indexWhere((task) => task.id == taskId);
    if (index != -1) {
      final task = _tasks[index];
      _tasks[index] = task.copyWith(isArchived: true);
      notifyListeners();
    }
  }

  Future<void> unarchiveTask(String taskId) async {
    final index = _tasks.indexWhere((task) => task.id == taskId);
    if (index != -1) {
      final task = _tasks[index];
      _tasks[index] = task.copyWith(isArchived: false);
      notifyListeners();
    }
  }

  Task? getTaskById(String taskId) {
    try {
      return _tasks.firstWhere((task) => task.id == taskId);
    } catch (e) {
      return null;
    }
  }
}
