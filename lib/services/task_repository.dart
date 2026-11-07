
import 'dart:convert';

import 'package:tasky/models/task_model.dart';

import '../core/services/preferences_manager.dart';

class TaskRepository {
  static const String _tasksKey = "tasks";

  // ---------- Read ----------

  static Future<List<TaskModel>> loadAllTasks() async {
    final raw = PreferencesManager().getString(_tasksKey);
    if (raw == null) return [];
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded.map((e) => TaskModel.fromJson(e)).toList();
  }

  // ---------- Write ----------

  /// الحفظ يتم دائمًا على القائمة الكاملة، وليس على قائمة مفلترة.
  static Future<void> saveAll(List<TaskModel> tasks) async {
    await PreferencesManager().setString(
      _tasksKey,
      jsonEncode(tasks.map((t) => t.toJson()).toList()),
    );
  }

  /// أكبر id موجود + 1 (بدل length + 1 اللي كان يكرر الـ id بعد الحذف).
  static int _nextId(List<TaskModel> tasks) {
    if (tasks.isEmpty) return 1;
    final maxId = tasks.map((t) => t.id).reduce((a, b) => a > b ? a : b);
    return maxId + 1;
  }

  static Future<TaskModel> addTask({
    required String name,
    required String description,
    required bool isHighPriority,
  }) async {
    final all = await loadAllTasks();
    final task = TaskModel(
      id: _nextId(all),
      taskName: name,
      taskDescription: description,
      isHighPriority: isHighPriority,
    );
    all.add(task);
    await saveAll(all);
    return task;
  }

  /// تعديل مهمة موجودة مع الحفاظ على الـ id وحالة الإنجاز.
  static Future<void> updateTask({
    required int id,
    required String name,
    required String description,
    required bool isHighPriority,
  }) async {
    final all = await loadAllTasks();
    final idx = all.indexWhere((t) => t.id == id);
    if (idx == -1) return;

    all[idx] = TaskModel(
      id: id,
      taskName: name,
      taskDescription: description,
      isHighPriority: isHighPriority,
      isDone: all[idx].isDone,
    );
    await saveAll(all);
  }

  static Future<void> toggleTaskDone(int taskId, bool isDone) async {
    final all = await loadAllTasks();
    final idx = all.indexWhere((t) => t.id == taskId);
    if (idx == -1) return;

    all[idx].isDone = isDone;
    await saveAll(all);
  }

  static Future<void> deleteTask(int taskId) async {
    final all = await loadAllTasks();
    all.removeWhere((t) => t.id == taskId);
    await saveAll(all);
  }

  /// يُستخدم عند تسجيل الخروج.
  static Future<void> clearAll() async {
    await PreferencesManager().remove(_tasksKey);
  }
}
