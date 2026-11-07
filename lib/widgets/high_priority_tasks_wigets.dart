import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tasky/core/theme/theme_controller.dart';
import 'package:tasky/models/task_model.dart';

import '../core/widgets/custom_check_box.dart';
import '../core/widgets/custom_svg_picture.dart';
import '../screens/high_priority_screen.dart';

class HighPriorityTasksWidgets extends StatelessWidget {
  const HighPriorityTasksWidgets({
    super.key,
    required this.onTap,
    required this.tasks,
    required this.refresh,
  });

  final List<TaskModel> tasks;
  final Function(bool?, int?) onTap;
  final Function refresh;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "High Priority Tasks",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF15B86C),
                    ),
                  ),
                ),
                ...tasks.where((e) => e.isHighPriority).take(4).map((element) {
                  return Row(
                    children: [
                      CustomCheckBox(
                        value: element.isDone,
                        onChanged: (bool? value) {
                          final index = tasks.indexWhere(
                                (e) => e.id == element.id,
                          );
                          onTap(value, index);
                        },
                      ),
                      Expanded(
                        child: Text(
                          element.taskName,

                          style:

                          element.isDone? Theme.of(context).textTheme.titleLarge:
                          Theme.of(context).textTheme.titleMedium,
                          // TextStyle(
                          //   color: element.isDone
                          //       ? const Color(0xFFa0a0a0)
                          //       : const Color(0xFFFFFCFC),
                          //   fontSize: 18,
                          //   fontWeight: FontWeight.w600,
                          //   decoration: element.isDone
                          //       ? TextDecoration.lineThrough
                          //       : TextDecoration.none,
                          //   decorationColor: const Color(0xFFC6C6C6),
                          // ),
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
          GestureDetector(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return HighPriorityScreen();
                  },
                ),
              );
              refresh();
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 56,
                width: 48,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color:Theme.of(context).colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                  border: Border.all(color: ThemeController.isDark() ?Color(0xFF6E6E6E) : Color(0xFFD1DAD6)),
                ),
                child:CustomSvgPicture(path: "assets/icons/arrow.svg",
                  height: 24,
                  width: 24,
                ),
                // SvgPicture.asset(
                //   "assets/icons/arrow.svg",
                //   height: 24,
                //   width: 24,
                //   colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.secondaryContainer,
                //   BlendMode.srcIn),
                // ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}