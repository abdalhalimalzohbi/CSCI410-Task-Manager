import 'package:my_tasks_manager/model/Task.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class TaskService {
  updateTaskStatus(Task task, String newStatus) async {
    print("Task ID: ${task.id}, New Status: $newStatus");
    String serverPath =
        "http://10.0.2.2:80/my_tasks_manager/CSCI410/updateTaskStatus.php";
    Uri url = Uri.parse(serverPath);
    try {
      var response = await http.post(
        url,
        body: {"id": task.id.toString(), "status": newStatus},
      );
      await getTasks();
    } catch (e) {
      print("Error: $e");
    }
  }

  postTask(String title, String desc) async {
    String serverPath =
        "http://10.0.2.2:80/my_tasks_manager/CSCI410/addTask.php";
    Uri url = Uri.parse(serverPath);
    try {
      var response = await http.post(url,
          body: {"title": title, "description": desc, "status": "Ongoing"});
      await getTasks();
    } catch (e) {
      print(e);
    }
  }

  getTasks() async {
    String serverPath =
        "http://10.0.2.2:80/my_tasks_manager/CSCI410/getTasks.php";
    Uri url = Uri.parse(serverPath);
    try {
      print("Getting tasks");
      var response = await http.get(url);
      if (response.statusCode == 200) {
        List<Task> tasks = [];
        var data = convert.jsonDecode(response.body);
        for (var task in data) {
          tasks.add(Task(
            id: int.tryParse(task['id']),
            title: task['title'],
            description: task['description'],
            status: task['status'],
          ));
        }
        return tasks;
      }
    } catch (e) {
      print(e);
    }
  }

   deleteTask(String id) async {
    String serverPath =
        "http://10.0.2.2:80/my_tasks_manager/CSCI410/deleteTask.php";
    Uri url = Uri.parse(serverPath);
    try {
      var response = await http.post(
        url,
        body: {"id": id},
      );
      if (response.statusCode == 200) {
        print("Task deleted successfully");
      } else {
        print("Error deleting task: ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}
