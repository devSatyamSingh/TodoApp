import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class TaskService {

  final String baseUrl =
      "https://todo-app-f3a53-default-rtdb.firebaseio.com";

  String get uid => FirebaseAuth.instance.currentUser!.uid;

  /// FETCH TASKS
  Future fetchTasks() async {

    final url = Uri.parse("$baseUrl/tasks/$uid.json");

    final response = await http.get(url);

    return jsonDecode(response.body);
  }

  /// ADD TASK
  Future addTask(String title) async {

    final url = Uri.parse("$baseUrl/tasks/$uid.json");

    await http.post(
      url,
      body: jsonEncode({
        "title": title,
        "completed": false
      }),
    );
  }

  /// UPDATE STATUS
  Future updateTask(String taskId, bool status) async {

    final url =
    Uri.parse("$baseUrl/tasks/$uid/$taskId.json");

    await http.patch(
      url,
      body: jsonEncode({
        "completed": status
      }),
    );
  }

  /// EDIT TASK TITLE
  Future editTask(String taskId, String title) async {

    final url =
    Uri.parse("$baseUrl/tasks/$uid/$taskId.json");

    await http.patch(
      url,
      body: jsonEncode({
        "title": title
      }),
    );
  }

  /// DELETE TASK
  Future deleteTask(String taskId) async {

    final url =
    Uri.parse("$baseUrl/tasks/$uid/$taskId.json");

    await http.delete(url);
  }
}