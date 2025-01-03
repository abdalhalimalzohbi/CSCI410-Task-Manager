import 'package:flutter/material.dart';
import 'package:my_tasks_manager/model/Task.dart';

class TasksListWidget extends StatefulWidget {
  final List<Task> tasks;
  final Function(Task, String) onTaskStatusChanged;
  final Function(Task) deleteTask;
  const TasksListWidget({
    super.key,
    required this.tasks,
    required this.onTaskStatusChanged,
    required this.deleteTask,
  });

  @override
  State<TasksListWidget> createState() => _TasksListWidgetState();
}

class _TasksListWidgetState extends State<TasksListWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: false,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.tasks.length,
      itemBuilder: (context, index) {
        final task = widget.tasks[index];
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: task.status == 'Ongoing'
                ? Colors.blue.shade200
                : Colors.green.shade200,
          ),
          margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
          child: ListTile(
            title: Text(
              task.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(task.description),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.check_circle,
                    color:
                        task.status == 'Ongoing' ? Colors.grey : Colors.green,
                  ),
                  onPressed: () {
                    final newStatus =
                        task.status == 'Ongoing' ? 'Completed' : 'Ongoing';
                    widget.onTaskStatusChanged(task, newStatus);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    widget.deleteTask(task);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
