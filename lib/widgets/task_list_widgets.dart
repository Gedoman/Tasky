import 'package:flutter/material.dart';
import 'package:tasky/models/task_model.dart';
import 'package:tasky/widgets/task_item_widget.dart';

class TaskListWidgets extends StatelessWidget {
  const TaskListWidgets({
    super.key,
    required this.tasks,
    required this.onTab,
    required this.onDelete,
    required this.onEdit,
    this.emptyMessage,
  });

  final List<TaskModel> tasks;
  final Function(bool?, int?) onTab;
  final Function(int?) onDelete;
  final Function(TaskModel) onEdit;
  final String? emptyMessage;

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return Center(
        child: Text(
          emptyMessage ?? "No Data",
          style: Theme.of(context).textTheme.labelLarge,
        ),
      );
    }

    return ListView.separated(
      itemCount: tasks.length,
      padding: const EdgeInsets.only(bottom: 60),
      itemBuilder: (context, index) {
        return TaskItemWidget(
          model: tasks[index],
          onChanged: (bool? value) => onTab(value, index),
          onDeleteSelect: (int id) => onDelete(id),
          onEditSelect: (TaskModel task) => onEdit(task),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 6),
    );
  }
}