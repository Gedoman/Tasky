import 'package:flutter/material.dart';

import '../models/task_model.dart';
import '../services/task_repository.dart';
import '../widgets/task_list_widgets.dart';
import 'add_task.dart';

class CompleteTasksScreen extends StatefulWidget {
  const CompleteTasksScreen({super.key});

  @override
  State<CompleteTasksScreen> createState() => _CompleteTasksScreenState();
}

class _CompleteTasksScreenState extends State<CompleteTasksScreen> {
  List<TaskModel> tasks = [];
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
      tasks = all.where((t) => t.isDone).toList();
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
      appBar: AppBar(title: const Text("Completed Tasks")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : TaskListWidgets(
          tasks: tasks,
          emptyMessage: "No Task Found",
          onTab: (value, index) async {
            final task = tasks[index!];
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