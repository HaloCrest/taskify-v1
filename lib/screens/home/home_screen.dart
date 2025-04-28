import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:taskify/models/task.dart';
import 'package:taskify/providers/auth_provider.dart';
import 'package:taskify/providers/task_provider.dart';
import 'package:taskify/providers/theme_provider.dart';
import 'package:taskify/screens/auth/login_screen.dart';
import 'package:taskify/screens/home/archived_tasks_screen.dart';
import 'package:taskify/screens/home/completed_tasks_screen.dart';
import 'package:taskify/screens/home/settings_screen.dart';
import 'package:taskify/screens/tasks/add_task_screen.dart';
import 'package:taskify/screens/tasks/task_details_screen.dart';
import 'package:taskify/widgets/empty_state.dart';
import 'package:taskify/widgets/sidebar_menu_item.dart';
import 'package:taskify/widgets/task_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;
    final authProvider = Provider.of<AuthProvider>(context);
    final taskProvider = Provider.of<TaskProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final user = authProvider.currentUser;
    final activeTasks = taskProvider.activeTasks;
    final completedTasks = taskProvider.completedTasks;
    final archivedTasks = taskProvider.archivedTasks;

    // Screens to show based on selected index
    final screens = [
      _buildHomeContent(activeTasks, taskProvider),
      const CompletedTasksScreen(),
      const ArchivedTasksScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          _getAppBarTitle(),
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              color: isDarkMode ? Colors.white70 : Colors.black54,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
            tooltip: isDarkMode ? 'Light Mode' : 'Dark Mode',
          ),
          IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              color: isDarkMode ? Colors.white70 : Colors.black54,
            ),
            onPressed: () {},
            tooltip: 'Notifications',
          ),
          const SizedBox(width: 8),
        ],
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: isDarkMode ? Colors.white70 : Colors.black54,
          ),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: Drawer(
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                user?.name ?? 'Guest User',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text(user?.email ?? 'guest@example.com'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: user?.photoUrl != null
                    ? NetworkImage(user!.photoUrl!)
                    : null,
                backgroundColor: colorScheme.primary,
                child: user?.photoUrl == null
                    ? Text(
                        user?.name?.substring(0, 1).toUpperCase() ?? 'G',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                    : null,
              ),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primary,
                    colorScheme.primary.withBlue(colorScheme.primary.blue + 20),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            SidebarMenuItem(
              title: 'Home',
              icon: Icons.home_outlined,
              isSelected: _selectedIndex == 0,
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                });
                Navigator.pop(context);
              },
              badgeCount: activeTasks.length,
            ),
            SidebarMenuItem(
              title: 'Completed Tasks',
              icon: Icons.check_circle_outline,
              isSelected: _selectedIndex == 1,
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                });
                Navigator.pop(context);
              },
              badgeCount: completedTasks.length,
            ),
            SidebarMenuItem(
              title: 'Archived Tasks',
              icon: Icons.archive_outlined,
              isSelected: _selectedIndex == 2,
              onTap: () {
                setState(() {
                  _selectedIndex = 2;
                });
                Navigator.pop(context);
              },
              badgeCount: archivedTasks.length,
            ),
            const Divider(),
            SidebarMenuItem(
              title: 'Settings',
              icon: Icons.settings_outlined,
              isSelected: _selectedIndex == 3,
              onTap: () {
                setState(() {
                  _selectedIndex = 3;
                });
                Navigator.pop(context);
              },
            ),
            SidebarMenuItem(
              title: 'Logout',
              icon: Icons.logout_outlined,
              isSelected: false,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          authProvider.logout();
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                            (route) => false,
                          );
                        },
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: screens[_selectedIndex],
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => const AddTaskScreen(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                  ),
                );
              },
              backgroundColor: colorScheme.primary,
              child: const Icon(Icons.add),
            ).animate()
              .scale(
                begin: const Offset(0, 0),
                end: const Offset(1, 1),
                duration: 300.ms,
                curve: Curves.elasticOut,
              )
          : null,
    );
  }

  String _getAppBarTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'My Tasks';
      case 1:
        return 'Completed Tasks';
      case 2:
        return 'Archived Tasks';
      case 3:
        return 'Settings';
      default:
        return 'Taskify';
    }
  }

  Widget _buildHomeContent(List<Task> tasks, TaskProvider taskProvider) {
    if (tasks.isEmpty) {
      return EmptyState(
        title: 'No Tasks Yet',
        message: 'Add your first task by tapping the + button below.',
        buttonText: 'Add Task',
        onButtonPressed: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => const AddTaskScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            ),
          );
        },
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskCard(
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
          onDelete: () {
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
                      Navigator.pop(context);
                    },
                    child: const Text('Delete'),
                  ),
                ],
              ),
            );
          },
          onEdit: () {
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
        );
      },
    );
  }
}
