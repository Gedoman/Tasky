import 'package:flutter/material.dart';
import 'package:tasky/models/task_model.dart';
import 'package:tasky/widgets/task_item_widget.dart';

class SliverTaskListWidgets extends StatelessWidget {
  const SliverTaskListWidgets({
    super.key,
    required this.tasks,
    required this.onTab,
    required this.onDelete,
    required this.onEdit,
    required this.emptyMessage,
  });

  final List<TaskModel> tasks;
  final Function(bool?, int?) onTab;
  final Function(int?) onDelete;
  final Function(TaskModel) onEdit;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Center(
            child: Text(
              emptyMessage,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
        ),
      );
    }

    return SliverList.separated(
      itemCount: tasks.length,
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