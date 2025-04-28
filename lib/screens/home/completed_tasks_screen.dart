import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskify/models/task.dart';
import 'package:taskify/providers/task_provider.dart';
import 'package:taskify/screens/tasks/task_details_screen.dart';
import 'package:taskify/widgets/empty_state.dart';
import 'package:taskify/widgets/task_tile.dart';

class CompletedTasksScreen extends StatelessWidget {
  const CompletedTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final completedTasks = taskProvider.completedTasks;

    if (completedTasks.isEmpty) {
      return const EmptyState(
        title: 'No Completed Tasks',
        message: 'Tasks you complete will appear here.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      itemCount: completedTasks.length,
      itemBuilder: (context, index) {
        final task = completedTasks[index];
        return Dismissible(
          key: Key(task.id),
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 16),
            child: const Icon(
              Icons.delete_outline,
              color: Colors.white,
            ),
          ),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            taskProvider.deleteTask(task.id);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Task deleted'),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () {
                    taskProvider.addTask(task);
                  },
                ),
              ),
            );
          },
          child: TaskTile(
            task: task,
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => TaskDetailsScreen(taskId: task.id),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.1),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                ),
              );
            },
            onToggleCompletion: (isCompleted) {
              taskProvider.toggleTaskCompletion(task.id);
            },
          ),
        );
      },
    );
  }
}
