import 'dart:io';

import 'package:flutter/material.dart';

import 'package:tasky/models/task_model.dart';
import 'package:tasky/features/add_task/add_task.dart';
import 'package:tasky/features/home/components/high_priority_tasks_wigets.dart';
import '../../constants/storage_key.dart';
import '../../core/services/preferences_manager.dart';
import '../../core/widgets/custom_svg_picture.dart';
import '../../services/task_repository.dart';
import 'components/achieved_tasks_widgets.dart';
import 'components/sliver_task_list_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? username = "Default";
  String? quote;
  bool isDone = false;
  List<TaskModel> tasks = [];
  int totalTask = 0;
  int totalDoneTask = 0;
  double percent = 0;
  String? userImagePath;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadTask();
  }

  void _calculatePercent() {
    totalTask = tasks.length;
    totalDoneTask = tasks.where((e) => e.isDone).length;
    percent = totalTask == 0 ? 0 : totalDoneTask / totalTask;
  }

  Future<void> _doneTask(bool? value, int? index) async {
    final task = tasks[index!];
    await TaskRepository.toggleTaskDone(task.id, value ?? false);
    setState(() {
      task.isDone = value ?? false;
      _calculatePercent();
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
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: userImagePath == null
                              ? AssetImage('assets/images/person.jpeg')
                              : FileImage(File(userImagePath!)),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Good Evening ,$username",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              quote ?? "One task at a time.One step closer.",
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Kyuhyun ,Your work Is ",
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    Row(
                      children: [
                        Text(
                          "almost done ! ",
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        const CustomSvgPicture.withoutColor(
                          path: "assets/images/waving_hand.svg",
                        ),
                      ],
                    ),
                    AchievedTasksWidgets(
                      totalTask: totalTask,
                      totalDoneTask: totalDoneTask,
                      percent: percent,
                    ),
                    const SizedBox(height: 8),
                    HighPriorityTasksWidgets(
                      tasks: tasks,
                      onTap: (bool? value, int? index) {
                        _doneTask(value, index);
                      },
                      refresh: () {
                        _loadTask();
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 24, bottom: 16),
                      child: Text(
                        "My Task",
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverTaskListWidgets(
                tasks: tasks,
                emptyMessage: "No Data",
                onTab: (bool? value, int? index) {
                  _doneTask(value, index);
                },
                onDelete: _deleteTask,
                onEdit: _editTask,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 60)),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        height: 40,
        child: FloatingActionButton.extended(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const AddTask(),
              ),
            );
            await _loadTask();
          },
          label: const Text("Add New Task"),
          icon: const Icon(Icons.add),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  void _loadUserData() {
    setState(() {
      username = PreferencesManager().getString(StorageKey.username);
      quote =
          PreferencesManager().getString("quote") ??
          "One task at a time. One step closer.";
      userImagePath = PreferencesManager().getString("user_image");
    });
  }

  Future<void> _loadTask() async {
    final all = await TaskRepository.loadAllTasks();
    if (!mounted) return;
    setState(() {
      tasks = all;
      _calculatePercent();
    });
  }
}
