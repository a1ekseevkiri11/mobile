import 'package:flutter/material.dart';

import 'package:converter/features/converter_list/value_list.dart';
import 'package:converter/features/converter/view/converter_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'converter',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 242, 255, 0)
        ),

        dividerColor: Colors.white24,
        listTileTheme: const ListTileThemeData(
          iconColor: Colors.white,
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 139, 139, 139),
        primarySwatch: Colors.pink,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
      ),

      initialRoute: '/home',
      debugShowCheckedModeBanner: false,
      routes: {
        '/home': (context) => const ValueListScreen(),
        '/converter': (context) => const ConverterScreen(),
      }
    );
  }
}