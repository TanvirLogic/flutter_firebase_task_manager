import 'package:flutter/cupertino.dart';

import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repositories.dart';

class TaskProvider with ChangeNotifier {
  final TaskRepository _repository;

  List<Task> _tasks = [];
  bool _isLoading = false;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;

  TaskProvider(this._repository);

  void listenTasks(String uid) {
    _repository.watchTasks(uid).listen((tasks) {
      _tasks = tasks;
      notifyListeners();
    });
  }

  Future<void> addTask(String uid, String title, String description) async {
    final task = Task(
      id: '',
      title: title,
      description: description,
      isCompleted: false,
      createdAt: DateTime.now(),
    );

    await _repository.addTask(uid, task);
  }

  Future<void> toggleTask(String uid, Task task) async {
    await _repository.updateTask(
      uid,
      Task(
        id: task.id,
        title: task.title,
        description: task.description,
        isCompleted: !task.isCompleted,
        createdAt: task.createdAt,
      ),
    );
  }

  Future<void> deleteTask(String uid, String taskId) async {
    await _repository.deleteTask(uid, taskId);
  }

  Future<void> updateTask(
    String uid,
    String taskId,
    String newTitle,
    String newDescription,
  ) async {
    // Find the existing task to preserve its other properties (like createdAt and isCompleted)
    final existingTask = _tasks.firstWhere((t) => t.id == taskId);

    await _repository.updateTask(
      uid,
      Task(
        id: taskId,
        title: newTitle,
        description: newDescription,
        isCompleted: existingTask.isCompleted,
        createdAt: existingTask.createdAt,
      ),
    );
  }
}
