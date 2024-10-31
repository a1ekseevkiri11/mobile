import 'package:flutter/material.dart';
import 'package:todo/models/task.dart';
import 'package:todo/utils/database_helper.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task;

  const TaskFormScreen({super.key, this.task});

  @override
  // ignore: library_private_types_in_public_api
  _TaskFormScreenState createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
    }
  }

  Future<void> _saveTask() async {
    final title = _titleController.text;
    final description = _descriptionController.text;

    if (title.isEmpty || description.isEmpty) return;

    final task = Task(
      id: widget.task?.id,
      title: title,
      description: description,
    );

    if (widget.task == null) {
      await _dbHelper.insertTask(task);
    } else {
      await _dbHelper.updateTask(task);
    }

    // ignore: use_build_context_synchronously
    Navigator.of(context).pop(true);
  }

  Future<void> _deleteTask() async {
    if (widget.task != null) {
      await _dbHelper.deleteTask(widget.task!.id!);
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge,
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveTask,
              child: const Text('Save'),
            ),
            if (widget.task != null) ...[
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _deleteTask,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
