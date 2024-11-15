import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:frontend_news_app/screens/news_list_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('offlineNews');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Directory',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NewsScreen(),
    );
  }
}
