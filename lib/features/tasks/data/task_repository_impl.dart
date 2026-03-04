import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/entities/task.dart';
import '../domain/repositories/task_repositories.dart';

class TaskRepositoryImpl implements TaskRepository {
  final FirebaseFirestore _firestore;

  TaskRepositoryImpl(this._firestore);

  CollectionReference _taskRef(String uid) =>
      _firestore.collection('users').doc(uid).collection('tasks');

  @override
  Stream<List<Task>> watchTasks(String uid) {
    return _taskRef(uid).orderBy('createdAt', descending: true).snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;

          return Task(
            id: doc.id,
            title: data['title'],
            description: data['description'],
            isCompleted: data['isCompleted'],
            createdAt: (data['createdAt'] as Timestamp).toDate(),
          );
        }).toList();
      },
    );
  }

  @override
  Future<void> addTask(String uid, Task task) async {
    await _taskRef(uid).add({
      'title': task.title,
      'description': task.description,
      'isCompleted': task.isCompleted,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> updateTask(String uid, Task task) async {
    await _taskRef(uid).doc(task.id).update({
      'title': task.title,
      'description': task.description,
      'isCompleted': task.isCompleted,
    });
  }

  @override
  Future<void> deleteTask(String uid, String taskId) async {
    await _taskRef(uid).doc(taskId).delete();
  }
}
