import 'package:flutter/material.dart';
import 'package:flutter_firebase_task_manager/features/tasks/presentation/widgets/task_tile.dart';
import 'package:provider/provider.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/task.dart';
import '../providers/task_provider.dart';

class TaskListSection extends StatelessWidget {
  const TaskListSection({super.key});

  void _showEditDialog(BuildContext context, Task task) {
    final titleController = TextEditingController(text: task.title);
    final descController = TextEditingController(text: task.description);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Task"),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: "Title"),
                  validator: (value) => value!.isEmpty ? "Enter title" : null,
                ),
                TextFormField(
                  controller: descController,
                  decoration: const InputDecoration(labelText: "Description"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final auth = context.read<AuthProvider>();
                  final taskProvider = context.read<TaskProvider>();

                  await taskProvider.updateTask(
                    auth.user!.uid,
                    task.id,
                    titleController.text.trim(),
                    descController.text.trim(),
                  );
                  if (context.mounted) Navigator.pop(context);
                }
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, _) {
        if (taskProvider.tasks.isEmpty) {
          return const Center(child: Text("No tasks yet"));
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: taskProvider.tasks.length,
                itemBuilder: (context, index) {
                  final task = taskProvider.tasks[index];

                  return InkWell(
                    onTap: () => _showEditDialog(context, task),
                    child: TaskTile(task: task),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
