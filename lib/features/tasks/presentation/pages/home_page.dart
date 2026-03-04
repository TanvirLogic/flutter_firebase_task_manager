import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/task_provider.dart';
import '../widgets/add_task_dialog.dart';
import '../widgets/task_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const String name ='/home';
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    final auth = context.read<AuthProvider>();
    final taskProvider = context.read<TaskProvider>();

    taskProvider.listenTasks(auth.user!.uid);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("TaskFlow"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.logout();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(child: const TaskListSection()),
      floatingActionButton: const AddTaskButton(),
    );
  }
}

class TaskListSection extends StatelessWidget {
  const TaskListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, _) {
        if (taskProvider.tasks.isEmpty) {
          return const Center(child: Text("No tasks yet"));
        }

        return ListView.builder(
          itemCount: taskProvider.tasks.length,
          itemBuilder: (context, index) {
            final task = taskProvider.tasks[index];

            return TaskTile(task: task);
          },
        );
      },
    );
  }
}

class AddTaskButton extends StatelessWidget {
  const AddTaskButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(context: context, builder: (_) => const AddTaskDialog());
      },
      child: const Icon(Icons.add),
    );
  }
}
