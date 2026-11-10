import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky/features/home/home_controller.dart';

import 'package:tasky/models/task_model.dart';
import 'package:tasky/features/add_task/add_task.dart';
import 'package:tasky/features/home/components/high_priority_tasks_wigets.dart';
import '../../constants/storage_key.dart';
import '../../core/services/preferences_manager.dart';
import '../../core/widgets/custom_svg_picture.dart';
import '../../services/task_repository.dart';
import 'components/achieved_tasks_widgets.dart';
import 'components/sliver_task_list_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final HomeController controller = context.read<HomeController>();
    return ChangeNotifierProvider<HomeController>(
      create: (BuildContext context) => HomeController()..init(),
      child:Scaffold(
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
                              Selector<HomeController, String?>(
                                selector: (context, HomeController controller)=> controller.userImagePath,
                                builder: (BuildContext context, String? userImagePath, Widget? child) {
                                  return  CircleAvatar(
                                    backgroundImage: userImagePath == null
                                        ? AssetImage('assets/images/person.jpeg')
                                        : FileImage(File(userImagePath)),
                                  );
                                },
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Selector<HomeController, String?>(
                                    selector: (context, controller) =>
                                        controller.username,
                                    builder:
                                        (
                                          BuildContext context,
                                          String? username,
                                          Widget? child,
                                        ) {
                                          return Text(
                                            "Good Evening ,$username",
                                            style: Theme.of(
                                              context,
                                            ).textTheme.titleMedium,
                                          );
                                        },
                                  ),
                                  Selector<HomeController, String?>(
                                    selector:(context, controller)=> controller.quote ,
                                    builder: (BuildContext context, String? quote, Widget? child) {
                                      return Text(
                                        quote ??
                                            "One task at a time.One step closer.",
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleSmall,
                                      );
                                    },
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
                          AchievedTasksWidgets(),
                          const SizedBox(height: 8),
                          HighPriorityTasksWidgets(),
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
                    sliver: SliverTaskListWidgets(),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 60)),
                ],
              ),
            ),
            floatingActionButton: SizedBox(
              height: 40,
              child: Builder(
                builder: (controllerContext) {
                  return FloatingActionButton.extended(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => const AddTask(),
                        ),
                      );
                      controllerContext.read<HomeController>().loadTask();
                    },
                    label: const Text("Add New Task"),
                    icon: const Icon(Icons.add),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  );
                }
              ),
            ),
          ),

    );
  }
}
