import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky/features/home/home_controller.dart';
import 'package:tasky/models/task_model.dart';
import 'package:tasky/components/task_item_widget.dart';

class SliverTaskListWidgets extends StatelessWidget {
  const SliverTaskListWidgets({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (BuildContext context, HomeController controller, Widget? child) {
        final tasks = controller.tasks;
        return tasks.isEmpty
            ? SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                "No Data",
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ),
        )
            : SliverList.separated(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            return TaskItemWidget(
              model: tasks[index],
              onChanged: (bool? value) => controller.doneTask(value, index),
              onDeleteSelect: (int id) => controller.deleteTask(id),
              onEditSelect: (TaskModel task) => controller.editTask(context, task),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(height: 6),
        );
      },
    );
  }
}
