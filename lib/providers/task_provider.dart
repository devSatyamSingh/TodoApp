import 'package:flutter/material.dart';
import '../service/task_service.dart';

class TaskProvider extends ChangeNotifier {

  List tasks = [];

  bool loading = false;

  final TaskService _service = TaskService();

  Future loadTasks() async {

    loading = true;
    notifyListeners();

    final data = await _service.fetchTasks();

    tasks = [];

    if (data != null) {

      data.forEach((id, task) {

        tasks.add({
          "id": id,
          "title": task["title"],
          "completed": task["completed"]
        });

      });

    }

    loading = false;
    notifyListeners();
  }

  Future addTask(String title) async {

    await _service.addTask(title);

    await loadTasks();
  }

  Future updateTask(String id, bool status) async {

    await _service.updateTask(id, status);

    await loadTasks();
  }

  Future editTask(String id, String title) async {

    await _service.editTask(id, title);

    await loadTasks();
  }

  Future deleteTask(String id) async {

    await _service.deleteTask(id);

    await loadTasks();
  }
}