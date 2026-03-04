import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/task_provider.dart';
import '../widgets/add_task_dialog.dart';
import '../widgets/task_list_section.dart';
import '../widgets/task_tile.dart';
import '../../domain/entities/task.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const String name = '/home';
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      if (auth.user != null) {
        context.read<TaskProvider>().listenTasks(auth.user!.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("TaskFlow"),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async => await auth.logout(),
            ),
          ],
        ),
        body: const TaskListSection(),
        floatingActionButton: const AddTaskButton(),
      ),
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
