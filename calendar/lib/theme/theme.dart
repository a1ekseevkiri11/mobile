import 'package:flutter/material.dart';

final dartTheme = ThemeData(
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(255, 242, 255, 0),
    titleTextStyle: TextStyle(
      fontWeight: FontWeight.w900,
      fontSize: 30,
      color: Color.fromARGB(255, 0, 0, 0),
    ),
  ),
  dividerColor: Colors.white24,
  listTileTheme: const ListTileThemeData(
    iconColor: Colors.white,
    textColor: Colors.white,
    subtitleTextStyle: TextStyle(
      color: Colors.grey,
    ),
  ),
  scaffoldBackgroundColor: const Color.fromARGB(255, 42, 42, 42),
  primarySwatch: Colors.pink,
  textTheme: const TextTheme(
    bodyMedium: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w500,
      fontSize: 20,
    ),
    bodyLarge: TextStyle(
      color: Colors.white,
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    labelStyle: TextStyle(color: Colors.white),
    hintStyle: TextStyle(color: Colors.white),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.pink),
    ),
    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
    focusedErrorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.red),
    ),
  ),
);