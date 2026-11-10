import 'package:flutter/cupertino.dart';
import 'package:tasky/models/task_model.dart';
import 'package:flutter/material.dart';
import '../../core/services/preferences_manager.dart';
import '../../services/task_repository.dart';
import '../../constants/storage_key.dart';
import '../add_task/add_task.dart';

class HomeController with ChangeNotifier{
  List<TaskModel> tasksList = [];

  String? username = "Default";
  String? quote;
  bool isDone = false;
  List<TaskModel> tasks = [];
  int totalTask = 0;
  int totalDoneTask = 0;
  double percent = 0;
  String? userImagePath;

   void init(){

      loadUserData();
      loadTask();

  }

  void loadUserData() {

      username = PreferencesManager().getString(StorageKey.username);
      quote =
          PreferencesManager().getString(StorageKey.quote) ??
              "One task at a time. One step closer.";
      userImagePath = PreferencesManager().getString(StorageKey.userImage);
      notifyListeners();

  }

  Future<void> loadTask() async {
    final all = await TaskRepository.loadAllTasks();
      tasks = all;
      calculatePercent();
      notifyListeners();

  }

  void calculatePercent() {
    totalTask = tasks.length;
    totalDoneTask = tasks.where((e) => e.isDone).length;
    percent = totalTask == 0 ? 0 : totalDoneTask / totalTask;
  }

  Future<void> doneTask(bool? value, int? index) async {
    final task = tasks[index!];
    await TaskRepository.toggleTaskDone(task.id, value ?? false);

      task.isDone = value ?? false;
      calculatePercent();

  }

  Future<void> deleteTask(int? id) async {
    if (id == null) return;
    await TaskRepository.deleteTask(id);
    await loadTask();
  }

  Future<void> editTask(BuildContext context ,TaskModel task) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddTask(task: task)),
    );
    await loadTask();
  }


}