import 'package:flutter/material.dart';

import '../models/task_model.dart';
import '../services/task_repository.dart';
import '../widgets/task_list_widgets.dart';
import 'add_task.dart';

class HighPriorityScreen extends StatefulWidget {
  const HighPriorityScreen({super.key});

  @override
  State<HighPriorityScreen> createState() => _HighPriorityScreenState();
}

class _HighPriorityScreenState extends State<HighPriorityScreen> {
  List<TaskModel> highPriorityTasks = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadTask();
  }

  Future<void> _loadTask() async {
    setState(() => isLoading = true);
    final all = await TaskRepository.loadAllTasks();
    if (!mounted) return;
    setState(() {
      highPriorityTasks = all.where((t) => t.isHighPriority).toList();
      isLoading = false;
    });
  }

  Future<void> _deleteTask(int? id) async {
    if (id == null) return;
    await TaskRepository.deleteTask(id);
    await _loadTask();
  }

  Future<void> _editTask(TaskModel task) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddTask(task: task)),
    );
    await _loadTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("High Priority Tasks")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : TaskListWidgets(
          tasks: highPriorityTasks,
          emptyMessage: "No Task Found",
          onTab: (value, index) async {
            final task = highPriorityTasks[index!];
            await TaskRepository.toggleTaskDone(task.id, value ?? false);
            await _loadTask();
          },
          onDelete: _deleteTask,
          onEdit: _editTask,
        ),
      ),
    );
  }
}