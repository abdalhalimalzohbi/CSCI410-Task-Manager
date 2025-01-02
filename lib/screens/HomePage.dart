import 'package:flutter/material.dart';
import 'package:my_tasks_manager/model/Task.dart';
import 'package:my_tasks_manager/widget/TabItem.dart';
import 'package:my_tasks_manager/widget/TasksListWidget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final List<Task> tasks = [];

@override
void initState() {
  super.initState();
  getTasks();
}

  void updateTaskStatus(Task task, String newStatus) async {
    String serverPath = "http://192.168.10.1:80/CSCI410/my_tasks_manager/updateTaskStatus.php";
    Uri url = Uri.parse(serverPath);
    var response =
        await http.put(url, body: {"id": task.id, "status": newStatus});
  }

  postTask() async {
    String serverPath = "http://192.168.10.1:80/my_tasks_manager/CSCI410/addTask.php";
    Uri url = Uri.parse(serverPath);
    var response = await http.post(url, body: {
      "title": titleController.text,
      "description": descriptionController.text,
      "status": "Ongoing"
    });
    await getTasks();
  }

  getTasks() async {
    String serverPath = "http://192.168.10.1:80/my_tasks_manager/CSCI410/getTasks.php";
    Uri url = Uri.parse(serverPath);
    try {
      print("Getting tasks");
      var response = await http.get(url);
      if (response.statusCode == 200) {
        tasks.clear();
        var data = convert.jsonDecode(response.body);
        for (var task in data) {
          tasks.add(Task(
            id: task['id'],
            title: task['title'],
            description: task['description'],
            status: task['status'],
          ));
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Task Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration:
                    const InputDecoration(labelText: 'Task Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final String title = titleController.text.trim();
                final String description = descriptionController.text.trim();

                if (title.isNotEmpty && description.isNotEmpty) {
                  postTask();
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'My Tasks',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          leading: IconButton(
            onPressed: _showAddTaskDialog,
            icon: const Icon(Icons.add),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.all(6),
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        color: Colors.grey[100],
                      ),
                      child: const TabBar(
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerColor: Colors.transparent,
                        indicator: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.black45,
                        tabs: [
                          TabItem(title: 'In Progress'),
                          TabItem(title: 'Completed'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Center(
              child: TasksListWidget(
                tasks: tasks.where((task) => task.status == 'Ongoing').toList(),
                onTaskStatusChanged: updateTaskStatus,
              ),
            ),
            Center(
              child: TasksListWidget(
                tasks:
                    tasks.where((task) => task.status == 'Completed').toList(),
                onTaskStatusChanged: updateTaskStatus,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
