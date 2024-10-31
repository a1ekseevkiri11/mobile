import 'package:flutter/material.dart';

import 'package:todo/screens/task_list_screen.dart';
import 'package:todo/theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo',
      theme: dartTheme,

      home: const TaskListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}