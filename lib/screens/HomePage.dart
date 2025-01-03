import 'package:flutter/material.dart';
import 'package:my_tasks_manager/model/Task.dart';
import 'package:my_tasks_manager/services/TaskService.dart';
import 'package:my_tasks_manager/widget/TabItem.dart';
import 'package:my_tasks_manager/widget/TasksListWidget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    try {
      List<Task> response = await TaskService().getTasks();
      setState(() {
        tasks = response;
      });
    } catch (e) {
      print("Error fetching tasks: $e");
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
              onPressed: () async {
                final String title = titleController.text.trim();
                final String description = descriptionController.text.trim();

                if (title.isNotEmpty && description.isNotEmpty) {
                  await TaskService().postTask(title, description);
                  await _fetchTasks();
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
                deleteTask: (task) async {
                  await TaskService().deleteTask(task.id.toString());
                  _fetchTasks();
                },
                tasks: tasks.where((task) => task.status == 'Ongoing').toList(),
                onTaskStatusChanged: (task, status) async {
                  await TaskService().updateTaskStatus(task, status);
                  _fetchTasks();
                },
              ),
            ),
            Center(
              child: TasksListWidget(
                tasks:
                    tasks.where((task) => task.status == 'Completed').toList(),
                onTaskStatusChanged: (task, status) async {
                  await TaskService().updateTaskStatus(task, status);
                  _fetchTasks();
                },
                deleteTask: (task) async {
                  await TaskService().deleteTask(task.id.toString());
                  _fetchTasks();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
