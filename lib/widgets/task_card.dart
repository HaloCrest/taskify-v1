import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:taskify/models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final Function(bool) onToggleCompletion;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final bool showActions;

  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
    required this.onToggleCompletion,
    this.onDelete,
    this.onEdit,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              splashColor: colorScheme.primary.withOpacity(0.1),
              highlightColor: colorScheme.primary.withOpacity(0.05),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Priority indicator
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: task.getPriorityColor(),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Priority text
                        Text(
                          task.getPriorityText(),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: task.getPriorityColor(),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        // Checkbox for completion
                        Transform.scale(
                          scale: 0.9,
                          child: Checkbox(
                            value: task.isCompleted,
                            onChanged: (value) => onToggleCompletion(value ?? false),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            activeColor: colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Task title
                    Text(
                      task.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                        color: task.isCompleted 
                            ? (isDarkMode ? Colors.grey[500] : Colors.grey[600])
                            : (isDarkMode ? Colors.white : Colors.black87),
                      ),
                    ),
                    if (task.description.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      // Task description
                      Text(
                        task.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        // Deadline
                        if (task.deadline != null) ...[
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 14,
                            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('MMM dd, yyyy').format(task.deadline!),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                            ),
                          ),
                          const Spacer(),
                        ] else
                          const Spacer(),
                        
                        // Tags
                        if (task.tags.isNotEmpty) ...[
                          Wrap(
                            spacing: 4,
                            children: task.tags.map((tag) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: colorScheme.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  tag,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                    if (showActions) ...[
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (onEdit != null)
                            IconButton(
                              icon: Icon(
                                Icons.edit_outlined,
                                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                                size: 20,
                              ),
                              onPressed: onEdit,
                              tooltip: 'Edit',
                              constraints: const BoxConstraints(),
                              padding: const EdgeInsets.all(8),
                              splashRadius: 24,
                            ),
                          if (onDelete != null) ...[
                            const SizedBox(width: 8),
                            IconButton(
                              icon: Icon(
                                Icons.delete_outline,
                                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                                size: 20,
                              ),
                              onPressed: onDelete,
                              tooltip: 'Delete',
                              constraints: const BoxConstraints(),
                              padding: const EdgeInsets.all(8),
                              splashRadius: 24,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ).animate()
        .fadeIn(duration: 300.ms, delay: 50.ms)
        .slideY(begin: 0.1, end: 0, duration: 300.ms, curve: Curves.easeOutQuad),
    );
  }
}
