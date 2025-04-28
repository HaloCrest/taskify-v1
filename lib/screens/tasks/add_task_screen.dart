import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:taskify/models/task.dart';
import 'package:taskify/providers/task_provider.dart';
import 'package:taskify/widgets/custom_button.dart';
import 'package:taskify/widgets/custom_text_field.dart';

class AddTaskScreen extends StatefulWidget {
  final Task? taskToEdit;

  const AddTaskScreen({super.key, this.taskToEdit});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _deadline;
  TaskPriority _priority = TaskPriority.medium;
  final List<String> _tags = [];
  final _tagController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.taskToEdit != null) {
      _titleController.text = widget.taskToEdit!.title;
      _descriptionController.text = widget.taskToEdit!.description;
      _deadline = widget.taskToEdit!.deadline;
      _priority = widget.taskToEdit!.priority;
      _tags.addAll(widget.taskToEdit!.tags);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  Future<void> _saveTask() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        final taskProvider = Provider.of<TaskProvider>(context, listen: false);
        
        if (widget.taskToEdit != null) {
          // Update existing task
          final updatedTask = widget.taskToEdit!.copyWith(
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim(),
            deadline: _deadline,
            priority: _priority,
            tags: _tags,
          );
          
          await taskProvider.updateTask(updatedTask);
        } else {
          // Create new task
          final newTask = Task(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim(),
            deadline: _deadline,
            priority: _priority,
            tags: _tags,
          );
          
          await taskProvider.addTask(newTask);
        }
        
        if (!mounted) return;
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _deadline ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (picked != null && picked != _deadline) {
      setState(() {
        _deadline = picked;
      });
    }
  }

  void _addTag() {
    final tag = _tagController.text.trim();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _tagController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.taskToEdit != null ? 'Edit Task' : 'Add New Task',
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
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            CustomTextField(
              label: 'Task Title',
              hintText: 'Enter task title',
              controller: _titleController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
              prefixIcon: Icons.title,
              autofocus: widget.taskToEdit == null,
            ).animate()
              .fadeIn(duration: 300.ms)
              .slideY(begin: 0.1, end: 0, duration: 300.ms),
            
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Description',
              hintText: 'Enter task description (optional)',
              controller: _descriptionController,
              maxLines: 3,
              prefixIcon: Icons.description_outlined,
            ).animate()
              .fadeIn(delay: 100.ms, duration: 300.ms)
              .slideY(begin: 0.1, end: 0, delay: 100.ms, duration: 300.ms),
            
            const SizedBox(height: 24),
            Text(
              'Priority',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ).animate()
              .fadeIn(delay: 200.ms, duration: 300.ms)
              .slideY(begin: 0.1, end: 0, delay: 200.ms, duration: 300.ms),
            
            const SizedBox(height: 8),
            Row(
              children: [
                _buildPriorityOption(TaskPriority.low, 'Low', Colors.green),
                const SizedBox(width: 16),
                _buildPriorityOption(TaskPriority.medium, 'Medium', Colors.orange),
                const SizedBox(width: 16),
                _buildPriorityOption(TaskPriority.high, 'High', Colors.red),
              ],
            ).animate()
              .fadeIn(delay: 300.ms, duration: 300.ms)
              .slideY(begin: 0.1, end: 0, delay: 300.ms, duration: 300.ms),
            
            const SizedBox(height: 24),
            Text(
              'Deadline',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ).animate()
              .fadeIn(delay: 400.ms, duration: 300.ms)
              .slideY(begin: 0.1, end: 0, delay: 400.ms, duration: 300.ms),
            
            const SizedBox(height: 8),
            InkWell(
              onTap: _selectDate,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                      _deadline != null
                          ? DateFormat('EEEE, MMMM d, yyyy').format(_deadline!)
                          : 'No deadline set',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: _deadline != null
                            ? (isDarkMode ? Colors.white : Colors.black87)
                            : (isDarkMode ? Colors.grey[400] : Colors.grey[600]),
                      ),
                    ),
                    const Spacer(),
                    if (_deadline != null)
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _deadline = null;
                          });
                        },
                        tooltip: 'Clear deadline',
                        iconSize: 20,
                      ),
                  ],
                ),
              ),
            ).animate()
              .fadeIn(delay: 500.ms, duration: 300.ms)
              .slideY(begin: 0.1, end: 0, delay: 500.ms, duration: 300.ms),
            
            const SizedBox(height: 24),
            Text(
              'Tags',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ).animate()
              .fadeIn(delay: 600.ms, duration: 300.ms)
              .slideY(begin: 0.1, end: 0, delay: 600.ms, duration: 300.ms),
            
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    label: '',
                    hintText: 'Add a tag',
                    controller: _tagController,
                    prefixIcon: Icons.tag,
                    onEditingComplete: _addTag,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: _addTag,
                  tooltip: 'Add tag',
                ),
              ],
            ).animate()
              .fadeIn(delay: 700.ms, duration: 300.ms)
              .slideY(begin: 0.1, end: 0, delay: 700.ms, duration: 300.ms),
            
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _tags.map((tag) {
                return Chip(
                  label: Text(tag),
                  deleteIcon: const Icon(Icons.close, size: 16),
                  onDeleted: () => _removeTag(tag),
                  backgroundColor: colorScheme.primary.withOpacity(0.1),
                  labelStyle: TextStyle(color: colorScheme.primary),
                  deleteIconColor: colorScheme.primary,
                );
              }).toList(),
            ).animate()
              .fadeIn(delay: 800.ms, duration: 300.ms)
              .slideY(begin: 0.1, end: 0, delay: 800.ms, duration: 300.ms),
            
            const SizedBox(height: 32),
            CustomButton(
              text: widget.taskToEdit != null ? 'Update Task' : 'Create Task',
              onPressed: _saveTask,
              isLoading: _isLoading,
              height: 56,
            ).animate()
              .fadeIn(delay: 900.ms, duration: 300.ms)
              .slideY(begin: 0.1, end: 0, delay: 900.ms, duration: 300.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityOption(TaskPriority priority, String label, Color color) {
    final isSelected = _priority == priority;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _priority = priority;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? color.withOpacity(0.1)
                : (isDarkMode ? Colors.grey[850] : Colors.grey[100]),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? color
                  : (isDarkMode ? Colors.grey[700]! : Colors.grey[300]!),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? color
                      : (isDarkMode ? Colors.white : Colors.black87),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
