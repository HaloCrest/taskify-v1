import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:taskify/models/task.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final Function(bool) onToggleCompletion;

  const TaskTile({
    super.key,
    required this.task,
    required this.onTap,
    required this.onToggleCompletion,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      onTap: onTap,
      leading: Transform.scale(
        scale: 1.1,
        child: Checkbox(
          value: task.isCompleted,
          onChanged: (value) => onToggleCompletion(value ?? false),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          activeColor: colorScheme.primary,
        ),
      ),
      title: Text(
        task.title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w500,
          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          color: task.isCompleted 
              ? (isDarkMode ? Colors.grey[500] : Colors.grey[600])
              : (isDarkMode ? Colors.white : Colors.black87),
        ),
      ),
      subtitle: task.deadline != null
          ? Text(
              DateFormat('MMM dd, yyyy').format(task.deadline!),
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            )
          : null,
      trailing: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: task.getPriorityColor(),
          shape: BoxShape.circle,
        ),
      ),
    ).animate()
      .fadeIn(duration: 300.ms, delay: 50.ms)
      .slideX(begin: 0.05, end: 0, duration: 300.ms, curve: Curves.easeOutQuad);
  }
}
