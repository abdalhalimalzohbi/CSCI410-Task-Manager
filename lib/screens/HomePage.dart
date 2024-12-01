import 'package:flutter/material.dart';
import 'package:my_tasks_manager/model/Task.dart';
import 'package:my_tasks_manager/widget/TabItem.dart';
import 'package:my_tasks_manager/widget/TasksListWidget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  final List<Task> tasks = [
    Task(
      title: 'Prepare Project Proposal',
      description:
          'Draft and submit the initial proposal for the upcoming project to the client.',
      status: 'Ongoing',
    ),
    Task(
      title: 'Finalize UI/UX Design',
      description:
          'Incorporate feedback from the design review meeting and finalize the UI/UX.',
      status: 'Completed',
    ),
    Task(
      title: 'Develop Authentication Module',
      description:
          'Implement login, registration, and password recovery features.',
      status: 'Ongoing',
    ),
    Task(
      title: 'Conduct Code Review',
      description:
          'Review the codebase for the new features implemented in Sprint 2.',
      status: 'Completed',
    ),
    Task(
      title: 'Set Up CI/CD Pipeline',
      description: 'Configure Jenkins for automated testing and deployment.',
      status: 'Ongoing',
    ),
    Task(
      title: 'Prepare Sprint Retrospective',
      description:
          'Document the successes, challenges, and lessons learned during Sprint 2.',
      status: 'Completed',
    ),
  ];

  void updateTaskStatus(Task task, String newStatus) {
    setState(() {
      final index = tasks.indexOf(task);
      if (index != -1) {
        tasks[index] = Task(
          title: task.title,
          description: task.description,
          status: newStatus,
        );
      }
    });
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
          leading: IconButton(onPressed: (){}, icon: Icon(Icons.add)),
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
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
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
                tasks: tasks.where((task) => task.status == 'Completed').toList(),
                onTaskStatusChanged: updateTaskStatus,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
