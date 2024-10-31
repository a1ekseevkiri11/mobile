import 'package:calendar/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:calendar/screens/calendar_screen.dart';

void main() {
  initializeDateFormatting('ru_RU', null).then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendar',
      theme: dartTheme,
      debugShowCheckedModeBanner: false,
      home: const Calendar(),
    );
  }
}

