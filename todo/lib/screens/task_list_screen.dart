import 'package:flutter/material.dart';
import 'package:todo/models/task.dart';
import 'package:todo/utils/database_helper.dart';
import 'package:todo/screens/task_form_screen.dart';

enum TaskFilter { all, completed, incomplete }

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Task> _tasks = [];
  TaskFilter _filter = TaskFilter.all;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await _dbHelper.getTasks();
    setState(() {
      _tasks = tasks;
    });
  }

  void _openTaskForm({Task? task}) async {
    final isUpdated = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TaskFormScreen(task: task),
      ),
    );

    if (isUpdated == true) {
      _loadTasks();
    }
  }

  List<Task> _getFilteredTasks() {
    switch (_filter) {
      case TaskFilter.completed:
        return _tasks.where((task) => task.completed).toList();
      case TaskFilter.incomplete:
        return _tasks.where((task) => !task.completed).toList();
      case TaskFilter.all:
      default:
        return _tasks;
    }
  }

  String _getShortDescription(String description) {
    return description.length > 200 ? '${description.substring(0, 200)}...' : description;
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks = _getFilteredTasks();

    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo'),
        actions: [
          DropdownButton<TaskFilter>(
            value: _filter,
            icon: const Icon(Icons.filter_list, color: Colors.black),
            dropdownColor: Theme.of(context).appBarTheme. backgroundColor,
            underline: const SizedBox(),
            items: const [
              DropdownMenuItem(
                value: TaskFilter.all,
                child: Text("All"),
              ),
              DropdownMenuItem(
                value: TaskFilter.completed,
                child: Text("Completed"),
              ),
              DropdownMenuItem(
                value: TaskFilter.incomplete,
                child: Text("Incomplete"),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _filter = value!;
              });
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredTasks.length,
        itemBuilder: (context, index) {
          final task = filteredTasks[index];
          return ListTile(
            title: Text(task.title),
            subtitle: Text(_getShortDescription(task.description)),
            trailing: IconButton(
              icon: Icon(
                task.completed ? Icons.check_box : Icons.check_box_outline_blank,
              ),
              onPressed: () async {
                task.toggleCompletion();
                await _dbHelper.updateTask(task);
                _loadTasks();
              },
            ),
            onTap: () => _openTaskForm(task: task),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openTaskForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
