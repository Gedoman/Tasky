import 'package:flutter/material.dart';

import 'package:tasky/core/widgets/custom_text_form_field.dart';
import 'package:tasky/models/task_model.dart';
import 'package:tasky/services/task_repository.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key, this.task});

  /// إذا تم تمريرها تتحول الشاشة إلى وضع التعديل.
  final TaskModel? task;

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  late final TextEditingController taskNameController;
  late final TextEditingController taskDescriptionController;
  late bool isHighPriority;

  bool get isEditing => widget.task != null;

  @override
  void initState() {
    super.initState();
    taskNameController = TextEditingController(text: widget.task?.taskName);
    taskDescriptionController = TextEditingController(
      text: widget.task?.taskDescription,
    );
    isHighPriority = widget.task?.isHighPriority ?? true;
  }

  @override
  void dispose() {
    taskNameController.dispose();
    taskDescriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_key.currentState?.validate() ?? false)) return;

    final name = taskNameController.text.trim();
    final description = taskDescriptionController.text.trim();

    if (isEditing) {
      await TaskRepository.updateTask(
        id: widget.task!.id,
        name: name,
        description: description,
        isHighPriority: isHighPriority,
      );
    } else {
      await TaskRepository.addTask(
        name: name,
        description: description,
        isHighPriority: isHighPriority,
      );
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? "Edit Task" : "New Task")),
      body: SafeArea(
        child: Form(
          key: _key,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                CustomTextFormField(
                  controller: taskNameController,
                  hintText: "Finish UI design for login screen",
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please Enter Task Name";
                    }
                    return null;
                  },
                  title: 'Task Name',
                ),
                const SizedBox(height: 28),
                CustomTextFormField(
                  controller: taskDescriptionController,
                  maxLines: 5,
                  hintText:
                  "Finish onboarding UI and hand off to devs by Thursday.",
                  title: 'Task Description',
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "High Priority",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Switch(
                      value: isHighPriority,
                      onChanged: (bool value) {
                        setState(() => isHighPriority = value);
                      },
                      activeTrackColor: const Color(0xFF15B86C),
                    ),
                  ],
                ),
                const Spacer(),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(MediaQuery.of(context).size.width, 40),
                  ),
                  onPressed: _submit,
                  label: Text(isEditing ? "Save Changes" : "Add New Task"),
                  icon: Icon(isEditing ? Icons.save : Icons.add),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}