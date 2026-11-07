import 'package:flutter/material.dart';
import 'package:tasky/models/task_model.dart';

import '../core/enums/task_item_action_enum.dart';
import '../core/widgets/custom_check_box.dart';

class TaskItemWidget extends StatelessWidget {
  const TaskItemWidget({
    super.key,
    required this.model,
    required this.onChanged,
    required this.onDeleteSelect,
    required this.onEditSelect,
  });

  final TaskModel model;
  final Function(bool?) onChanged;
  final Function(int) onDeleteSelect;
  final Function(TaskModel) onEditSelect;

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Delete Task"),
        content: Text('Are you sure you want to delete "${model.taskName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(dialogContext).colorScheme.error,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirmed == true) onDeleteSelect(model.id);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 56),
      padding: const EdgeInsets.symmetric(vertical: 8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.transparent : const Color(0xFFD1DAD6),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomCheckBox(
            value: model.isDone,
            onChanged: (bool? value) => onChanged(value),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  model.taskName,
                  style: model.isDone
                      ? theme.textTheme.titleLarge
                      : theme.textTheme.titleMedium,
                ),
                if (model.taskDescription.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    model.taskDescription,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          PopupMenuButton<TaskItemActionEnum>(
            icon: Icon(
              Icons.more_vert,
              color: isDark
                  ? (model.isDone
                  ? const Color(0xFFA0A0A0)
                  : const Color(0xFFC6C6C6))
                  : (model.isDone
                  ? const Color(0xFF6A6A6A)
                  : const Color(0xFF3A4640)),
            ),
            onSelected: (action) {
              switch (action) {
                case TaskItemActionEnum.delete:
                  _confirmDelete(context);
                case TaskItemActionEnum.edit:
                  onEditSelect(model);
              }
            },
            itemBuilder: (context) => TaskItemActionEnum.values
                .map(
                  (e) => PopupMenuItem<TaskItemActionEnum>(
                value: e,
                child: Text(e.name),
              ),
            )
                .toList(),
          ),
        ],
      ),
    );
  }
}