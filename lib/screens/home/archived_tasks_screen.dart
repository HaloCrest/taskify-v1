import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskify/models/task.dart';
import 'package:taskify/providers/task_provider.dart';
import 'package:taskify/screens/tasks/task_details_screen.dart';
import 'package:taskify/widgets/empty_state.dart';
import 'package:taskify/widgets/task_tile.dart';

class ArchivedTasksScreen extends StatelessWidget {
  const ArchivedTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final archivedTasks = taskProvider.archivedTasks;

    if (archivedTasks.isEmpty) {
      return const EmptyState(
        title: 'No Archived Tasks',
        message: 'Tasks you archive will appear here.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      itemCount: archivedTasks.length,
      itemBuilder: (context, index) {
        final task = archivedTasks[index];
        return Dismissible(
          key: Key(task.id),
          background: Container(
            color: Colors.blue,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 16),
            child: const Icon(
              Icons.unarchive_outlined,
              color: Colors.white,
            ),
          ),
          secondaryBackground: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 16),
            child: const Icon(
              Icons.delete_outline,
              color: Colors.white,
            ),
          ),
          onDismissed: (direction) {
            if (direction == DismissDirection.startToEnd) {
              taskProvider.unarchiveTask(task.id);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Task unarchived'),
                ),
              );
            } else {
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
            }
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
