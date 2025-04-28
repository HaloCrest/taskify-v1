import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:taskify/models/task.dart';
import 'package:taskify/providers/task_provider.dart';
import 'package:taskify/screens/tasks/add_task_screen.dart';
import 'package:taskify/widgets/custom_button.dart';

class TaskDetailsScreen extends StatelessWidget {
  final String taskId;

  const TaskDetailsScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final task = taskProvider.getTaskById(taskId);
    
    if (task == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Task Not Found'),
        ),
        body: const Center(
          child: Text('The task you are looking for does not exist.'),
        ),
      );
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Task Details',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDarkMode ? Colors.white70 : Colors.black54,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.edit_outlined,
              color: isDarkMode ? Colors.white70 : Colors.black54,
            ),
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => AddTaskScreen(taskToEdit: task),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                ),
              );
            },
            tooltip: 'Edit Task',
          ),
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              color: isDarkMode ? Colors.white70 : Colors.black54,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Task'),
                  content: const Text('Are you sure you want to delete this task?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        taskProvider.deleteTask(task.id);
                        Navigator.pop(context); // Close dialog
                        Navigator.pop(context); // Go back to previous screen
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
            },
            tooltip: 'Delete Task',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task Status and Priority
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: task.isCompleted
                        ? Colors.green.withOpacity(0.1)
                        : Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: task.isCompleted ? Colors.green : Colors.blue,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        task.isCompleted
                            ? Icons.check_circle_outline
                            : Icons.pending_outlined,
                        size: 16,
                        color: task.isCompleted ? Colors.green : Colors.blue,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        task.isCompleted ? 'Completed' : 'In Progress',
                        style: TextStyle(
                          color: task.isCompleted ? Colors.green : Colors.blue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: task.getPriorityColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: task.getPriorityColor(),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.flag_outlined,
                        size: 16,
                        color: task.getPriorityColor(),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        task.getPriorityText(),
                        style: TextStyle(
                          color: task.getPriorityColor(),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ).animate()
              .fadeIn(duration: 300.ms)
              .slideY(begin: 0.1, end: 0, duration: 300.ms),
            
            const SizedBox(height: 24),
            
            // Task Title
            Text(
              task.title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black87,
                decoration: task.isCompleted ? TextDecoration.lineThrough : null,
              ),
            ).animate()
              .fadeIn(delay: 100.ms, duration: 300.ms)
              .slideY(begin: 0.1, end: 0, delay: 100.ms, duration: 300.ms),
            
            const SizedBox(height: 16),
            
            // Task Description
            if (task.description.isNotEmpty) ...[
              Text(
                'Description',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
              ).animate()
                .fadeIn(delay: 200.ms, duration: 300.ms)
                .slideY(begin: 0.1, end: 0, delay: 200.ms, duration: 300.ms),
              
              const SizedBox(height: 8),
              
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[850] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
                  ),
                ),
                child: Text(
                  task.description,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: isDarkMode ? Colors.white : Colors.black87,
                    height: 1.5,
                  ),
                ),
              ).animate()
                .fadeIn(delay: 300.ms, duration: 300.ms)
                .slideY(begin: 0.1, end: 0, delay: 300.ms, duration: 300.ms),
              
              const SizedBox(height: 24),
            ],
            
            // Task Deadline
            if (task.deadline != null) ...[
              Text(
                'Deadline',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
              ).animate()
                .fadeIn(delay: 400.ms, duration: 300.ms)
                .slideY(begin: 0.1, end: 0, delay: 400.ms, duration: 300.ms),
              
              const SizedBox(height: 8),
              
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[850] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      DateFormat('EEEE, MMMM d, yyyy').format(task.deadline!),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ).animate()
                .fadeIn(delay: 500.ms, duration: 300.ms)
                .slideY(begin: 0.1, end: 0, delay: 500.ms, duration: 300.ms),
              
              const SizedBox(height: 24),
            ],
            
            // Task Tags
            if (task.tags.isNotEmpty) ...[
              Text(
                'Tags',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
              ).animate()
                .fadeIn(delay: 600.ms, duration: 300.ms)
                .slideY(begin: 0.1, end: 0, delay: 600.ms, duration: 300.ms),
              
              const SizedBox(height: 8),
              
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: task.tags.map((tag) {
                  return Chip(
                    label: Text(tag),
                    backgroundColor: colorScheme.primary.withOpacity(0.1),
                    labelStyle: TextStyle(color: colorScheme.primary),
                  );
                }).toList(),
              ).animate()
                .fadeIn(delay: 700.ms, duration: 300.ms)
                .slideY(begin: 0.1, end: 0, delay: 700.ms, duration: 300.ms),
              
              const SizedBox(height: 24),
            ],
            
            // Task Creation Date
            Text(
              'Created',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.white70 : Colors.black54,
              ),
            ).animate()
              .fadeIn(delay: 800.ms, duration: 300.ms)
              .slideY(begin: 0.1, end: 0, delay: 800.ms, duration: 300.ms),
            
            const SizedBox(height: 8),
            
            Text(
              DateFormat('MMMM d, yyyy').format(task.createdAt),
              style: theme.textTheme.bodyLarge?.copyWith(
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ).animate()
              .fadeIn(delay: 900.ms, duration: 300.ms)
              .slideY(begin: 0.1, end: 0, delay: 900.ms, duration: 300.ms),
            
            const SizedBox(height: 32),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: task.isCompleted ? 'Mark as Incomplete' : 'Mark as Complete',
                    icon: task.isCompleted ? Icons.refresh : Icons.check,
                    onPressed: () {
                      taskProvider.toggleTaskCompletion(task.id);
                    },
                    type: task.isCompleted ? ButtonType.outline : ButtonType.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomButton(
                    text: task.isArchived ? 'Unarchive Task' : 'Archive Task',
                    icon: task.isArchived ? Icons.unarchive_outlined : Icons.archive_outlined,
                    onPressed: () {
                      if (task.isArchived) {
                        taskProvider.unarchiveTask(task.id);
                      } else {
                        taskProvider.archiveTask(task.id);
                      }
                      Navigator.pop(context);
                    },
                    type: ButtonType.secondary,
                  ),
                ),
              ],
            ).animate()
              .fadeIn(delay: 1000.ms, duration: 300.ms)
              .slideY(begin: 0.1, end: 0, delay: 1000.ms, duration: 300.ms),
          ],
        ),
      ),
    );
  }
}
