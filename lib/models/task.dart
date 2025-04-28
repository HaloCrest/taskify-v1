import 'package:flutter/material.dart';

enum TaskPriority { low, medium, high }

class Task {
  final String id;
  String title;
  String description;
  DateTime? deadline;
  bool isCompleted;
  TaskPriority priority;
  List<String> tags;
  bool isArchived;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    this.description = '',
    this.deadline,
    this.isCompleted = false,
    this.priority = TaskPriority.medium,
    this.tags = const [],
    this.isArchived = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Task copyWith({
    String? title,
    String? description,
    DateTime? deadline,
    bool? isCompleted,
    TaskPriority? priority,
    List<String>? tags,
    bool? isArchived,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      deadline: deadline ?? this.deadline,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      tags: tags ?? this.tags,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt,
    );
  }

  Color getPriorityColor() {
    switch (priority) {
      case TaskPriority.low:
        return Colors.green;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.high:
        return Colors.red;
    }
  }

  String getPriorityText() {
    switch (priority) {
      case TaskPriority.low:
        return 'Low';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.high:
        return 'High';
    }
  }
}
